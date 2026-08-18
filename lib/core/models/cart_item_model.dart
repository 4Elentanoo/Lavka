import 'package:lavka_shop/core/models/product.dart';

class CartItem {
  const CartItem({required this.product, required this.qty});

  final Product product;
  final int qty;

  int get sum => product.price * qty;

  CartItem copyWith({Product? product, int? qty}) =>
      CartItem(product: product ?? this.product, qty: qty ?? this.qty);
}
