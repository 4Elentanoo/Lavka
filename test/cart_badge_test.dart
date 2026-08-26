import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/main.dart';

void main() {
  const product = Product(
    id: 'p1',
    title: 'Кофе',
    description: 'описание',
    price: 100,
    category: 'Напитки',
  );

  Widget wrap(CartModel cart, Widget child) {
    return CartScope(
      cart: cart,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('пустая корзина: бейдж не показан', (tester) async {
    final cart = CartModel();

    await tester.pumpWidget(wrap(cart, const CartBadge()));

    expect(find.text('1'), findsNothing);
    expect(find.byIcon(Icons.shopping_bag_rounded), findsOneWidget);
  });

  testWidgets('после add бейдж показывает 1', (tester) async {
    final cart = CartModel();

    await tester.pumpWidget(wrap(cart, const CartBadge()));

    cart.add(product); // меняем модель
    await tester.pump(); // прокручиваем кадр

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('после трёх add бейдж показывает 3', (tester) async {
    final cart = CartModel();

    await tester.pumpWidget(wrap(cart, const CartBadge()));
    cart.add(product);
    cart.add(product);
    cart.add(product);
    await tester.pump();

    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('ровно 99 показывается как число, без плюса', (tester) async {
    final cart = CartModel();
    await tester.pumpWidget(wrap(cart, const CartBadge()));

    for (int i = 0; i < 99; i++) {
      cart.add(product);
    }
    await tester.pump();

    expect(find.text('99'), findsOneWidget);
    expect(find.text('99+'), findsNothing);
  });
}
