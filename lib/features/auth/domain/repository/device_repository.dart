/// This file defines the DeviceRepository abstract class, which provides an interface
/// for retrieving device information in the Zarpay application.

import 'package:zarpay/app/features/auth/data/models/device.dart';

/// The DeviceRepository abstract class provides an interface for device-related operations.
abstract class DeviceRepository {
  /// Retrieves device information.
  ///
  /// Returns a Future containing a Device object with the device information.
  Future<Device> getDeviceInformation();
}
