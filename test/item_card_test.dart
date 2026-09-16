import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/modules/main_page/widgets/item_cart.dart';

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

  testWidgets('тап по "В корзину" добавляет товар', (tester) async {
    final container = await pump(tester, const ItemCartWidget(product: p1));

    expect(find.text('В корзину'), findsOneWidget);

    await tester.tap(find.text('В корзину'));
    await tester.pump();

    expect(container.read(cartProvider)['p1']?.qty, 1);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('В корзину'), findsNothing);
  });

  testWidgets('плюс увеличивает количество', (tester) async {
    final container = await pump(tester, const ItemCartWidget(product: p1));
    container.read(cartProvider.notifier).add(p1);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(container.read(cartProvider)['p1']?.qty, 2);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('тап по одной карточке не перестраивает соседнюю', (
    tester,
  ) async {
    var buildsP1 = 0;
    var buildsP2 = 0;

    Widget probe(Product p, VoidCallback onBuild) => Consumer(
      builder: (context, ref, child) {
        final qty = ref.watch(cartQtyProvider(p.id));
        onBuild();
        return qty == 0
            ? ElevatedButton(
                onPressed: () => ref.read(cartProvider.notifier).add(p),
                child: Text('В корзину ${p.id}'),
              )
            : Text('${p.id}: $qty');
      },
    );

    final container = await pump(
      tester,
      Column(
        children: [probe(p1, () => buildsP1++), probe(p2, () => buildsP2++)],
      ),
    );

    expect(buildsP1, 1);
    expect(buildsP2, 1);

    await tester.tap(find.text('В корзину p1'));
    await tester.pump();

    expect(container.read(cartProvider)['p1']?.qty, 1);
    expect(
      buildsP1,
      2,
      reason: 'p1 должен перестроиться — его количество изменилось',
    );
    expect(buildsP2, 1, reason: 'p2 не должен: его количество не менялось');
  });
}
