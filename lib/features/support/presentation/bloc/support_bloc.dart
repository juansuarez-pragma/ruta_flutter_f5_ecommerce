import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/support/domain/usecases/get_faqs_usecase.dart';
import 'package:ecommerce/features/support/domain/usecases/send_contact_message_usecase.dart';
import 'package:ecommerce/features/support/domain/repositories/support_repository.dart';
import 'package:ecommerce/features/support/presentation/bloc/support_event.dart';
import 'package:ecommerce/features/support/presentation/bloc/support_state.dart';

/// BLoC that manages support state.
class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc({
    required GetFAQsUseCase getFAQsUseCase,
    required SendContactMessageUseCase sendContactMessageUseCase,
    required SupportRepository repository,
  })  : _getFAQsUseCase = getFAQsUseCase,
        _sendContactMessageUseCase = sendContactMessageUseCase,
        _repository = repository,
        super(const SupportInitial()) {
    on<SupportFAQsLoadRequested>(_onFAQsLoadRequested);
    on<SupportContactMessageSent>(_onContactMessageSent);
    on<SupportContactInfoLoadRequested>(_onContactInfoLoadRequested);
  }

  final GetFAQsUseCase _getFAQsUseCase;
  final SendContactMessageUseCase _sendContactMessageUseCase;
  final SupportRepository _repository;

  Future<void> _onFAQsLoadRequested(
    SupportFAQsLoadRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportLoading());

    final result = await _getFAQsUseCase(category: event.category);

    result.fold(
      (failure) => emit(SupportError(message: failure.message)),
      (faqs) => emit(SupportFAQsLoaded(
        faqs: faqs,
        selectedCategory: event.category,
      )),
    );
  }

  Future<void> _onContactMessageSent(
    SupportContactMessageSent event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportLoading());

    final result = await _sendContactMessageUseCase(
      name: event.name,
      email: event.email,
      subject: event.subject,
      message: event.message,
    );

    result.fold(
      (failure) => emit(SupportError(message: failure.message)),
      (_) => emit(const SupportMessageSent()),
    );
  }

  Future<void> _onContactInfoLoadRequested(
    SupportContactInfoLoadRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportLoading());

    final result = await _repository.getContactInfo();

    result.fold(
      (failure) => emit(SupportError(message: failure.message)),
      (contactInfo) => emit(SupportContactInfoLoaded(contactInfo: contactInfo)),
    );
  }
}
