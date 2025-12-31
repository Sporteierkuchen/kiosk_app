import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:tetete/utils/money_utils.dart';
import '../../dto/ArticleExtraDTO.dart';

class CartExtraCounterRow extends StatelessWidget {
  final ArticleExtraDTO extra;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartExtraCounterRow({
    super.key,
    required this.extra,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Platform.isAndroid ? 10 : 25),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // + Button
          GestureDetector(
            onTap: onIncrease,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.green,
              ),
              child: Icon(
                Icons.add,
                size: Platform.isAndroid ? 25 : 40,
                color: Colors.white,
              ),
            ),
          ),

          // Amount
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(
              horizontal: Platform.isAndroid ? 15 : 25,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
              color: Colors.white,
            ),
            child: Text(
              "${extra.amount}",
              maxLines: 1,
              style: TextStyle(
                height: 0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: Platform.isAndroid ? 25 : 30,
              ),
            ),
          ),

          // - Button
          GestureDetector(
            onTap: onDecrease,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: (extra.amount == 0) ? Colors.red[100] : Colors.red[300],
              ),
              child: Icon(
                Icons.remove,
                size: Platform.isAndroid ? 25 : 40,
                color: Colors.white,
              ),
            ),
          ),

          // ✅ wie im alten Code: rechts Name + Preis
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: Platform.isAndroid ? 15 : 20),
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    extra.name ?? "",
                    style: TextStyle(
                      height: 0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: Platform.isAndroid ? 18 : 25,
                    ),
                  ),
                  Text(
                    "${MoneyUtils.formatCurrency(MoneyUtils.roundDouble(extra.price ?? 0, 2))}€",
                    style: const TextStyle(
                      height: 0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
