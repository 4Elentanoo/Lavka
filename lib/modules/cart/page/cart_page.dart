import 'package:flutter/material.dart';
import 'package:lavka_shop/main.dart';
import 'package:lavka_shop/modules/main_page/widgets/item_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context).cart;
    return Scaffold(
      appBar: AppBar(title: Text("Корзина"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListenableBuilder(
            listenable: cart,
            builder: (context, value) {
              if (cart.totalCount == 0) {
                return Center(child: Text("Корзина пуста"));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, i) {
                        return ItemCartWidget(
                          key: ValueKey(cart.items[i].product.id),
                          product: cart.items[i].product,
                          isCart: true,
                        );
                      },
                    ),
                  ),
                  if (cart.totalCount > 0) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("Оформить"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
