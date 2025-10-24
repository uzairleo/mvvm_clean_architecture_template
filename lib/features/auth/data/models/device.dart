/// This file defines the Device class, which represents a device in the Zarpay application.
/// The class includes properties for device information, methods for JSON serialization and deserialization,
/// and a method for creating a copy of the device with modified properties.

/// The Device class represents a device in the Zarpay application.
class Device {
  final String? pushId;
  final String deviceId;
  final String deviceModel;
  final String platformType;

  /// Constructor for the Device class.
  ///
  /// [pushId] The push notification ID of the device.
  /// [deviceId] The unique ID of the device.
  /// [deviceModel] The model of the device.
  /// [platformType] The platform type of the device (e.g., android, ios).
  Device({
    this.pushId,
    required this.deviceId,
    required this.deviceModel,
    required this.platformType,
  });

  /// Factory constructor to create a Device instance from a JSON map.
  ///
  /// [json] The JSON map containing device data.
  /// Returns a Device instance.
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      pushId: json["push_id"],
      deviceId: json["device_id"],
      deviceModel: json["device_model"],
      platformType: json["platform_type"],
    );
  }

  /// Converts the Device instance to a JSON map.
  ///
  /// Returns a JSON map representing the device data.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json["push_id"] = pushId;
    json["device_id"] = deviceId;
    json["device_model"] = deviceModel;
    json["platform_type"] = platformType;
    return json;
  }

  /// Creates a copy of the Device instance with modified properties.
  ///
  /// [deviceId] The new device ID.
  /// [deviceModel] The new device model.
  /// [platformType] The new platform type.
  /// Returns a new Device instance with the updated properties.
  Device copyWith(final String deviceId, final String deviceModel,
      final String platformType) {
    return Device(
      deviceId: deviceId,
      deviceModel: deviceModel,
      platformType: platformType,
    );
  }
}
