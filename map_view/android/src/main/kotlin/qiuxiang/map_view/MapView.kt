package qiuxiang.map_view

import android.content.Context
import android.content.Context.SENSOR_SERVICE
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.location.Location
import android.view.View
import com.tencent.map.geolocation.TencentLocation
import com.tencent.map.geolocation.TencentLocationListener
import com.tencent.map.geolocation.TencentLocationManager
import com.tencent.map.geolocation.TencentLocationRequest
import com.tencent.tencentmap.mapsdk.maps.CameraUpdateFactory
import com.tencent.tencentmap.mapsdk.maps.LocationSource
import com.tencent.tencentmap.mapsdk.maps.LocationSource.OnLocationChangedListener
import com.tencent.tencentmap.mapsdk.maps.TencentMap
import com.tencent.tencentmap.mapsdk.maps.model.CameraPosition
import com.tencent.tencentmap.mapsdk.maps.model.MyLocationStyle
import com.tencent.tencentmap.mapsdk.maps.model.MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER
import com.tencent.tencentmap.mapsdk.vector.utils.clustering.ClusterManager
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlin.math.PI
import com.tencent.tencentmap.mapsdk.maps.MapView as TencentMapView


class MapView(
  private val context: Context, val binding: FlutterPluginBinding, id: Int
) : PlatformView {
  private var location: Location? = null
  private val view = TencentMapView(context)
  val map: TencentMap = view.map
  private val channel = MethodChannel(binding.binaryMessenger, "map_view_$id")
  private val markers = HashMap<String, MapViewMarker>()
  private val clusterItems = mutableListOf<ClusterItem>()

  init {
    view.onResume()
    initLocation()
    val clusterManager = ClusterManager<ClusterItem>(context, map)
    clusterManager.renderer = ClusterRenderer(context, map, clusterManager)
    clusterManager.setOnClusterItemClickListener {
      channel.invokeMethod("onTapClusterItem", clusterItems.indexOf(it))
      true
    }

    map.uiSettings.isScrollGesturesEnabled = false
    map.uiSettings.isZoomGesturesEnabled = false
    map.uiSettings.isTiltGesturesEnabled = false
    map.uiSettings.isRotateGesturesEnabled = false

    map.setOnMapClickListener {
      channel.invokeMethod("onTap", it.toJson())
    }
    map.setOnMapPoiClickListener {
      channel.invokeMethod("onTapPoi", it.toJson())
    }
    map.setOnMapLongClickListener {
      channel.invokeMethod("onLongPress", it.toJson())
    }
    map.setOnMarkerClickListener {
      if (!clusterManager.onMarkerClick(it)) {
        channel.invokeMethod("onTapMarker", it.id)
      }
      true
    }

    channel.setMethodCallHandler { call, result ->
      when (call.method) {
        "setMapType" -> {
          map.mapType = call.arguments()
          result.success(null)
        }
        "getCameraPosition" -> {
          result.success(map.cameraPosition.toJson())
        }
        "getLocation" -> {
          result.success(map.myLocation.toJson())
        }
        "scroll" -> {
          val args = call.arguments<List<Float>>()
          map.moveCamera(CameraUpdateFactory.scrollBy(args[0], args[1]))
          result.success(null)
        }
        "zoom" -> {
          val args = call.arguments<List<Float>>()
          map.moveCamera(CameraUpdateFactory.zoomTo(args[0]))
          result.success(null)
          clusterManager.onCameraChangeFinished(map.cameraPosition)
        }
        "rotate" -> {
          map.moveCamera(CameraUpdateFactory.rotateTo(call.arguments(), map.cameraPosition.tilt))
          result.success(null)
        }
        "moveCamera" -> {
          val default = map.cameraPosition
          val duration = call.argument<Int>("duration")?.toLong() ?: 0
          val position = CameraUpdateFactory.newCameraPosition(
            CameraPosition(
              call.argument<Map<String, Double>>("target")?.toLatLng() ?: default.target,
              call.argument<Double>("zoom")?.toFloat() ?: default.zoom,
              call.argument<Double>("tilt")?.toFloat() ?: default.tilt,
              call.argument<Double>("bearing")?.toFloat() ?: default.bearing,
            )
          )
          if (duration == 0L) {
            map.moveCamera(position)
          } else {
            map.animateCamera(position, duration, object : TencentMap.CancelableCallback {
              override fun onFinish() {}
              override fun onCancel() {}
            })
          }
          result.success(null)
        }
        "addMarker" -> {
          val marker = MapViewMarker(this, call)
          markers[marker.id] = marker
          result.success(marker.id)
        }
        "removeMarker" -> {
          markers[call.arguments]?.remove()
          result.success(null)
        }
        "addClusterItems" -> {
          val items = call.arguments<List<Map<*, *>>>().map {
            ClusterItem(
              (it["position"] as Map<*, *>).toLatLng(),
              (it["asset"] as? String)?.let { i -> binding.flutterAssets.getAssetFilePathByName(i) }
            )
          }
          clusterItems.addAll(items)
          clusterManager.addItems(items)
          clusterManager.onCameraChangeFinished(map.cameraPosition)
        }
        "clearClusterItems" -> {
          clusterItems.clear()
          clusterManager.clearItems()
          clusterManager.onCameraChangeFinished(map.cameraPosition)
        }
        else -> result.notImplemented()
      }
    }
  }

  private fun initLocation() {
    lateinit var locationListener: OnLocationChangedListener
    var accelerometer: FloatArray? = null
    var magnetic: FloatArray? = null
    val sensorManager = context.getSystemService(SENSOR_SERVICE) as SensorManager
    fun registerListener(type: Int) {
      sensorManager.registerListener(
        object : SensorEventListener {
          override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}
          override fun onSensorChanged(event: SensorEvent) {
            if (type == Sensor.TYPE_ACCELEROMETER) {
              accelerometer = event.values
            }
            if (type == Sensor.TYPE_MAGNETIC_FIELD) {
              magnetic = event.values
            }
            if (magnetic != null && accelerometer != null) {
              val r = FloatArray(9)
              val i = FloatArray(9)
              if (SensorManager.getRotationMatrix(r, i, accelerometer, magnetic)) {
                val orientation = FloatArray(3)
                SensorManager.getOrientation(r, orientation)
                location?.apply {
                  bearing = ((orientation[0] * 180 / PI + 360) % 360).toFloat()
                }?.let {
                  locationListener.onLocationChanged(it)
                  channel.invokeMethod("onLocation", it.toJson())
                }
              }
            }
          }
        },
        sensorManager.getDefaultSensor(type),
        SensorManager.SENSOR_DELAY_UI,
      )
    }
    registerListener(Sensor.TYPE_ACCELEROMETER)
    registerListener(Sensor.TYPE_MAGNETIC_FIELD)

    val manager = TencentLocationManager.getInstance(binding.applicationContext)
    val request = TencentLocationRequest.create()
    manager.requestLocationUpdates(request, object : TencentLocationListener {
      override fun onStatusUpdate(name: String, status: Int, description: String) {}
      override fun onLocationChanged(value: TencentLocation, error: Int, reason: String) {
        location = Location(value.provider).apply {
          latitude = value.latitude
          longitude = value.longitude
          accuracy = value.accuracy
          bearing = location?.bearing ?: 0f
        }
        locationListener.onLocationChanged(location)
      }
    })
    map.setLocationSource(object : LocationSource {
      override fun deactivate() {}
      override fun activate(listener: OnLocationChangedListener) {
        locationListener = listener
      }
    })
    map.setMyLocationStyle(MyLocationStyle().myLocationType(LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER))
    map.isMyLocationEnabled = true
  }

  override fun getView(): View {
    return view
  }

  override fun dispose() {
    view.onDestroy()
  }

  override fun onFlutterViewDetached() {
    channel.setMethodCallHandler(null)
  }
}