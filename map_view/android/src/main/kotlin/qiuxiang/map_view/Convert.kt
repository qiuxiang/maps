package qiuxiang.map_view

import android.location.Location
import com.tencent.tencentmap.mapsdk.maps.model.CameraPosition
import com.tencent.tencentmap.mapsdk.maps.model.LatLng

private fun LatLng.toJson(): Map<String, *> {
  return mapOf(
    "latitude" to latitude,
    "longitude" to longitude,
  )
}

fun CameraPosition.toJson(): Map<String, *> {
  return mapOf(
    "target" to target.toJson(),
    "tilt" to tilt,
    "bearing" to bearing,
    "zoom" to zoom,
  )
}

fun Location.toJson(): Map<String, *> {
  return mapOf(
    "latitude" to latitude,
    "longitude" to longitude,
    "accuracy" to accuracy,
    "bearing" to bearing,
  )
}

fun Map<*, *>.toLatLng(): LatLng {
  return LatLng(this["latitude"] as Double, this["longitude"] as Double)
}
