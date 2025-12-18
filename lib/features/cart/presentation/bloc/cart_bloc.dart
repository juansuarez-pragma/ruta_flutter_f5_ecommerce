import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_state.dart';

/// BLoC that manages cart state.
///
/// Handles CRUD cart operations with local persistence.
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
    required UpdateCartQuantityUseCase updateQuantityUseCase,
    required ClearCartUseCase clearCartUseCase,
  }) : _getCartUseCase = getCartUseCase,
       _addToCartUseCase = addToCartUseCase,
       _removeFromCartUseCase = removeFromCartUseCase,
       _updateQuantityUseCase = updateQuantityUseCase,
       _clearCartUseCase = clearCartUseCase,
       super(const CartInitial()) {
    on<CartLoadRequested>(_onLoadRequested);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onQuantityUpdated);
    on<CartCleared>(_onCleared);
  }
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final UpdateCartQuantityUseCase _updateQuantityUseCase;
  final ClearCartUseCase _clearCartUseCase;

  Future<void> _onLoadRequested(
    CartLoadRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      final items = await _getCartUseCase();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Error loading the cart: $e'));
    }
  }

  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    try {
      final item = CartItem(product: event.product, quantity: event.quantity);
      await _addToCartUseCase(item);
      final items = await _getCartUseCase();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Error adding to cart: $e'));
    }
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _removeFromCartUseCase(event.productId);
      final items = await _getCartUseCase();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Error removing from cart: $e'));
    }
  }

  Future<void> _onQuantityUpdated(
    CartItemQuantityUpdated event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _updateQuantityUseCase(event.productId, event.quantity);
      final items = await _getCartUseCase();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Error updating quantity: $e'));
    }
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    try {
      await _clearCartUseCase();
      emit(const CartLoaded(items: []));
    } catch (e) {
      emit(CartError('Error clearing the cart: $e'));
    }
  }
}
