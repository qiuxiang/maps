package qiuxiang.map_view

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MapViewFactory(private val binding: FlutterPlugin.FlutterPluginBinding) :
  PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context, id: Int, args: Any?): PlatformView {
    return MapView(context, binding, id)
  }
}
