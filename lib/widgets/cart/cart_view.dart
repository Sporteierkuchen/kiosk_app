

import 'package:flutter/material.dart';
import '../../dto/ArticleDTO.dart';
import 'cart_item_tile.dart';

class CartView extends StatelessWidget {

  final List<ArticleDTO> cart;
  final VoidCallback onChanged;

  final void Function(int cartIndex) onConfirmRemoveArticle;
  final void Function(int cartIndex, int extraIndex) onConfirmRemoveExtra;

  const CartView({
    super.key,
    required this.cart,
    required this.onChanged,
    required this.onConfirmRemoveArticle,
    required this.onConfirmRemoveExtra,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cart.length,
      itemBuilder: (context, index) {
        final item = cart[index];

        return CartItemTile(
          item: item,
          onDelete: () => onConfirmRemoveArticle(index),
          onChanged: onChanged,
          onConfirmRemoveExtra: (extraIndex) =>
              onConfirmRemoveExtra(index, extraIndex),
        );
      },
    );
  }

}
