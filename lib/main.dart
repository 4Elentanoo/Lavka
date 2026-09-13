import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
import 'package:lavka_shop/modules/cart/page/cart_page.dart';
import 'package:lavka_shop/modules/demo_data/demo_products.dart';
import 'package:lavka_shop/modules/main_page/widgets/item_cart.dart';
import 'package:provider/provider.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: const MaterialApp(home: MainStorePage()),
    );
  }
}

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('CartBadge.build');

    final cart = context.watch<CartModel>();

    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_bag_rounded),
          ),
          if (cart.totalCount > 0)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    cart.totalCount > 99 ? '99+' : '${cart.totalCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MainStorePage extends StatelessWidget {
  const MainStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lavka'),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [const CartBadge(), const SizedBox(width: 10)],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: demoProducts.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) => ItemCartWidget(
                  key: ValueKey(demoProducts[i].id),
                  product: demoProducts[i],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
