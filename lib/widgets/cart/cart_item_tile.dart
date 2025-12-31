import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:tetete/utils/money_utils.dart';

import '../../dto/ArticleDTO.dart';
import '../../utils/cart_utils.dart';
import 'cart_extra_counter_row.dart';

class CartItemTile extends StatelessWidget {
  final ArticleDTO item;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  // ✅ NEU: Extra-Entfernen wird außen bestätigt/ausgeführt
  final void Function(int extraIndex) onConfirmRemoveExtra;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onChanged,
    required this.onConfirmRemoveExtra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: Platform.isAndroid ? 1 : 3,
          color: Colors.black26,
        ),
        color: Colors.transparent,
      ),
      margin: EdgeInsets.symmetric(vertical: Platform.isAndroid ? 5 : 15),
      padding: EdgeInsets.symmetric(
        vertical: Platform.isAndroid ? 10 : 20,
        horizontal: Platform.isAndroid ? 10 : 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              item.icon!,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: Platform.isAndroid ? 10 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? "",
                          softWrap: true,
                          style: TextStyle(
                            height: 0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: Platform.isAndroid ? 26 : 40,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey,
                          size: Platform.isAndroid ? 30 : 40,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Platform.isAndroid ? 0 : 10),
                    child: Text(
                      "${MoneyUtils.formatCurrency(MoneyUtils.roundDouble(item.priceGross ?? 0, 2))}€",
                      softWrap: true,
                      style: TextStyle(
                        height: 0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: Platform.isAndroid ? 20 : 25,
                      ),
                    ),
                  ),
                  SizedBox(height: Platform.isAndroid ? 15 : 30),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: item.extraslist?.length ?? 0,
                    itemBuilder: (context, index2) {
                      final extra = item.extraslist![index2];

                      return CartExtraCounterRow(
                        extra: extra,
                        onIncrease: () {
                          extra.increase();
                          onChanged();
                        },
                        onDecrease: () {
                          if (extra.amount > 1) {
                            extra.decrease();
                            onChanged();
                            return;
                          }
                          // ✅ Dialog/Remove nicht hier -> nach außen
                          onConfirmRemoveExtra(index2);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Gesamtpreis Artikel: ${MoneyUtils.formatCurrency(MoneyUtils.roundDouble(CartUtils.articlePrice(item), 2))}€",
                          softWrap: true,
                          maxLines: 1,
                          style: TextStyle(
                            height: 0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: Platform.isAndroid ? 15 : 25,
                          ),
                        ),
                      ),
                    ],
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
