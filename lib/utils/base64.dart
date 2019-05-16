import 'dart:convert';

class Base64Utils {

  static String decode(String source) => utf8.decode(base64.decode(source));

}