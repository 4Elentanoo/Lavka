import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/cart_item_model.dart';
import 'package:lavka_shop/core/models/product.dart';

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // неизменяемый наружу
  List<CartItem> get items => List.unmodifiable(_items.values);

  // общее число единиц
  int get totalCount => items.length;

  // сумма
  int get totalPrice {
    int price = 0;
    for (var item in items) {
      price += item.sum;
    }
    return price;
  }

  // сколько этого товара в корзине (0 если нет)
  int qtyOf(String productId) => _items[productId]?.qty ?? 0;

  // +1, или создать позицию
  void add(Product product) {
    _items.addAll({product.id: CartItem(product: product, qty: 0)});
    notifyListeners();
  }

  // удалить позицию целиком
  void remove(String productId) {
    _items.removeWhere((key, value) => key == productId);
    notifyListeners();
  }

  // +1/-1, при 0 — удалить позицию
  void changeQty(String productId, int delta) {
    // int qty = _items[productId]?.qty ?? 0;
    if (delta < 0) return;

    notifyListeners();
  }
}
