import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class CartDialogs {
  static Future<bool> confirmClearCart(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            "Bitte bestätigen!",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: Platform.isAndroid ? 25 : 30,
            ),
          ),
          content: Text(
            "Soll der Warenkorb wirklich geleert werden?",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: Platform.isAndroid ? 20 : 25,
            ),
          ),
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
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Ja',
                    textAlign: TextAlign.center,
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
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Nein',
                    textAlign: TextAlign.center,
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

  static Future<bool> confirmRemoveArticle(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            "Bitte bestätigen!",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: Platform.isAndroid ? 25 : 30,
            ),
          ),
          content: Text(
            "Soll der Artikel wirklich entfernt werden?",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: Platform.isAndroid ? 20 : 25,
            ),
          ),
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
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Ja',
                    textAlign: TextAlign.center,
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
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Nein',
                    textAlign: TextAlign.center,
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

  static Future<bool> confirmRemoveExtra(BuildContext context) async {
    // Text bleibt wie bei dir (du verwendest im Original den gleichen Dialogtext)
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            "Bitte bestätigen!",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: Platform.isAndroid ? 25 : 30,
            ),
          ),
          content: Text(
            "Soll der Artikel wirklich entfernt werden?",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: Platform.isAndroid ? 20 : 25,
            ),
          ),
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
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Ja',
                    textAlign: TextAlign.center,
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
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Nein',
                    textAlign: TextAlign.center,
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
}
