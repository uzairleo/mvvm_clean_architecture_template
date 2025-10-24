/// This file defines the DeviceRepositoryImpl class, which implements the DeviceRepository interface.
/// It provides a concrete implementation for retrieving device information in the Zarpay application.

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:zarpay/app/features/auth/data/models/device.dart';
import 'package:zarpay/app/features/auth/domain/repository/device_repository.dart';

/// The DeviceRepositoryImpl class implements the DeviceRepository interface.
///
/// This class provides a concrete implementation for retrieving device information
/// by interacting with the device_info_plus package.
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceInfoPlugin _deviceInfo;

  /// Constructor for the DeviceRepositoryImpl class.
  ///
  /// [deviceInfo] The DeviceInfoPlugin instance used to retrieve device information.
  DeviceRepositoryImpl(this._deviceInfo);

  /// Retrieves device information.
  ///
  /// Returns a Future containing a Device object with the device information.
  @override
  Future<Device> getDeviceInformation() async {
    Device device = Device(
        deviceId: 'Unknown', deviceModel: 'Unknown', platformType: 'Unknown');
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      device = device.copyWith(androidInfo.id, androidInfo.model, 'android');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      device = device.copyWith(iosInfo.identifierForVendor ?? 'Unknown',
          iosInfo.utsname.machine, 'ios');
    }
    return device;
  }
}
