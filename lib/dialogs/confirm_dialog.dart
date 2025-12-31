import 'dart:io' show Platform;
import 'package:flutter/material.dart';

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String yesText = "Ja",
  String noText = "Nein",
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.grey[300],
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: Platform.isAndroid ? 25 : 30,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: Platform.isAndroid ? 20 : 25,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Platform.isAndroid
              ? MediaQuery.of(context).size.width * 0
              : MediaQuery.of(context).size.width * 0.15,
          vertical: Platform.isAndroid
              ? MediaQuery.of(context).size.height * 0.05
              : MediaQuery.of(context).size.height * 0.1,
        ),
        alignment: AlignmentDirectional.center,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Platform.isAndroid ? 10 : 20,
                  vertical: Platform.isAndroid ? 10 : 20,
                ),
                minWidth: Platform.isAndroid
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.15,
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  yesText,
                  style: TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: Platform.isAndroid ? 18 : 25,
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Platform.isAndroid ? 10 : 20,
                  vertical: Platform.isAndroid ? 10 : 20,
                ),
                minWidth: Platform.isAndroid
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.15,
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  noText,
                  style: TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: Platform.isAndroid ? 18 : 25,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );

  return result ?? false;
}
