import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class PaymentProgressView extends StatelessWidget {
  final double progress; // 0..1
  final Animation<double> controller;
  final String countText;

  const PaymentProgressView({
    super.key,
    required this.progress,
    required this.controller,
    required this.countText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: Platform.isAndroid ? 150 : 200,
              height: Platform.isAndroid ? 150 : 200,
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                color: Colors.greenAccent,
                value: progress,
                strokeWidth: Platform.isAndroid ? 10 : 20,
              ),
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Text(
                countText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Platform.isAndroid ? 60 : 100,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(Platform.isAndroid ? 20 : 40),
          child: Text(
            "Bestellung wird bezahlt...",
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
    );
  }
}
