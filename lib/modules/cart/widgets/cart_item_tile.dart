import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/models/cart_item_model.dart';
import 'package:lavka_shop/core/providers/cart_provider.dart';

class CartItemTile extends ConsumerWidget {
  const CartItemTile({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('CartItemTile.build ${item.product.id}');
    final product = item.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.price} ₽ x ${item.qty} = ${item.sum} ₽',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ref.read(cartProvider).changeQty(product.id, -1),
            icon: const Icon(Icons.remove),
          ),
          Text('${item.qty}', style: const TextStyle(fontSize: 16)),
          IconButton(
            onPressed: () => ref.read(cartProvider).changeQty(product.id, 1),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => ref.read(cartProvider).remove(product.id),
            icon: const Icon(Icons.delete_outline),
            color: Colors.red.shade400,
          ),
        ],
      ),
    );
  }
}
