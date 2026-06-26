part of 'delivery_bloc.dart';

sealed class DeliveryEvent extends Equatable {
  const DeliveryEvent();

  @override
  List<Object?> get props => [];
}

class LoadDeliveries extends DeliveryEvent {
  const LoadDeliveries();
}

class AddDelivery extends DeliveryEvent {
  const AddDelivery(this.req);
  final DeliveryRequest req;

  @override
  List<Object?> get props => [req];
}

class UpdateDelivery extends DeliveryEvent {
  const UpdateDelivery(this.req);
  final DeliveryRequest req;

  @override
  List<Object?> get props => [req];
}

class DeleteDelivery extends DeliveryEvent {
  const DeleteDelivery(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}

class SearchDeliveries extends DeliveryEvent {
  const SearchDeliveries(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class FilterDeliveriesByStatus extends DeliveryEvent {
  const FilterDeliveriesByStatus(this.status);
  final DeliveryStatus? status;

  @override
  List<Object?> get props => [status];
}

class UpdateDeliveryStatus extends DeliveryEvent {
  const UpdateDeliveryStatus(this.id, this.status);
  final int id;
  final DeliveryStatus status;

  @override
  List<Object?> get props => [id, status];
}
