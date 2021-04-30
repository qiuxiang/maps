package qiuxiang.map_view

import com.tencent.tencentmap.mapsdk.maps.model.BitmapDescriptor
import com.tencent.tencentmap.mapsdk.maps.model.BitmapDescriptorFactory
import com.tencent.tencentmap.mapsdk.maps.model.Marker
import com.tencent.tencentmap.mapsdk.maps.model.MarkerOptions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MapViewMarker(private val mapView: MapView, call: MethodCall) : MethodCallHandler {
  private var marker: Marker
  private var channel: MethodChannel

  val id: String get() = marker.id

  init {
    val options = MarkerOptions((call.argument<Map<*, *>>("position"))!!.toLatLng())
    options.anchor(0.5f, 1f)
    getIcon(call)?.let { options.icon(it) }
    marker = mapView.map.addMarker(options)
    channel = MethodChannel(mapView.binding.binaryMessenger, "map_view_marker_$id")
    channel.setMethodCallHandler(this)
  }

  fun remove() {
    marker.remove()
  }

  private fun getIcon(call: MethodCall): BitmapDescriptor? {
    return call.argument<String>("asset")?.let {
      BitmapDescriptorFactory.fromAsset(mapView.binding.flutterAssets.getAssetFilePathByName(it))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "remove" -> {
        marker.remove()
        result.success(null)
      }
      "update" -> {
        val args = call.arguments as Map<*, *>
        marker.position = (args["position"] as Map<*, *>).toLatLng()
        getIcon(call)?.let { marker.setIcon(it) }
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }
}
