import 'dart:math';

import 'package:encrypt/encrypt.dart' as crypt;

String randomString(int length) {
  const _randomChars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  const _charsLength = _randomChars.length;

  final rand = Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(n);
    },
  );

  return String.fromCharCodes(codeUnits);
}

String encryptText(String ivKey, String inputKey, String plainText) {
  if (inputKey.length < 32) {
    for (var i = inputKey.length; i < 32; i++) {
      inputKey += "0";
    }
  }

  if (ivKey.length < 16) {
    for (var i = ivKey.length; i < 16; i++) {
      ivKey += "0";
    }
  }

  final key = crypt.Key.fromUtf8(inputKey);
  final iv = crypt.IV.fromUtf8(ivKey);
  // final iv = crypt.IV.fromLength(16);

  final encrypter = crypt.Encrypter(crypt.AES(key, mode: crypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return encrypted.base64;
}

String decryptText(String ivKey, String inputKey, String encryptedText) {
  if (inputKey.length < 32) {
    for (var i = inputKey.length; i < 32; i++) {
      inputKey += "0";
    }
  }

  if (ivKey.length < 16) {
    for (var i = ivKey.length; i < 16; i++) {
      ivKey += "0";
    }
  }

  final key = crypt.Key.fromUtf8(inputKey);
  final iv = crypt.IV.fromUtf8(ivKey);
  // final iv = crypt.IV.fromLength(16);

  final encrypter = crypt.Encrypter(crypt.AES(key, mode: crypt.AESMode.cbc));
  final decrypted =
      encrypter.decrypt(crypt.Encrypted.fromBase64(encryptedText), iv: iv);

  return decrypted.toString();
}
