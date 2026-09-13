import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/core/providers/cart_provider.dart';

class ItemCartWidget extends ConsumerStatefulWidget {
  const ItemCartWidget({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<ItemCartWidget> createState() => _ItemCartWidgetState();
}

class _ItemCartWidgetState extends ConsumerState<ItemCartWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _expand() {
    _controller.isForwardOrCompleted
        ? _controller.reverse()
        : _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ItemCartWidget.build ${widget.product.id}');
    final product = widget.product;

    return GestureDetector(
      onTap: _expand,
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
            SizeTransition(
              sizeFactor: _animation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(product.description),
              ),
            ),
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
