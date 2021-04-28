package qiuxiang.map_view

import android.content.Context
import android.view.View
import com.tencent.tencentmap.mapsdk.maps.CameraUpdateFactory
import com.tencent.tencentmap.mapsdk.maps.TencentMap
import com.tencent.tencentmap.mapsdk.maps.model.CameraPosition
import com.tencent.tencentmap.mapsdk.maps.model.LatLng
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import com.tencent.tencentmap.mapsdk.maps.MapView as TencentMapView

class MapView(context: Context, messenger: BinaryMessenger, id: Int, arguments: Any?) :
  PlatformView {
  private val view = TencentMapView(context)
  private val map: TencentMap = view.map
  private val channel = MethodChannel(messenger, "map_view_$id")

  init {
    view.onResume()
    channel.setMethodCallHandler { call, result ->
      when (call.method) {
        "getCameraPosition" -> {
          result.success(map.cameraPosition.toJson())
        }
        "scroll" -> {
          val args = call.arguments<List<Float>>()
          map.moveCamera(CameraUpdateFactory.scrollBy(args[0], args[1]))
          result.success(null)
//          val cameraPosition = map.cameraPosition
//          map.moveCamera(
//            CameraUpdateFactory.newCameraPosition(
//              CameraPosition(
//                map.projection.fromScreenLocation(Point(args[0], args[1])),
//                cameraPosition.zoom,
//                cameraPosition.tilt,
//                cameraPosition.bearing
//              )
//            )
//          )
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
      }
    }
  }

  override fun getView(): View {
    return view
  }

  override fun dispose() {
    view.onDestroy()
  }
}

private fun LatLng.toJson(): Map<String, *> {
  return mapOf(
    "latitude" to latitude,
    "longitude" to longitude,
  )
}

private fun CameraPosition.toJson(): Map<String, *> {
  return mapOf(
    "target" to target.toJson(),
    "tilt" to tilt,
    "bearing" to bearing,
    "zoom" to zoom,
  )
}
