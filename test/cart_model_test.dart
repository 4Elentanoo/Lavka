import 'package:flutter_test/flutter_test.dart';
import 'package:lavka_shop/core/models/cart_model.dart';
import 'package:lavka_shop/core/models/product.dart';

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

  test('пустая корзина: totalCount и totalPrice равны нулю', () {
    final cart = CartModel();

    expect(cart.totalCount, 0);
    expect(cart.totalPrice, 0);
    expect(cart.items, isEmpty);
  });

  test('add кладёт товар с количеством 1', () {
    final cart = CartModel();

    cart.add(product);

    expect(cart.totalCount, 1);
    expect(cart.qtyOf('p1'), 1);
    expect(cart.totalPrice, 100);
  });

  test('add дважды на один товар → qty равен 2', () {
    final cart = CartModel();

    cart.add(product);
    cart.add(product);

    expect(cart.qtyOf('p1'), 2);
    expect(cart.totalCount, 2);
    expect(cart.totalPrice, 200);
    expect(cart.items, hasLength(1));
  });

  test('changeQty(-1) при qty == 1 удаляет позицию', () {
    final cart = CartModel();

    cart.add(product);
    cart.changeQty(product.id, -1);

    expect(cart.items.isEmpty, true);
    expect(cart.qtyOf('p1'), 0);
  });

  test('changeQty для несуществующего товара не падает', () {
    final cart = CartModel();

    cart.changeQty(product.id, -1);

    expect(cart.items, isEmpty);
    expect(cart.qtyOf('p1'), 0);
  });

  test('remove удаляет позицию целиком независимо от qty', () {
    final cart = CartModel();

    cart.add(product);
    cart.remove(product.id);

    expect(cart.qtyOf(product.id), 0);
  });

  test('totalPrice считает сумму по разным товарам', () {
    final cart = CartModel();

    cart.add(product);
    cart.add(product2);

    expect(cart.totalCount, 2);
    expect(cart.items, hasLength(2));
    expect(cart.totalPrice, 350);
  });

  test('changeQty(+1) увеличивает существующую позицию', () {
    final cart = CartModel();

    cart.add(product);
    cart.changeQty(product.id, 1);

    expect(cart.qtyOf(product.id), 2);
  });
}
