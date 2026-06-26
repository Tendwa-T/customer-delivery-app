import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';

class DeliveryRequestModel {
  const DeliveryRequestModel({
    this.id,
    required this.pickUpAddress,
    required this.deliveryAddress,
    required this.packageDescription,
    required this.packageCode,
    required this.packageWeight,
    required this.status,
    required this.createdAt,
  });

  final int? id;
  final String pickUpAddress;
  final String deliveryAddress;
  final String packageDescription;
  final String packageCode;
  final double packageWeight;
  final DeliveryStatus status;
  final DateTime createdAt;

  factory DeliveryRequestModel.fromMap(Map<String, dynamic> map) {
    return DeliveryRequestModel(
      id: map['id'] as int?,
      pickUpAddress: map['pickup_address'] as String,
      deliveryAddress: map['delivery_address'] as String,
      packageDescription: map['package_description'] as String,
      packageCode: map['package_code'] as String,
      packageWeight: double.parse(map['package_weight'].toString()),
      status: DeliveryStatus.toEnum(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Unwanted Edit to 'created_at'
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'pickup_address': pickUpAddress,
      'delivery_address': deliveryAddress,
      'package_description': packageDescription,
      'package_code': packageCode,
      'package_weight': packageWeight,
      'status': status.toDbString(),
      'created_at': createdAt.toIso8601String(),
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory DeliveryRequestModel.fromEntity(DeliveryRequest entity) {
    return DeliveryRequestModel(
      id: entity.id,
      pickUpAddress: entity.pickUpAddress,
      deliveryAddress: entity.deliveryAddress,
      packageDescription: entity.packageDescription,
      packageCode: entity.packageCode,
      packageWeight: entity.packageWeight,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  DeliveryRequest toEntity() {
    return DeliveryRequest(
      id: id,
      pickUpAddress: pickUpAddress,
      deliveryAddress: deliveryAddress,
      packageCode: packageCode,
      packageDescription: packageDescription,
      packageWeight: packageWeight,
      status: status,
      createdAt: createdAt,
    );
  }
}
