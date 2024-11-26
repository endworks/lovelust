import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let isiOSAppOnMacChannel = FlutterMethodChannel(name: "works.end.Lovelust/isiOSAppOnMac", binaryMessenger: controller.binaryMessenger)
    isiOSAppOnMacChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      guard call.method == "isiOSAppOnMacChannel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.isiOSAppOnMacChannel(result: result)
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func isiOSAppOnMacChannel(result: FlutterResult) {
    var isiOSAppOnMac = false
    if #available(iOS 14.0, *) {
        isiOSAppOnMac = ProcessInfo.processInfo.isiOSAppOnMac
    }
    result(Bool(isiOSAppOnMac))
  }
}
