import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<Map<String, String>> getDeviceDetails() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'model': androidInfo.model,
          'os': 'Android ${androidInfo.version.release}',
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'model': iosInfo.utsname.machine,
          'os': 'iOS ${iosInfo.systemVersion}',
        };
      }
    } catch (e) {
      print('Device Info Error: $e');
    }
    return {'model': 'Unknown Device', 'os': 'Unknown OS'};
  }
}
