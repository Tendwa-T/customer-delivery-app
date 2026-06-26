part of 'delivery_bloc.dart';

sealed class DeliveryState extends Equatable {
  const DeliveryState();

  @override
  List<Object?> get props => [];
}

class DeliveryInitial extends DeliveryState {
  const DeliveryInitial();
}

class DeliveryLoading extends DeliveryState {
  const DeliveryLoading();
}

const Object _filter = Object();

class DeliveryLoaded extends DeliveryState {
  const DeliveryLoaded({
    required this.requests,
    this.activeFilter,
    this.query = "",
  });

  final List<DeliveryRequest> requests;
  final DeliveryStatus? activeFilter;
  final String query;

  DeliveryLoaded copyWith({
    List<DeliveryRequest>? requests,
    Object? activeFilter = _filter,
    String? query,
  }) {
    return DeliveryLoaded(
      requests: requests ?? this.requests,
      activeFilter: activeFilter == _filter
          ? this.activeFilter
          : activeFilter as DeliveryStatus?,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [requests, activeFilter, query];
}

class DeliveryEmpty extends DeliveryState {
  const DeliveryEmpty();
}

class DeliveryOperationSuccess extends DeliveryState {
  const DeliveryOperationSuccess(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class DeliveryError extends DeliveryState {
  const DeliveryError({required this.failure});

  final AppFailure failure;

  String get message => failure.message;

  bool get isEditGuarded => failure is EditNotAllowed;

  @override
  List<Object?> get props => [failure];
}
