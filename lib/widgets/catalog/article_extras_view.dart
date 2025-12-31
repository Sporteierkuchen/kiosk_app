
import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import '../../dto/ArticleDTO.dart';
import '../../dto/ArticleExtraDTO.dart';
import '../../utils/cart_utils.dart';
import '../../utils/money_utils.dart';

class ExtrasView extends StatelessWidget {
  final ArticleDTO selected;
  final VoidCallback onBack;
  final VoidCallback onAddToCart;
  final VoidCallback onChanged; // setState trigger im Parent

  const ExtrasView({
    super.key,
    required this.selected,
    required this.onBack,
    required this.onAddToCart,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    final priceText = MoneyUtils.formatCurrency(
      MoneyUtils.roundDouble(CartUtils.selectedPrice(selected), 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(
          padding: EdgeInsets.only(
            bottom: Platform.isAndroid ? 10 : 50,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Platform.isAndroid ? 10 : 30,
                      ),
                      child: Image.asset(
                        selected.icon!,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected.title ?? "",
                      softWrap: true,
                      style: TextStyle(
                        height: 0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: Platform.isAndroid ? 26 : 40,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Platform.isAndroid ? 0 : 10),
                      child: Text(
                        "Preis: ${MoneyUtils.formatCurrency(MoneyUtils.roundDouble(selected.priceGross ?? 0, 2))}€",
                        maxLines: 1,
                        style: TextStyle(
                          height: 0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: Platform.isAndroid ? 20 : 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),

        // Extras
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: selected.extraslist?.length ?? 0,
            itemBuilder: (context, index) {

              final extra = selected.extraslist![index];

              return _ExtraRow(
                extra: extra,
                onChanged: onChanged,
              );

            },
          ),
        ),

        // Bottom actions
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Platform.isAndroid ? 5 : 20,
            vertical: Platform.isAndroid ? 15 : 40,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              ElevatedButton(
                onPressed: onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  side: const BorderSide(color: Colors.black, width: 1),
                  padding: EdgeInsets.symmetric(
                    horizontal: Platform.isAndroid ? 0 : 15,
                    vertical: Platform.isAndroid ? 0 : 25,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: Platform.isAndroid ? 25 : 50,
                  color: Colors.black,
                ),
              ),

              Column(
                children: [
                  Text(
                    "Preis:",
                    style: TextStyle(
                      height: 0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: Platform.isAndroid ? 20 : 25,
                    ),
                  ),
                  Text(
                    "$priceText€",
                    style: TextStyle(
                      height: 0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: Platform.isAndroid ? 20 : 30,
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  side: const BorderSide(color: Colors.black, width: 1),
                  padding: EdgeInsets.symmetric(
                    horizontal: Platform.isAndroid ? 5 : 15,
                    vertical: Platform.isAndroid ? 5 : 25,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Hinzufügen',
                  style: TextStyle(fontSize: Platform.isAndroid ? 15 : 30),
                ),
              )

            ],
          ),
        ),

      ],
    );
  }
}

class _ExtraRow extends StatelessWidget {
  final ArticleExtraDTO extra;
  final VoidCallback onChanged;

  const _ExtraRow({
    required this.extra,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      margin: EdgeInsets.symmetric(
        horizontal: Platform.isAndroid ? 10 : 20,
        vertical: Platform.isAndroid ? 10 : 25,
      ),
      child: Row(
        children: [
          Expanded(
            flex: Platform.isAndroid ? 2 : 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    extra.increase();
                    onChanged();
                  },
                  child: _smallBtn(Icons.add, Colors.green),
                ),
                const SizedBox(width: 10),
                _countBox(extra.amount),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (extra.amount > 0) {
                      extra.decrease();
                      onChanged();
                    }
                  },
                  child: _smallBtn(
                    Icons.remove,
                    extra.amount == 0 ? Colors.red.shade100 : Colors.red.shade300,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: Platform.isAndroid ? 15 : 20),
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
                  (extra.description ?? "").trim().isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      extra.description ?? "",
                      style: const TextStyle(
                        height: 0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 15,
                      ),
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

  Widget _smallBtn(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Icon(
        icon,
        size: Platform.isAndroid ? 25 : 50,
        color: Colors.white,
      ),
    );
  }

  Widget _countBox(int value) {
    return Container(
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
        "$value",
        style: TextStyle(
          height: 0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: Platform.isAndroid ? 25 : 35,
        ),
      ),
    );
  }

}
