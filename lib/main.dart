import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
import 'package:lavka_shop/modules/cart/page/cart_page.dart';
import 'package:lavka_shop/modules/demo_data/demo_products.dart';
import 'package:lavka_shop/modules/main_page/widgets/item_cart.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final CartModel _cart = CartModel();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      cart: _cart,
      child: const MaterialApp(home: MainStorePage()),
    );
  }
}

class CartScope extends InheritedWidget {
  const CartScope({super.key, required this.cart, required super.child});

  final CartModel cart;

  static CartScope of(BuildContext context) {
    final res = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(res != null, 'CartScope не найден выше по дереву');
    return res!;
  }

  static CartScope read(BuildContext context) {
    final res = context.getInheritedWidgetOfExactType<CartScope>();
    assert(res != null, 'CartScope не найден выше по дереву');
    return res!;
  }

  @override
  bool updateShouldNotify(CartScope oldWidget) => oldWidget.cart != cart;
}

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('CartBadge.build');
    final cart = CartScope.of(context).cart;
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        debugPrint('  CartBadge builder');
        final count = cart.totalCount;
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
              if (count > 0)
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
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
