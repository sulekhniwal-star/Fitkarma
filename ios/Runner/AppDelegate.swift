import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let CHANNEL = "fitkarma.healthos/thermal"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    
    let thermalChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: engineBridge.binaryMessenger)
    thermalChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getThermalHeadroom" {
        let state = ProcessInfo.processInfo.thermalState
        switch state {
        case .nominal:
          result(0.5)
        case .fair:
          result(0.8)
        case .serious:
          result(1.0)
        case .critical:
          result(1.5)
        @unknown default:
          result(0.0)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
  }
}

