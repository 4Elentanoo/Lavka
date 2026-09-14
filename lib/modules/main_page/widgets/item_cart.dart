import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/core/providers/cart_provider.dart';
import 'package:lavka_shop/modules/detail_item_page/detail_item_page.dart';

class ItemCartWidget extends StatelessWidget {
  const ItemCartWidget({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailItemPage(productId: product.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Text(
                  '${product.price} ₽',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            QtyControls(product: product),
          ],
        ),
      ),
    );
  }
}

class QtyControls extends ConsumerWidget {
  const QtyControls({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(cartProvider.select((c) => c.qtyOf(product.id)));

    debugPrint('  qty builder для ${product.id}');
    if (qty == 0) {
      return ElevatedButton(
        onPressed: () => ref.read(cartProvider).add(product),
        child: const Text('В корзину'),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => ref.read(cartProvider).changeQty(product.id, -1),
            icon: const Icon(Icons.remove),
          ),
          Text('$qty', style: const TextStyle(fontSize: 18)),
          IconButton(
            onPressed: () => ref.read(cartProvider).changeQty(product.id, 1),
            icon: const Icon(Icons.add),
          ),
        ],
      );
    }
  }
}
