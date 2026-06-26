import 'package:customer_delivery_app/core/error/failures.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/domain/repository/delivery_request_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:fpdart/fpdart.dart';

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
    on<UpdateDeliveryStatus>(_onUpdateStatus);
  }

  final DeliveryRequestRepository _repository;
  DeliveryStatus? _activeFilter;
  String _searchQuery = '';

  Future<void> _loadDeliveries(Emitter<DeliveryState> emit) async {
    final Either<AppFailure, List<DeliveryRequest>> result;
    if (_activeFilter != null) {
      result = await _repository.filterByStatus(_activeFilter);
    } else if (_searchQuery.isNotEmpty) {
      result = await _repository.search(_searchQuery);
    } else {
      result = await _repository.getAll();
    }

    result.fold(
      (failure) => emit(DeliveryError(failure: failure)),
      (req) => req.isEmpty
          ? emit(const DeliveryEmpty())
          : emit(DeliveryLoaded(
              requests: req,
              activeFilter: _activeFilter,
              query: _searchQuery,
            )),
    );
  }

  Future<void> _onLoad(
    LoadDeliveries event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(const DeliveryLoading());
    await _loadDeliveries(emit);
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
    _searchQuery = event.query;
    _activeFilter = null;
    final result = await _repository.search(event.query);

    result.fold(
      (failure) => emit(DeliveryError(failure: failure)),
      (req) => req.isEmpty
          ? emit(const DeliveryEmpty())
          : emit(DeliveryLoaded(
              requests: req,
              activeFilter: _activeFilter,
              query: _searchQuery,
            )),
    );
  }

  Future<void> _onFilter(
    FilterDeliveriesByStatus event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(const DeliveryLoading());
    _activeFilter = event.status;
    _searchQuery = '';
    await _loadDeliveries(emit);
  }

  Future<void> _onUpdateStatus(
    UpdateDeliveryStatus event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(const DeliveryLoading());
    final result = await _repository.updateStatus(event.id, event.status);

    result.fold(
      (failure) => emit(DeliveryError(failure: failure)),
      (_) {
        emit(DeliveryOperationSuccess('Status updated to ${event.status.displayLabel}'));
        add(const LoadDeliveries());
      },
    );
  }
}
