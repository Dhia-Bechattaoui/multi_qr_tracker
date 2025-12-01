import Flutter
import UIKit

public class SwiftMultiQrTrackerPlugin: NSObject, FlutterPlugin {
  private var camera: MultiQrTrackerCamera?
  private let registry: FlutterTextureRegistry
  private let messenger: FlutterBinaryMessenger
  private let channel: FlutterMethodChannel

  init(registry: FlutterTextureRegistry, messenger: FlutterBinaryMessenger, channel: FlutterMethodChannel) {
    self.registry = registry
    self.messenger = messenger
    self.channel = channel
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "multi_qr_tracker", binaryMessenger: registrar.messenger())
    let instance = SwiftMultiQrTrackerPlugin(registry: registrar.textures(), messenger: registrar.messenger(), channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
        if let args = call.arguments as? [String: Any],
           let orientation = args["orientation"] as? String {
            if camera == nil {
                camera = MultiQrTrackerCamera(registry: registry, messenger: messenger, channel: channel)
            }
            camera?.initialize(orientation: orientation, result: result)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Orientation is required", details: nil))
        }
    case "startCamera":
        camera?.start(result: result)
    case "stopCamera":
        camera?.stop(result: result)
    case "dispose":
        camera?.dispose()
        camera = nil
        result(nil)
    case "enableTorch":
        if let args = call.arguments as? [String: Any],
           let enabled = args["enabled"] as? Bool {
            camera?.enableTorch(enabled: enabled, result: result)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Enabled flag is required", details: nil))
        }
    case "getLightLevel":
        camera?.getLightLevel(result: result)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
