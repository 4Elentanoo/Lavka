import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/core/models/qty_selector.dart';
import 'package:lavka_shop/main.dart';

class ItemCartWidget extends StatefulWidget {
  const ItemCartWidget({super.key, required this.product, this.isCart = false});

  final Product product;
  final bool isCart;

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

  void expand() {
    _controller.isForwardOrCompleted
        ? _controller.reverse()
        : _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ItemCartWidget.build ${widget.product.id}');
    return GestureDetector(
      onTap: expand,
      child: Container(
        color: Colors.grey,
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.product.title,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                if (widget.isCart) ...[
                  IconButton(
                    onPressed: () =>
                        CartScope.of(context).cart.remove(widget.product.id),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            SizeTransition(
              sizeFactor: _animation,
              child: Row(
                children: [Expanded(child: Text(widget.product.description))],
              ),
            ),
            QtySelector(
              cart: CartScope.of(context).cart,
              productId: widget.product.id,
              builder: (context, qty) {
                debugPrint('  qty builder для ${widget.product.id}');
                if (qty == 0) {
                  return ElevatedButton(
                    onPressed: () =>
                        CartScope.read(context).cart.add(widget.product),
                    child: const Text('В корзину'),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => CartScope.read(
                        context,
                      ).cart.changeQty(widget.product.id, -1),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$qty'),
                    IconButton(
                      onPressed: () => CartScope.read(
                        context,
                      ).cart.changeQty(widget.product.id, 1),
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
