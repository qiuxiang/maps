package qiuxiang.maps

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.material.FloatingActionButton
import androidx.compose.material.Icon
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import com.tencent.tencentmap.mapsdk.maps.MapView
import com.tencent.tencentmap.mapsdk.maps.TencentMap
import com.tencent.tencentmap.mapsdk.maps.TextureMapView

class MainActivity : ComponentActivity() {
  private lateinit var mapView: MapView
  val map: TencentMap get() = mapView.map

  override fun onCreate(bundle: Bundle?) {
    super.onCreate(bundle)
    mapView = TextureMapView(this)
    setContent {
      Box {
        AndroidView(factory = { mapView })
        FloatingActionButton(
          onClick = {},
          Modifier
            .align(Alignment.BottomEnd)
            .padding(bottom = 16.dp, end = 16.dp),
          backgroundColor = Color.White
        ) {
          Icon(Icons.Filled.LocationOn, "")
        }
      }
    }
  }

  override fun onResume() {
    super.onResume()
    mapView.onResume()
  }

  override fun onPause() {
    super.onPause()
    mapView.onPause()
  }

  override fun onDestroy() {
    super.onDestroy()
    mapView.onDestroy()
  }

  override fun onStart() {
    super.onStart()
    mapView.onStart()
  }

  override fun onStop() {
    super.onStop()
    mapView.onStop()
  }
}