package qiuxiang.map_view

import android.content.Context
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
import com.tencent.tencentmap.mapsdk.maps.model.MyLocationStyle.LOCATION_TYPE_MAP_ROTATE_NO_CENTER
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import com.tencent.tencentmap.mapsdk.maps.MapView as TencentMapView

class MapView(context: Context, val binding: FlutterPluginBinding, id: Int) : PlatformView {
  private val view = TencentMapView(context)
  lateinit var locationListener: OnLocationChangedListener
  val map: TencentMap = view.map
  private val channel = MethodChannel(binding.binaryMessenger, "map_view_$id")
  private val markers = HashMap<String, MapViewMarker>()

  init {
    view.onResume()
    initLocation()

    map.setOnMapClickListener {
      channel.invokeMethod("onTap", it.toJson())
    }
    map.setOnMapPoiClickListener {
      channel.invokeMethod("onTapPoi", it.toJson())
    }
    map.setOnMapLongClickListener {
      channel.invokeMethod("onLongPress", it.toJson())
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
        }
        "rotate" -> {
          map.moveCamera(CameraUpdateFactory.rotateTo(call.arguments(), map.cameraPosition.tilt))
          result.success(null)
        }
        "moveCamera" -> {
          val default = map.cameraPosition
          map.animateCamera(
            CameraUpdateFactory.newCameraPosition(
              CameraPosition(
                call.argument<Map<String, Double>>("target")?.toLatLng() ?: default.target,
                call.argument<Double>("zoom")?.toFloat() ?: default.zoom,
                call.argument<Double>("tilt")?.toFloat() ?: default.tilt,
                call.argument<Double>("bearing")?.toFloat() ?: default.bearing,
              )
            ),
            call.argument<Int>("duration")?.toLong() ?: 1000,
            object : TencentMap.CancelableCallback {
              override fun onFinish() {}
              override fun onCancel() {}
            }
          )
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
        else -> result.notImplemented()
      }
    }
  }

  private fun initLocation() {
    val manager = TencentLocationManager.getInstance(binding.applicationContext)
    val request = TencentLocationRequest.create()
    manager.requestLocationUpdates(request, object : TencentLocationListener {
      override fun onStatusUpdate(name: String, status: Int, description: String) {}
      override fun onLocationChanged(location: TencentLocation, error: Int, reason: String) {
        locationListener.onLocationChanged(Location(location.provider).apply {
          latitude = location.latitude
          longitude = location.longitude
          accuracy = location.accuracy
          bearing = location.bearing
        })
      }
    })
    map.setLocationSource(object : LocationSource {
      override fun deactivate() {}
      override fun activate(listener: OnLocationChangedListener) {
        locationListener = listener
      }
    })
    map.setMyLocationStyle(MyLocationStyle().myLocationType(LOCATION_TYPE_MAP_ROTATE_NO_CENTER))
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
