import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:deals_dray_test/Api/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceInfo {
  late Services _services;
  final info = NetworkInfo();

  DeviceInfo(this._services);

  // Function to request location permission
  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted, proceed with fetching the location
      print('Location permission granted');
    } else if (status.isDenied) {
      // Permission denied
      print('Location permission denied');
    } else if (status.isPermanentlyDenied) {
      // Open app settings to enable permission
      openAppSettings();
    }
  }

  Future<void> deviceInfo() async {
    // First, request location permission
    await requestLocationPermission();

    // Ensure permission is granted before proceeding
    if (await Permission.location.isGranted) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Prepare device info data
      final Map<String, dynamic> data = {
        "deviceType": "android",
        "deviceId": androidInfo.id,
        "deviceName": androidInfo.model,
        "deviceOSVersion": androidInfo.version.release,
        "deviceIPAddress": await info.getWifiIP(),
        "lat": position.latitude,
        "long": position.longitude,
        "buyer_gcmid": "",
        "buyer_pemid": "",
        "app": {
          "version": "1.20.5",
          "installTimeStamp": "2022-02-10T12:33:30.696Z",
          "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
          "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
        }
      };

      // Send device info data to the server
      await _services.sendDeviceInfo(data);
    } else {
      print('Location permission not granted. Unable to fetch location.');
    }
  }
}
