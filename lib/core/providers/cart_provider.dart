import 'package:flutter_riverpod/legacy.dart';
import 'package:lavka_shop/core/models/cart_model.dart';

final cartProvider = ChangeNotifierProvider((ref) => CartModel());
