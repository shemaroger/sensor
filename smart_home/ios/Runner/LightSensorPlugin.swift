import Flutter
import UIKit
import CoreMotion

public class SwiftLightSensorPlugin: NSObject, FlutterPlugin {
  private let motionManager = CMMotionManager()
  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterEventChannel(name: "light_sensor", binaryMessenger: registrar.messenger())
    let instance = SwiftLightSensorPlugin()
    channel.setStreamHandler(instance)
  }

  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = eventSink
    startLightSensorUpdates()
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    stopLightSensorUpdates()
    eventSink = nil
    return nil
  }

  private func startLightSensorUpdates() {
    guard motionManager.isDeviceMotionAvailable else { return }
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
    motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion, error) in
      guard let motion = motion else { return }
      let lightLevel = motion.ambientLightSensor
      self.eventSink?(lightLevel)
    }
  }

  private func stopLightSensorUpdates() {
    motionManager.stopDeviceMotionUpdates()
  }
}
