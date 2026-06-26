import 'package:customer_delivery_app/core/error/failures.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/domain/repository/delivery_request_repository.dart';
import 'package:fpdart/fpdart.dart';

class FakeDeliveryRequestRepository implements DeliveryRequestRepository {
  List<DeliveryRequest> deliveries = [];
  AppFailure? failureToThrow;

  @override
  Future<Either<AppFailure, List<DeliveryRequest>>> getAll() async {
    if (failureToThrow != null) return left(failureToThrow!);
    return right(deliveries);
  }

  @override
  Future<Either<AppFailure, DeliveryRequest>> getById(int id) async {
    if (failureToThrow != null) return left(failureToThrow!);
    final found = deliveries.firstWhere((element) => element.id == id);
    return right(found);
  }

  @override
  Future<Either<AppFailure, List<DeliveryRequest>>> search(String query) async {
    if (failureToThrow != null) return left(failureToThrow!);
    return right(deliveries);
  }

  @override
  Future<Either<AppFailure, List<DeliveryRequest>>> filterByStatus(
    DeliveryStatus? status,
  ) async {
    if (failureToThrow != null) return left(failureToThrow!);
    return right(deliveries.where((d) => d.status == status).toList());
  }

  @override
  Future<Either<AppFailure, DeliveryRequest>> insert(DeliveryRequest req) async {
    if (failureToThrow != null) return left(failureToThrow!);
    final newDelivery = req.copyWith(id: deliveries.length + 1);
    deliveries.add(newDelivery);
    return right(newDelivery);
  }

  @override
  Future<Either<AppFailure, Unit>> update(DeliveryRequest req) async {
    if (failureToThrow != null) return left(failureToThrow!);
    final index = deliveries.indexWhere((element) => element.id == req.id);
    if (index != -1) {
      deliveries[index] = req;
    }
    return right(unit);
  }

  @override
  Future<Either<AppFailure, Unit>> updateStatus(int id, DeliveryStatus status) async {
    if (failureToThrow != null) return left(failureToThrow!);
    final index = deliveries.indexWhere((element) => element.id == id);
    if (index != -1) {
      deliveries[index] = deliveries[index].copyWith(status: status);
    }
    return right(unit);
  }

  @override
  Future<Either<AppFailure, Unit>> delete(int id) async {
    if (failureToThrow != null) return left(failureToThrow!);
    deliveries.removeWhere((element) => element.id == id);
    return right(unit);
  }
}
