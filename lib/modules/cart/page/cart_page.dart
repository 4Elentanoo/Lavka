import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
import 'package:lavka_shop/modules/cart/widgets/cart_item_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final items = cart.items;
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
            child: items.isEmpty
                ? const Center(child: Text('Корзина пуста'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            final item = items[i];
                            return CartItemTile(
                              key: ValueKey(item.product.id),
                              item: item,
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('Итого: ${cart.totalPrice} ₽')),
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
