package yhx.pangle

import android.app.Activity
import com.bytedance.sdk.openadsdk.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel


class MapsPlugin : FlutterPlugin, ActivityAware {
  private lateinit var activity: Activity
  private lateinit var adNative: TTAdNative
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "pangle")
    channel.setMethodCallHandler { call, result ->
      when (call.method) {
        "init" -> {
          val args = call.arguments as Map<*, *>
          val config = TTAdConfig.Builder().appId(args["appId"] as String).build()
          TTAdSdk.init(binding.applicationContext, config)
          adNative = TTAdSdk.getAdManager().createAdNative(binding.applicationContext)
        }
        "showRewardAd" -> {
          val args = call.arguments as Map<*, *>
          val adSlot = AdSlot.Builder()
            .setCodeId(args["codeId"] as String)
            .setUserID(args["userId"] as String)
            .setOrientation(TTAdConstant.HORIZONTAL)
            .build()

          adNative.loadRewardVideoAd(adSlot, object : TTAdNative.RewardVideoAdListener {
            override fun onRewardVideoCached() {}
            override fun onRewardVideoAdLoad(ad: TTRewardVideoAd) {
              ad.setRewardAdInteractionListener(object : TTRewardVideoAd.RewardAdInteractionListener {
                override fun onAdShow() {}
                override fun onAdVideoBarClick() {}
                override fun onRewardVerify(p0: Boolean, p1: Int, p2: String?, p3: Int, p4: String?) {}
                override fun onVideoError() {}
                override fun onAdClose() {}
                override fun onVideoComplete() {
                  result.success(true)
                }

                override fun onSkippedVideo() {
                  result.success(false)
                }
              })
              ad.showRewardVideoAd(activity)
            }

            override fun onError(code: Int, message: String?) {
              result.error("$code", message, null)
            }
          })
        }
        else -> result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
  override fun onDetachedFromActivity() {}
}