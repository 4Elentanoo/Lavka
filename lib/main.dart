import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/providers/cart_provider.dart';
import 'package:lavka_shop/core/providers/catalog_provider.dart';
import 'package:lavka_shop/modules/cart/page/cart_page.dart';
import 'package:lavka_shop/modules/main_page/widgets/item_cart.dart';

void main() => runApp(const ProviderScope(child: App()));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainStorePage());
  }
}

class CartBadge extends ConsumerWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('CartBadge.build');
    final cart = ref.watch(cartProvider);

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
          if (cart.totalCount > 0) ...[
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
        ],
      ),
    );
  }
}

class MainStorePage extends ConsumerWidget {
  const MainStorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);

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
              child: catalog.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Ошибка: $err')),
                data: (products) => ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, i) => ItemCartWidget(
                    key: ValueKey(products[i].id),
                    product: products[i],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
