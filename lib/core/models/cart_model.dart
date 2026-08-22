import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/cart_item_model.dart';
import 'package:lavka_shop/core/models/product.dart';

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // неизменяемый наружу
  List<CartItem> get items => List.unmodifiable(_items.values);

  // общее число единиц
  int get totalCount => _items.values.fold(0, (sum, item) => sum + item.qty);

  // сумма
  int get totalPrice => _items.values.fold(0, (sum, item) => sum + item.sum);

  // сколько этого товара в корзине (0 если нет)
  int qtyOf(String productId) => _items[productId]?.qty ?? 0;

  // +1, или создать позицию
  void add(Product product) {
    final existing = _items[product.id];
    _items[product.id] = existing == null
        ? CartItem(product: product, qty: 1)
        : existing.copyWith(qty: existing.qty + 1);
    notifyListeners();
  }

  // удалить позицию целиком
  void remove(String productId) {
    _items.remove(productId); // O(1)
    notifyListeners();
  }

  // +1/-1, при 0 — удалить позицию
  void changeQty(String productId, int delta) {
    final item = _items[productId];
    if (item == null) return;

    final newQty = item.qty + delta;
    if (newQty <= 0) {
      _items.remove(productId);
    } else {
      _items[productId] = item.copyWith(qty: newQty);
    }
    notifyListeners();
  }
}
