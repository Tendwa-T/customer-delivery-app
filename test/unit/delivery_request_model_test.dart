import 'package:customer_delivery_app/features/deliveries/data/models/delivery_request_model.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeliveryRequestModel Tests', () {
    final now = DateTime.now();

    test(
      'should correctly deserialize from map when package_weight is a string',
      () {
        final map = {
          'id': 1,
          'pickup_address': 'Moi Avenue, Nairobi',
          'delivery_address': 'Langata Road, Nairobi',
          'package_description': 'Box of books',
          'package_code': 'PK-1234',
          'package_weight': '2.5',
          'status': 'pending',
          'created_at': now.toIso8601String(),
        };

        final model = DeliveryRequestModel.fromMap(map);

        expect(model.id, 1);
        expect(model.pickUpAddress, 'Moi Avenue, Nairobi');
        expect(model.deliveryAddress, 'Langata Road, Nairobi');
        expect(model.packageDescription, 'Box of books');
        expect(model.packageCode, 'PK-1234');
        expect(model.packageWeight, 2.5);
        expect(model.status, DeliveryStatus.pending);
        expect(model.createdAt, now);
      },
    );

    test(
      'should correctly deserialize from map when package_weight is a number',
      () {
        final map = {
          'id': 2,
          'pickup_address': 'Kenyatta Ave, Nairobi',
          'delivery_address': 'Ngong Road, Nairobi',
          'package_description': 'Documents',
          'package_code': 'PK-5678',
          'package_weight': 1.2,
          'status': 'in_transit',
          'created_at': now.toIso8601String(),
        };

        final model = DeliveryRequestModel.fromMap(map);

        expect(model.packageWeight, 1.2);
        expect(model.status, DeliveryStatus.inTransit);
      },
    );

    test('should serialize correctly to a map', () {
      final model = DeliveryRequestModel(
        id: 3,
        pickUpAddress: 'Westlands, Nairobi',
        deliveryAddress: 'Kilimani, Nairobi',
        packageDescription: 'Electronics',
        packageCode: 'PK-9999',
        packageWeight: 4.5,
        status: DeliveryStatus.delivered,
        createdAt: now,
      );

      final map = model.toMap();

      expect(map['id'], 3);
      expect(map['pickup_address'], 'Westlands, Nairobi');
      expect(map['delivery_address'], 'Kilimani, Nairobi');
      expect(map['package_description'], 'Electronics');
      expect(map['package_code'], 'PK-9999');
      expect(map['package_weight'], 4.5);
      expect(map['status'], 'delivered');
      expect(map['created_at'], now.toIso8601String());
    });
  });
}
