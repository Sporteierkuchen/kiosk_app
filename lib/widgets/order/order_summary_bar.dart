import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class OrderSummaryBar extends StatelessWidget {
  final bool showBezahlen;
  final bool showWarenkorb;

  final bool cartNotEmpty;
  final int itemCount;
  final String totalText;

  final VoidCallback onBackFromCart;
  final VoidCallback onPay;
  final VoidCallback onCancelCart;
  final VoidCallback onShowCart;

  const OrderSummaryBar({
    super.key,
    required this.showBezahlen,
    required this.showWarenkorb,
    required this.cartNotEmpty,
    required this.itemCount,
    required this.totalText,
    required this.onBackFromCart,
    required this.onPay,
    required this.onCancelCart,
    required this.onShowCart,
  });

  @override
  Widget build(BuildContext context) {
    final height = Platform.isAndroid || MediaQuery.of(context).size.height <= 1800
        ? (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.25
        : (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.2;

    return Container(
      height: height,
      color: Colors.white,
      child: showBezahlen
          ? Container(color: Colors.white)
          : Column(
        children: [
          Container(
            color: Colors.green,
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "Meine Bestellung",
                style: TextStyle(height: 0, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: showWarenkorb ? _PaymentLogosAndTotal(totalText: totalText) : _CartSummary(cartNotEmpty: cartNotEmpty, itemCount: itemCount, totalText: totalText),
          ),
          Container(
            color: Colors.grey[350],
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: Platform.isAndroid ? 5 : 25),
            child: showWarenkorb
                ? _CartActionButtonsPay(onBack: onBackFromCart, onPay: onPay)
                : _CartActionButtonsSummary(cartNotEmpty: cartNotEmpty, onCancel: onCancelCart, onShowCart: onShowCart),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final bool cartNotEmpty;
  final int itemCount;
  final String totalText;

  const _CartSummary({required this.cartNotEmpty, required this.itemCount, required this.totalText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: cartNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Anzahl Artikel: $itemCount",
              style: TextStyle(height: 0, fontWeight: FontWeight.bold, fontSize: Platform.isAndroid ? 15 : 25, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "Gesamtpreis: ${totalText}€",
                style: TextStyle(height: 0, fontWeight: FontWeight.bold, fontSize: Platform.isAndroid ? 20 : 30, color: Colors.black),
              ),
            ),
          ],
        )
            : Text(
          "Ihre Bestellung ist leer!",
          style: TextStyle(height: 0, fontWeight: FontWeight.bold, fontSize: Platform.isAndroid ? 18 : 23, color: Colors.black),
        ),
      ),
    );
  }
}

class _PaymentLogosAndTotal extends StatelessWidget {
  final String totalText;
  const _PaymentLogosAndTotal({required this.totalText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: _PaymentLogos()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 7 : 30, vertical: 15),
            child: Text(
              "Gesamtpreis: ${totalText}€",
              style: TextStyle(height: 0, fontWeight: FontWeight.bold, fontSize: Platform.isAndroid ? 22 : 35, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentLogos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = Platform.isAndroid ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.07;

    final paths = [
      "lib/images/payment logos/girocard.png",
      "lib/images/payment logos/mastercard.png",
      "lib/images/payment logos/mastercard-maestro.png",
      "lib/images/payment logos/visa.png",
      "lib/images/payment logos/vpay.png",
      "lib/images/payment logos/contactless.png",
    ];

    if (Platform.isAndroid) {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                for (int i = 0; i < 3; i++)
                  Expanded(child: Padding(padding: const EdgeInsets.only(right: 3), child: Image.asset(paths[i], fit: BoxFit.fill, height: h))),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                for (int i = 3; i < 6; i++)
                  Expanded(child: Padding(padding: const EdgeInsets.only(right: 3), child: Image.asset(paths[i], fit: BoxFit.fill, height: h))),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          for (final p in paths)
            Expanded(child: Padding(padding: const EdgeInsets.only(right: 10), child: Image.asset(p, fit: BoxFit.fill, height: h))),
        ],
      ),
    );
  }
}

class _CartActionButtonsPay extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onPay;

  const _CartActionButtonsPay({required this.onBack, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: ElevatedButton(
            onPressed: onBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[300],
              side: const BorderSide(color: Colors.black, width: 1),
              padding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 5 : 15, vertical: Platform.isAndroid ? 5 : 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Zurück', style: TextStyle(fontSize: Platform.isAndroid ? 15 : 20, height: 0)),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: ElevatedButton(
            onPressed: onPay,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[300],
              side: const BorderSide(color: Colors.black, width: 1),
              padding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 5 : 15, vertical: Platform.isAndroid ? 5 : 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Bezahlen', style: TextStyle(fontSize: Platform.isAndroid ? 14 : 20, height: 0)),
          ),
        ),
      ],
    );
  }
}

class _CartActionButtonsSummary extends StatelessWidget {
  final bool cartNotEmpty;
  final VoidCallback onCancel;
  final VoidCallback onShowCart;

  const _CartActionButtonsSummary({
    required this.cartNotEmpty,
    required this.onCancel,
    required this.onShowCart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: ElevatedButton(
            onPressed: cartNotEmpty ? onCancel : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: cartNotEmpty ? Colors.red[300] : Colors.red[100],
              side: const BorderSide(color: Colors.black, width: 1),
              padding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 5 : 15, vertical: Platform.isAndroid ? 5 : 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Abbrechen', style: TextStyle(fontSize: Platform.isAndroid ? 15 : 20, height: 0)),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: ElevatedButton(
            onPressed: cartNotEmpty ? onShowCart : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: cartNotEmpty ? Colors.green[300] : Colors.green[100],
              side: const BorderSide(color: Colors.black, width: 1),
              padding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 5 : 15, vertical: Platform.isAndroid ? 5 : 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Bestellung ansehen', style: TextStyle(fontSize: Platform.isAndroid ? 14 : 20, height: 0)),
          ),
        ),
      ],
    );
  }
}
