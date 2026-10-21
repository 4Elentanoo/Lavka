import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/models/cart_item_model.dart';
import 'package:lavka_shop/core/models/product.dart';

// стало: присваиваем новый state, Riverpod сам сравнивает
class CartNotifier extends Notifier<Map<String, CartItem>> {
  @override
  Map<String, CartItem> build() => {};

  //? Свойство в Notifier
  // int get totalCount => state.values.fold(0, (s, i) => s + i.qty);

  void add(Product p) {
    final existing = state[p.id];
    state = {
      ...state,
      p.id: existing == null
          ? CartItem(product: p, qty: 1)
          : existing.copyWith(qty: existing.qty + 1),
    };
  }

  void remove(String productId) {
    if (!state.containsKey(productId)) return;
    state = {...state}..remove(productId);
  }

  void changeQty(String productId, int delta) {
    final item = state[productId];
    if (item == null) return;

    final newQty = item.qty + delta;
    if (newQty <= 0) {
      remove(productId);
    } else {
      state = {...state, productId: item.copyWith(qty: newQty)};
    }
  }
}
