import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/cart_model.dart';

class QtySelector extends StatefulWidget {
  const QtySelector({
    super.key,
    required this.cart,
    required this.productId,
    required this.builder,
  });

  final CartModel cart;
  final String productId;
  final Widget Function(BuildContext context, int qty) builder;

  @override
  State<QtySelector> createState() => _QtySelectorState();
}

class _QtySelectorState extends State<QtySelector> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.cart.qtyOf(widget.productId);
    widget.cart.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    final next = widget.cart.qtyOf(widget.productId);
    if (next != _qty) {
      // ← вот вся суть: сравнили, и только тогда setState
      setState(() => _qty = next);
    }
  }

  @override
  void dispose() {
    widget.cart.removeListener(_onCartChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _qty);
}
