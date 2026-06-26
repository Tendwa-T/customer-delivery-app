import 'package:customer_delivery_app/core/error/failures.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/domain/repository/delivery_request_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'delivery_event.dart';
part 'delivery_state.dart';

const _searchDebounce = Duration(milliseconds: 350);

EventTransformer<SearchDeliveries> _debounceRestartable() {
  return (events, mapper) => events.debounce(_searchDebounce).switchMap(mapper);
}

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  DeliveryBloc({required this._repository}) : super(const DeliveryInitial()) {
    on<LoadDeliveries>(_onLoad);
    on<AddDelivery>(_onAdd);
    on<UpdateDelivery>(_onUpdate);
    on<DeleteDelivery>(_onDelete);
    on<SearchDeliveries>(_onSearch, transformer: _debounceRestartable());
    on<FilterDeliveriesByStatus>(_onFilter);
  }

  final DeliveryRequestRepository _repository;

  Future<void> _onLoad(
    LoadDeliveries event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(const DeliveryLoading());
    final result = await _repository.getAll();

    result.fold(
      (failure) => emit(DeliveryError(failure: failure)),
      (req) => req.isEmpty
          ? emit(const DeliveryEmpty())
          : emit(DeliveryLoaded(requests: req)),
    );
  }

  Future<void> _onAdd(AddDelivery event, Emitter<DeliveryState> emit) async {
    emit(const DeliveryLoading());

    final result = await _repository.insert(event.req);

    result.fold((failure) => emit(DeliveryError(failure: failure)), (r) {
      emit(const DeliveryOperationSuccess('Delivery Request created'));
      add(const LoadDeliveries());
    });
  }

  Future<void> _onUpdate(
    UpdateDelivery event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(const DeliveryLoading());
    final result = await _repository.update(event.req);

    result.fold((failure) => emit(DeliveryError(failure: failure)), (_) {
      emit(const DeliveryOperationSuccess('Delivery Request Updated'));
      add(const LoadDeliveries());
    });
  }

  Future<void> _onDelete(
    DeleteDelivery event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(const DeliveryLoading());

    final result = await _repository.delete(event.id);

    result.fold((failure) => emit(DeliveryError(failure: failure)), (_) {
      emit(const DeliveryOperationSuccess('Delivery request Deleted'));
      add(const LoadDeliveries());
    });
  }

  Future<void> _onSearch(
    SearchDeliveries event,
    Emitter<DeliveryState> emit,
  ) async {
    final result = await _repository.search(event.query);

    result.fold(
      (failure) => emit(DeliveryError(failure: failure)),
      (req) => req.isEmpty
          ? emit(const DeliveryEmpty())
          : emit(DeliveryLoaded(requests: req, query: event.query)),
    );
  }

  Future<void> _onFilter(
    FilterDeliveriesByStatus event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(const DeliveryLoading());

    final result = await _repository.filterByStatus(event.status);

    result.fold(
      (failure) => emit(DeliveryError(failure: failure)),
      (req) => req.isEmpty
          ? emit(const DeliveryEmpty())
          : emit(DeliveryLoaded(requests: req, activeFilter: event.status)),
    );
  }
}
