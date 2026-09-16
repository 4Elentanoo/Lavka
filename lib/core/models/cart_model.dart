import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/models/cart_item_model.dart';
import 'package:lavka_shop/core/models/product.dart';

final cartTotalCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.values.fold(0, (s, i) => s + i.qty);
});

final cartTotalPriceProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.values.fold(0, (sum, item) => sum + item.sum);
});

final cartItemsProvider = Provider<List<CartItem>>((ref) {
  final items = ref.watch(cartProvider);
  return List.unmodifiable(items.values);
});

final cartQtyProvider = Provider.family.autoDispose<int, String>((
  ref,
  productId,
) {
  final items = ref.watch(cartProvider);
  return items[productId]?.qty ?? 0;
});

final cartProvider = NotifierProvider<CartNotifier, Map<String, CartItem>>(
  CartNotifier.new,
);

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



//   // неизменяемый наружу
//   List<CartItem> get items => List.unmodifiable(_items.values);

//   // общее число единиц
//   int get totalCount => _items.values.fold(0, (sum, item) => sum + item.qty);

//   // сумма
//   int get totalPrice => _items.values.fold(0, (sum, item) => sum + item.sum);

//   // сколько этого товара в корзине (0 если нет)
//   int qtyOf(String productId) => _items[productId]?.qty ?? 0;

