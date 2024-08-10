import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  final storage = new FlutterSecureStorage();

  static const bool xUserKey = false;
  static const String imageUrl = 'image';
  static const String username = 'username';

  //STRING CONSTANTS FOR E-PENSION
  //TODO : PLEASE WRITE STRING CONSTANTS BELOW IF IT IS RELATED TO E-PENSION

  Future<void> setValue(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<void> setBoolValue(String key, bool value) async {
    await storage.write(key: key, value: value.toString());
  }

  Future<String> getValue(String key) async {
    return await storage.read(key: key) ?? "";
  }

  Future<void> deleteValue(String key) async {
    return await storage.delete(key: key);
  }

  Future<Map<String, String>> getAll() async {
    return await storage.readAll();
  }

  Future<void> deleteAll() async {
    return await storage.deleteAll();
  }
}
