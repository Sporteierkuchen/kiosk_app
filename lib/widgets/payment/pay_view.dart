
import 'package:flutter/material.dart';
import 'package:tetete/widgets/payment/payment_done_view.dart';
import 'package:tetete/widgets/payment/payment_progress_view.dart';

class PayView extends StatelessWidget {
  final bool paymentDone;
  final double progress; // 0..1
  final Animation<double> controller; // flexibler als AnimationController
  final String countText;
  final VoidCallback onOk;

  const PayView({
    super.key,
    required this.paymentDone,
    required this.progress,
    required this.controller,
    required this.countText,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      alignment: AlignmentDirectional.center,
      child: paymentDone
          ? PaymentDoneView(onOk: onOk)
          : PaymentProgressView(
            progress: progress,
            controller: controller,
            countText: countText,
          ),
    );
  }
}