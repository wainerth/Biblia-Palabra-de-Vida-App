import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceService {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    final packageInfo = await PackageInfo.fromPlatform();

    Map<String, dynamic> deviceData = {};

    if (deviceInfo is IosDeviceInfo) {
      final iosInfo = deviceInfo;
      deviceData = {
        'deviceId': iosInfo.identifierForVendor ?? _generateFallbackId(),
        'platform': 'ios',
        'appVersion': packageInfo.version,
        'appBuild': packageInfo.buildNumber,
        'deviceModel': iosInfo.model ?? 'iPhone',
        'osVersion': iosInfo.systemVersion ?? '',
        'deviceName': iosInfo.name ?? '',
        'systemName': iosInfo.systemName ?? 'iOS',
        'deviceType': _getIOSDeviceType(iosInfo),
        'isPhysicalDevice': iosInfo.isPhysicalDevice,
      };
    } else if (deviceInfo is AndroidDeviceInfo) {
      final androidInfo = deviceInfo;
      deviceData = {
        'deviceId': androidInfo.id ?? _generateFallbackId(),
        'platform': 'android',
        'appVersion': packageInfo.version,
        'appBuild': packageInfo.buildNumber,
        'deviceModel': androidInfo.model ?? '',
        'osVersion': androidInfo.version.release ?? '',
        'deviceBrand': androidInfo.brand ?? '',
        'deviceManufacturer': androidInfo.manufacturer ?? '',
        'sdkVersion': androidInfo.version.sdkInt?.toString() ?? '',
        'isPhysicalDevice': androidInfo.isPhysicalDevice,
      };
    }
    PreferencesManager().setDeviceInfo(deviceData);
    return deviceData;
  }

  static String _generateFallbackId() {
    return 'fallback_${DateTime.now().millisecondsSinceEpoch}';
  }

  static String _getIOSDeviceType(IosDeviceInfo iosInfo) {
    final model = iosInfo.utsname.machine ?? '';
    if (model.contains('iPad')) return 'tablet';
    if (model.contains('iPod')) return 'ipod';
    return 'phone';
  }
}
