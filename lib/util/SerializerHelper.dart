import 'dart:convert';

import 'package:intl/intl.dart';

class SerializerHelper {

  static String fromIntList(List<int>? bytes){
    return Base64Encoder().convert(bytes!);
  }
  static BigInt? bigIntFromJson(Object? i) {
    if(i == null){
      return null;
    }
    if (i is double) {
      return BigInt.from(i);
    }

    if (i is int) {
      return BigInt.from(i);
    }
    if (i is String) {
      return   BigInt.parse(i);
    }
    return BigInt.zero;
  }

  static BigInt bigIntFromJsonNotNull(Object? i) {
    if(i == null){
      throw Exception("bigIntFromJsonNotNull: i is null");
    }
    if (i is double) {
      return BigInt.from(i);
    }

    if (i is int) {
      return BigInt.from(i);
    }
    if (i is String) {
      return   BigInt.parse(i);
    }
    return BigInt.zero;
  }

  static String? toDateTimeJson(DateTime? i) {
    if(i == null){
      return null;
    }
    String result = formatISOTime(i);
    return result;
  }

  static String formatISOTime2(DateTime date) {

    //converts date into the following format: 2024-02-21T10:58:31.867537
    // into 2024-02-21T10:58:31.867+01:00

    var duration = date.timeZoneOffset;
    if (duration.isNegative) {
      return ("${DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(date)}-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0').padLeft(3,":")}");
    } else {
      return ("${DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(date)}+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0').padLeft(3,":")}");
    }
  }

 static String formatISOTime(DateTime date) {

    //converts date into the following format: 2024-02-21T10:58:31.867537
    // into 2024-02-21T10:58:31+0100

    var duration = date.timeZoneOffset;
    if (duration.isNegative) {
      return ("${DateFormat("yyyy-MM-ddTHH:mm:ss").format(date)}-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    } else {
      return ("${DateFormat("yyyy-MM-ddTHH:mm:ss").format(date)}+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    }
  }


}
