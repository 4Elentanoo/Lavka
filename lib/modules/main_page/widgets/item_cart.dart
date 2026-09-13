import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/core/models/qty_selector.dart';
import 'package:lavka_shop/main.dart';

class ItemCartWidget extends StatefulWidget {
  const ItemCartWidget({super.key, required this.product});

  final Product product;

  @override
  State<ItemCartWidget> createState() => _ItemCartWidgetState();
}

class _ItemCartWidgetState extends State<ItemCartWidget>
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
            QtySelector(
              cart: CartScope.of(context).cart,
              productId: product.id,
              builder: (context, qty) {
                debugPrint('  qty builder для ${product.id}');
                final cart = CartScope.read(context).cart;

                if (qty == 0) {
                  return ElevatedButton(
                    onPressed: () => cart.add(product),
                    child: const Text('В корзину'),
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => cart.changeQty(product.id, -1),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$qty', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      onPressed: () => cart.changeQty(product.id, 1),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
