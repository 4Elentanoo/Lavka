import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/modules/demo_data/demo_products.dart';

final catalogProvider = FutureProvider<List<Product>>((ref) async {
  debugPrint('>>> catalogProvider: загрузка началась');

  //? имитация сети
  await Future.delayed(const Duration(seconds: 2));
  debugPrint('>>> catalogProvider: данные пришли');
  return demoProducts;
});

final productDetailsProvider = FutureProvider.autoDispose
    .family<Product, String>((ref, productId) async {
      debugPrint('>>> детали $productId: ЗАПРОС ПОШЁЛ');
      ref.onDispose(() => debugPrint('>>> детали $productId: УНИЧТОЖЕН'));

      final link = ref.keepAlive(); // ← сразу
      final timer = Timer(const Duration(seconds: 5), link.close);
      ref.onDispose(timer.cancel);

      await Future.delayed(const Duration(seconds: 1)); // ← потом загрузка
      debugPrint('>>> детали $productId: данные пришли');
      return demoProducts.firstWhere((p) => p.id == productId);
    });
