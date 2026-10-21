import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/core/providers/cart_provider.dart';
import 'package:lavka_shop/main.dart';

void main() {
  const product = Product(
    id: 'p1',
    title: 'Кофе',
    description: 'описание',
    price: 100,
    category: 'Напитки',
  );

  /// Строит виджет и возвращает контейнер провайдеров,
  /// через который тест читает состояние и вызывает методы.
  Future<ProviderContainer> pump(WidgetTester tester, Widget child) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: Scaffold(body: child)),
      ),
    );
    return container;
  }

  testWidgets('пустая корзина: бейдж не показан', (tester) async {
    await pump(tester, const CartBadge());

    expect(find.text('1'), findsNothing);
    expect(find.byIcon(Icons.shopping_bag_rounded), findsOneWidget);
  });

  testWidgets('после add бейдж показывает 1', (tester) async {
    final container = await pump(tester, const CartBadge());

    container.read(cartProvider.notifier).add(product);
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('после трёх add бейдж показывает 3', (tester) async {
    final container = await pump(tester, const CartBadge());

    final cart = container.read(cartProvider.notifier);
    cart.add(product);
    cart.add(product);
    cart.add(product);
    await tester.pump();

    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('ровно 99 показывается как число, без плюса', (tester) async {
    final container = await pump(tester, const CartBadge());

    final cart = container.read(cartProvider.notifier);
    for (var i = 0; i < 99; i++) {
      cart.add(product);
    }
    await tester.pump();

    expect(find.text('99'), findsOneWidget);
    expect(find.text('99+'), findsNothing);
  });
}
