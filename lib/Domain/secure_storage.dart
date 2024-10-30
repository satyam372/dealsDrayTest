import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'exception.dart';

/// Provides secure key-value storage functionality using flutter_secure_storage.
/// Used for storing sensitive data like authentication tokens and user information.
class SecureStorage {
  final _storage = FlutterSecureStorage();

  IOSOptions _getIOSOptions() =>
      IOSOptions(
        accountName: '_secure_storage_services',
        accessibility: IOSAccessibility.first_unlock,
      );

  AndroidOptions _getAndroidOptions() => AndroidOptions();

  Future<void> storeValue(String key, String value) async {
    if (key.isEmpty || value.isEmpty) {
      throw ArgumentError('key and value must not be empty');
    }
    try {
      await _storage.write(
        key: key,
        value: value,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      throw StorageException('Failed to store value: $e');
    }
  }

  Future<String?> getValue(String key) async {
    final result = await _storage.read(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return result;
  }


  Future<void> clearData() async {
    await _storage.deleteAll();
  }
}
