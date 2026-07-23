import Flutter
import UIKit

// §P6-F Adaptive Computer Vision Loop — iOS Thermal Bridge
// Registers MethodChannel('fitkarma.healthos/thermal') mapping
// ProcessInfo.thermalState to equivalent headroom multipliers.
@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let thermalChannel = "fitkarma.healthos/thermal"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: thermalChannel,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { (call, result) in
        if call.method == "getThermalHeadroom" {
          // Map iOS ProcessInfo thermal state → equivalent headroom multipliers
          let state = ProcessInfo.processInfo.thermalState
          switch state {
          case .nominal:
            result(0.5)  // Normal — full pipeline active
          case .fair:
            result(0.8)  // Moderate thermal load — approaching limit
          case .serious:
            result(1.0)  // Significant load — throttling required
          case .critical:
            result(1.5)  // Critical state — maximum downsampling
          @unknown default:
            result(0.0)
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
