import 'package:encrypt/encrypt.dart' as encrypt;

  final key = encrypt.Key.fromSecureRandom(32);
  final iv = encrypt.IV.fromSecureRandom(16);

  encrypt.Encrypted encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encryptedData = encrypter.encrypt(data, iv: iv);
    return encryptedData;
  }
