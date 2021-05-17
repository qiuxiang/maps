package qiuxiang.map_view

import android.content.Context
import com.tencent.tencentmap.mapsdk.maps.TencentMap
import com.tencent.tencentmap.mapsdk.maps.model.BitmapDescriptor
import com.tencent.tencentmap.mapsdk.maps.model.BitmapDescriptorFactory
import com.tencent.tencentmap.mapsdk.maps.model.LatLng
import com.tencent.tencentmap.mapsdk.maps.model.MarkerOptions
import com.tencent.tencentmap.mapsdk.vector.utils.clustering.ClusterManager
import com.tencent.tencentmap.mapsdk.vector.utils.clustering.view.DefaultClusterRenderer
import com.tencent.tencentmap.mapsdk.vector.utils.clustering.ClusterItem as Item

class ClusterRenderer(
  context: Context?,
  map: TencentMap?,
  manager: ClusterManager<ClusterItem>
) :
  DefaultClusterRenderer<ClusterItem>(context, map, manager) {

  override fun onBeforeClusterItemRendered(item: ClusterItem, marker: MarkerOptions) {
    item.icon?.let { marker.icon(it) }
  }
}

class ClusterItem(private val latLng: LatLng, private val asset: String?) : Item {
  override fun getPosition(): LatLng {
    return latLng
  }

  val icon: BitmapDescriptor?
    get() = asset?.let { BitmapDescriptorFactory.fromAsset(it) }
}
