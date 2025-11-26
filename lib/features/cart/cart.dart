/// Barrel file para el feature Cart.
library;

// Domain
export 'domain/entities/cart_item.dart';
export 'domain/repositories/cart_repository.dart';
export 'domain/usecases/add_to_cart_usecase.dart';
export 'domain/usecases/clear_cart_usecase.dart';
export 'domain/usecases/get_cart_usecase.dart';
export 'domain/usecases/remove_from_cart_usecase.dart';
export 'domain/usecases/update_cart_quantity_usecase.dart';

// Data
export 'data/datasources/cart_local_datasource.dart';
export 'data/models/cart_item_model.dart';
export 'data/repositories/cart_repository_impl.dart';

// Presentation
export 'presentation/bloc/cart_bloc.dart';
export 'presentation/bloc/cart_event.dart';
export 'presentation/bloc/cart_state.dart';
export 'presentation/pages/cart_page.dart';
