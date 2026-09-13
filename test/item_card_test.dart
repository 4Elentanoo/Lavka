import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/main.dart';
import 'package:lavka_shop/modules/main_page/widgets/item_cart.dart';
import 'package:provider/provider.dart';

class BuildCounter extends StatelessWidget {
  const BuildCounter({super.key, required this.onBuild, required this.child});

  final VoidCallback onBuild;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return child;
  }
}

void main() {
  const p1 = Product(
    id: 'p1',
    title: 'Кофе',
    description: 'о кофе',
    price: 100,
    category: 'Напитки',
  );
  const p2 = Product(
    id: 'p2',
    title: 'Кружка',
    description: 'о кружке',
    price: 250,
    category: 'Посуда',
  );

  Widget wrap(CartModel cart, Widget child) {
    return ChangeNotifierProvider.value(
      value: cart, // ← твой объект
      child: MaterialApp(home: Scaffold(body: child)), // ← твой виджет
    );
  }

  testWidgets('тап по "В корзину" добавляет товар', (tester) async {
    final cart = CartModel();

    await tester.pumpWidget(wrap(cart, const ItemCartWidget(product: p1)));

    expect(find.text('В корзину'), findsOneWidget);

    await tester.tap(find.text('В корзину'));
    await tester.pump();

    expect(cart.qtyOf('p1'), 1);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('В корзину'), findsNothing);
  });

  testWidgets('плюс увеличивает количество', (tester) async {
    final cart = CartModel();
    cart.add(p1);

    await tester.pumpWidget(wrap(cart, const ItemCartWidget(product: p1)));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(cart.qtyOf('p1'), 2);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('тап по одной карточке не перестраивает соседнюю', (
    tester,
  ) async {
    final cart = CartModel();
    var buildsP1 = 0;
    var buildsP2 = 0;

    // локальная копия того, что делает ItemCartWidget: селектор + счётчик
    Widget probe(Product p, VoidCallback onBuild) => Selector<CartModel, int>(
      //? что выбираем
      selector: (context, cart) => cart.qtyOf(p.id),
      builder: (context, qty, child) {
        debugPrint('  qty builder для ${p.id}');
        final cart = context.read<CartModel>();
        onBuild();
        return qty == 0
            ? ElevatedButton(
                onPressed: () => cart.add(p),
                child: Text('В корзину ${p.id}'),
              )
            : Text('${p.id}: $qty');
      },
    );

    await tester.pumpWidget(
      wrap(
        cart,
        Column(
          children: [probe(p1, () => buildsP1++), probe(p2, () => buildsP2++)],
        ),
      ),
    );

    expect(buildsP1, 1);
    expect(buildsP2, 1);

    await tester.tap(find.text('В корзину p1'));
    await tester.pump();

    expect(cart.qtyOf('p1'), 1);
    expect(
      buildsP1,
      2,
      reason: 'p1 должен перестроиться — его количество изменилось',
    );
    expect(buildsP2, 1, reason: 'p2 не должен: его количество не менялось');
  });
}
