import 'package:customer_delivery_app/core/error/failures.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/bloc/delivery_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  late FakeDeliveryRequestRepository repository;
  late DeliveryBloc bloc;

  setUp(() {
    repository = FakeDeliveryRequestRepository();
    bloc = DeliveryBloc(repository: repository);
  });

  tearDown(() {
    bloc.close();
  });

  group('DeliveryBloc Tests', () {
    test('initial state should be DeliveryInitial', () {
      expect(bloc.state, const DeliveryInitial());
    });

    test('LoadDeliveries emits [DeliveryLoading, DeliveryEmpty] when repository is empty', () async {
      final expectedStates = [
        const DeliveryLoading(),
        const DeliveryEmpty(),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoadDeliveries());
    });

    test('LoadDeliveries emits [DeliveryLoading, DeliveryLoaded] when repository contains data', () async {
      final req = DeliveryRequest(
        id: 1,
        packageCode: 'PK-1111',
        pickUpAddress: 'A',
        deliveryAddress: 'B',
        packageDescription: 'Box',
        packageWeight: 1.0,
        createdAt: DateTime.now(),
      );
      repository.deliveries.add(req);

      final expectedStates = [
        const DeliveryLoading(),
        DeliveryLoaded(requests: [req]),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoadDeliveries());
    });

    test('LoadDeliveries emits [DeliveryLoading, DeliveryError] when repository fails', () async {
      const failure = UnexpectedFailure(message: 'Database error');
      repository.failureToThrow = failure;

      final expectedStates = [
        const DeliveryLoading(),
        const DeliveryError(failure: failure),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoadDeliveries());
    });

    test('AddDelivery emits [DeliveryLoading, DeliveryOperationSuccess] and triggers load', () async {
      final req = DeliveryRequest(
        packageCode: 'PK-2222',
        pickUpAddress: 'Pickup',
        deliveryAddress: 'Dropoff',
        packageDescription: 'Envelop',
        packageWeight: 0.5,
        createdAt: DateTime.now(),
      );

      // AddDelivery triggers insert which succeeds, emits DeliveryOperationSuccess,
      // and then calls add(LoadDeliveries) which emits DeliveryLoading and then DeliveryLoaded.
      final expectedStates = [
        const DeliveryLoading(),
        const DeliveryOperationSuccess('Delivery Request created'),
        const DeliveryLoading(),
        isA<DeliveryLoaded>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(AddDelivery(req));
    });

    test('UpdateDeliveryStatus to inTransit updates status and preserves/updates state list', () async {
      final req = DeliveryRequest(
        id: 1,
        packageCode: 'PK-1234',
        pickUpAddress: 'A',
        deliveryAddress: 'B',
        packageDescription: 'Box',
        packageWeight: 1.0,
        status: DeliveryStatus.pending,
        createdAt: DateTime.now(),
      );
      repository.deliveries.add(req);

      final expectedStates = [
        const DeliveryLoading(),
        const DeliveryOperationSuccess('Status updated to In Transit'),
        const DeliveryLoading(),
        isA<DeliveryLoaded>().having((s) => s.requests.first.status, 'status', DeliveryStatus.inTransit),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const UpdateDeliveryStatus(1, DeliveryStatus.inTransit));
    });

    test('FilterDeliveriesByStatus filters list and LoadDeliveries preserves filter', () async {
      final req1 = DeliveryRequest(
        id: 1,
        packageCode: 'PK-1',
        pickUpAddress: 'A',
        deliveryAddress: 'B',
        packageDescription: 'Box 1',
        packageWeight: 1.0,
        status: DeliveryStatus.pending,
        createdAt: DateTime.now(),
      );
      final req2 = DeliveryRequest(
        id: 2,
        packageCode: 'PK-2',
        pickUpAddress: 'C',
        deliveryAddress: 'D',
        packageDescription: 'Box 2',
        packageWeight: 2.0,
        status: DeliveryStatus.inTransit,
        createdAt: DateTime.now(),
      );
      repository.deliveries.addAll([req1, req2]);

      final expectedStates = [
        const DeliveryLoading(),
        isA<DeliveryLoaded>()
            .having((s) => s.requests.length, 'length', 1)
            .having((s) => s.requests.first.id, 'id', 1)
            .having((s) => s.activeFilter, 'activeFilter', DeliveryStatus.pending),
        const DeliveryLoading(),
        isA<DeliveryLoaded>()
            .having((s) => s.requests.length, 'length', 1)
            .having((s) => s.requests.first.id, 'id', 1)
            .having((s) => s.activeFilter, 'activeFilter', DeliveryStatus.pending),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const FilterDeliveriesByStatus(DeliveryStatus.pending));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const LoadDeliveries());
    });
  });
}
