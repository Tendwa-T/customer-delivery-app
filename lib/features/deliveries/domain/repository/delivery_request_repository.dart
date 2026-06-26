import 'package:customer_delivery_app/core/error/failures.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:fpdart/fpdart.dart';

abstract class DeliveryRequestRepository {
  Future<Either<AppFailure, List<DeliveryRequest>>> getAll();

  Future<Either<AppFailure, DeliveryRequest>> getById(int id);

  Future<Either<AppFailure, List<DeliveryRequest>>> search(String query);

  Future<Either<AppFailure, List<DeliveryRequest>>> filterByStatus(
    DeliveryStatus? status,
  );

  Future<Either<AppFailure, DeliveryRequest>> insert(DeliveryRequest req);

  Future<Either<AppFailure, Unit>> update(DeliveryRequest req);

  Future<Either<AppFailure, Unit>> delete(int id);
}
