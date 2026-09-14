import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/providers/catalog_provider.dart';

class DetailItemPage extends ConsumerWidget {
  const DetailItemPage({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('=== DetailItemPage открыт: $productId');
    final details = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: Text(details.value?.title ?? 'Загрузка...'),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            details.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Ошибка: $err')),
              data: (product) => Column(
                children: [
                  Row(children: [Expanded(child: Text(product.description))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
