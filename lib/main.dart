import 'package:flutter/material.dart';

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
      // ← выше MaterialApp
      cart: _cart,
      child: const MaterialApp(home: MainStorePage()),
    );
  }
}

class CartScope extends InheritedWidget {
  const CartScope({super.key, required super.child});

  final CartModel cart;

  static CartScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartScope>();
  }

  @override
  bool updateShouldNotify(CartScope oldWidget) {
    return true;
  }
}

class MainStorePage extends StatefulWidget {
  const MainStorePage({super.key});

  @override
  State<MainStorePage> createState() => _MainStorePageState();
}

class _MainStorePageState extends State<MainStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
