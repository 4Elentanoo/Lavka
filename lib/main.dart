import 'package:flutter/material.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
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
                onPressed: () {},
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

class QtySelector extends StatefulWidget {
  const QtySelector({
    super.key,
    required this.cart,
    required this.productId,
    required this.builder,
  });

  final CartModel cart;
  final String productId;
  final Widget Function(BuildContext context, int qty) builder;

  @override
  State<QtySelector> createState() => _QtySelectorState();
}

class _QtySelectorState extends State<QtySelector> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.cart.qtyOf(widget.productId);
    widget.cart.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    final next = widget.cart.qtyOf(widget.productId);
    if (next != _qty) {
      // ← вот вся суть: сравнили, и только тогда setState
      setState(() => _qty = next);
    }
  }

  @override
  void dispose() {
    widget.cart.removeListener(_onCartChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _qty);
}

class MainStorePage extends StatefulWidget {
  const MainStorePage({super.key});

  @override
  State<MainStorePage> createState() => _MainStorePageState();
}

class _MainStorePageState extends State<MainStorePage> {
  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context).cart;

    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
        ),
        onPressed: () {
          //? add demo data
          // CartScope.read(context).cart.add(
          //   Product(
          //     id: 'id',
          //     title: 'title',
          //     description: 'description',
          //     price: 1,
          //     category: 'category',
          //   ),
          // );
        },
        child: Icon(Icons.add, size: 30),
      ),
      appBar: AppBar(
        title: Text('Lavka'),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_bag_rounded),
                ),
                CartBadge(),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: cart,
                builder: (context, value) {
                  return GridView.count(
                    crossAxisCount: 1,
                    physics: BouncingScrollPhysics(),
                    children: List.generate(
                      CartScope.read(context).cart.items.length,
                      (index) {
                        final product = demoProducts[index];
                        return QtySelector(
                          cart: CartScope.of(context).cart,
                          productId: product.id,
                          builder: (context, qty) {
                            debugPrint('  qty builder для ${product.id}');
                            return ItemCartWidget();
                            //  qty == 0
                            //     ? ElevatedButton(
                            //         onPressed: () => cart.add(product),
                            //         child: const Text('В корзину'),
                            //       )
                            //     : Row(children: [/* − qty + */]);
                          },
                        );
                        // return ItemCartWidget();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
