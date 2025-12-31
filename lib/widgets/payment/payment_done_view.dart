import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class PaymentDoneView extends StatelessWidget {
  final VoidCallback onOk;

  const PaymentDoneView({
    super.key,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.green,
              radius: 20,
              child: Icon(Icons.done, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Bestellung erfolgreich bezahlt!",
                softWrap: true,
                style: TextStyle(
                  height: 0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: Platform.isAndroid ? 20 : 30,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Platform.isAndroid ? 10 : 20),
        ElevatedButton(
          onPressed: onOk,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[300],
            side: const BorderSide(color: Colors.black, width: 1),
            padding: EdgeInsets.symmetric(
              horizontal: Platform.isAndroid ? 20 : 40,
              vertical: Platform.isAndroid ? 10 : 25,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: Platform.isAndroid ? 14 : 25,
              height: 0,
            ),
          ),
        ),
      ],
    );
  }
}
