import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// BLoC para gestionar el estado del carrito.
///
/// Maneja las operaciones CRUD del carrito con persistencia local.
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final UpdateCartQuantityUseCase _updateQuantityUseCase;
  final ClearCartUseCase _clearCartUseCase;

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

  Future<void> _onLoadRequested(
    CartLoadRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      final items = await _getCartUseCase();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Error al cargar el carrito: $e'));
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
      emit(CartError('Error al agregar al carrito: $e'));
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
      emit(CartError('Error al eliminar del carrito: $e'));
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
      emit(CartError('Error al actualizar cantidad: $e'));
    }
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    try {
      await _clearCartUseCase();
      emit(const CartLoaded(items: []));
    } catch (e) {
      emit(CartError('Error al limpiar el carrito: $e'));
    }
  }
}
