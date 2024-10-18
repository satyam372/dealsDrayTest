import 'package:deals_dray_test/Api/cloud_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  late CloudServices _cloudServices;
  Services() {
    _cloudServices = CloudServices();
  }

  Future<bool> sendToken() async {
    try {
      final token = await getValue('auth-token');
      if (token == null) {
        return false;
      }
      final isValid = await _cloudServices.validateToken(token);
      return isValid;
    } catch (e) {
      return false;
    }
  }
}

Future<void> storeValue(String msg, String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(msg, token);
}

Future<String?> getValue(String msg) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(msg);  // Retrieve token
  return token;
}
