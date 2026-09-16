import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
import 'package:lavka_shop/modules/cart/widgets/cart_item_tile.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartItemsProvider);
    final cartTotalPrice = ref.watch(cartTotalPriceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: cartItems.isEmpty
                ? const Center(child: Text('Корзина пуста'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, i) {
                            final item = cartItems[i];
                            return CartItemTile(
                              key: ValueKey(item.product.id),
                              item: item,
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('Итого: $cartTotalPrice ₽')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: null,
                              child: const Text("Оформить"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
