import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lavka_shop/core/models/product.dart';
import 'package:lavka_shop/core/providers/cart_provider.dart';

void main() {
  const product = Product(
    id: 'p1',
    title: 'Кофе',
    description: 'описание',
    price: 100,
    category: 'Напитки',
  );

  const product2 = Product(
    id: 'p2',
    title: 'Кружка',
    description: 'описание',
    price: 250,
    category: 'Посуда',
  );

  /// Свежий контейнер на каждый тест — изоляция.
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('пустая корзина: totalCount и totalPrice равны нулю', () {
    final c = makeContainer();

    expect(c.read(cartTotalCountProvider), 0);
    expect(c.read(cartTotalPriceProvider), 0);
    expect(c.read(cartItemsProvider), isEmpty);
  });

  test('add кладёт товар с количеством 1', () {
    final c = makeContainer();

    c.read(cartProvider.notifier).add(product);

    expect(c.read(cartTotalCountProvider), 1);
    expect(c.read(cartQtyProvider('p1')), 1);
    expect(c.read(cartTotalPriceProvider), 100);
  });

  test('add дважды на один товар → qty равен 2', () {
    final c = makeContainer();
    final cart = c.read(cartProvider.notifier);

    cart.add(product);
    cart.add(product);

    expect(c.read(cartQtyProvider('p1')), 2);
    expect(c.read(cartTotalCountProvider), 2);
    expect(c.read(cartTotalPriceProvider), 200);
    expect(c.read(cartItemsProvider), hasLength(1));
  });

  test('changeQty(-1) при qty == 1 удаляет позицию', () {
    final c = makeContainer();
    final cart = c.read(cartProvider.notifier);

    cart.add(product);
    cart.changeQty('p1', -1);

    expect(c.read(cartItemsProvider), isEmpty);
    expect(c.read(cartQtyProvider('p1')), 0);
  });

  test('changeQty для несуществующего товара не падает', () {
    final c = makeContainer();

    c.read(cartProvider.notifier).changeQty('p1', -1);

    expect(c.read(cartItemsProvider), isEmpty);
    expect(c.read(cartQtyProvider('p1')), 0);
  });

  test('remove удаляет позицию целиком независимо от qty', () {
    final c = makeContainer();
    final cart = c.read(cartProvider.notifier);

    cart.add(product);
    cart.add(product);
    cart.add(product);
    cart.remove('p1');

    expect(c.read(cartQtyProvider('p1')), 0);
    expect(c.read(cartItemsProvider), isEmpty);
    expect(c.read(cartTotalCountProvider), 0);
  });

  test('totalPrice считает сумму по разным товарам', () {
    final c = makeContainer();
    final cart = c.read(cartProvider.notifier);

    cart.add(product);
    cart.add(product2);

    expect(c.read(cartTotalCountProvider), 2);
    expect(c.read(cartItemsProvider), hasLength(2));
    expect(c.read(cartTotalPriceProvider), 350);
  });

  test('changeQty(+1) увеличивает существующую позицию', () {
    final c = makeContainer();
    final cart = c.read(cartProvider.notifier);

    cart.add(product);
    cart.changeQty('p1', 1);

    expect(c.read(cartQtyProvider('p1')), 2);
  });

  test('state не мутируется: старая мапа остаётся прежней', () {
    final c = makeContainer();
    final cart = c.read(cartProvider.notifier);

    cart.add(product);
    final before = c.read(cartProvider); // ссылка на текущую мапу

    cart.add(product2);
    final after = c.read(cartProvider);

    expect(identical(before, after), isFalse, reason: 'должна быть новая мапа');
    expect(before, hasLength(1), reason: 'старая мапа не должна измениться');
    expect(after, hasLength(2));
  });
}
