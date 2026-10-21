// import 'package:flutter_riverpod/legacy.dart';
// import 'package:lavka_shop/core/models/cart_model.dart';

// final cartProvider = ChangeNotifierProvider((ref) => CartModel());

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/models/cart_item_model.dart';
import 'package:lavka_shop/core/models/cart_model.dart';

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