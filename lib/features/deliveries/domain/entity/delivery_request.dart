import 'package:equatable/equatable.dart';

enum DeliveryStatus {
  pending,
  inTransit,
  delivered,
  cancelled;

  String toDbString() {
    switch (this) {
      case DeliveryStatus.pending:
        return 'pending';
      case DeliveryStatus.inTransit:
        return 'in_transit';
      case DeliveryStatus.delivered:
        return 'delivered';
      case DeliveryStatus.cancelled:
        return 'cancelled';
    }
  }

  static DeliveryStatus toEnum(String val) {
    switch (val) {
      case 'in_transit':
        return DeliveryStatus.inTransit;
      case 'delivered':
        return DeliveryStatus.delivered;
      case 'cancelled':
        return DeliveryStatus.cancelled;
      case 'pending':
      default:
        return DeliveryStatus.pending;
    }
  }

  String get displayLabel {
    switch (this) {
      case DeliveryStatus.pending:
        return 'Pending';
      case DeliveryStatus.inTransit:
        return 'In Transit';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get canEdit => this == DeliveryStatus.pending;
}

enum PackageWeightUnits {
  grams,
  kilograms;

  String toDbString() {
    switch (this) {
      case PackageWeightUnits.kilograms:
        return 'kg';
      case PackageWeightUnits.grams:
        return 'g';
    }
  }

  static PackageWeightUnits toEnum(String val) {
    switch (val) {
      case 'kilograms':
        return PackageWeightUnits.kilograms;
      case 'grams':
      default:
        return PackageWeightUnits.grams;
    }
  }

  String get displayLabel {
    switch (this) {
      case PackageWeightUnits.kilograms:
        return 'Kg';
      case PackageWeightUnits.grams:
        return 'g';
    }
  }
}

class DeliveryRequest extends Equatable {
  const DeliveryRequest({
    this.id,
    required this.packageCode,
    required this.pickUpAddress,
    required this.deliveryAddress,
    required this.packageDescription,
    required this.packageWeight,
    this.status = DeliveryStatus.pending,
    required this.createdAt,
  });

  final int? id;
  final String packageCode;
  final String pickUpAddress;
  final String deliveryAddress;
  final String packageDescription;
  final double packageWeight;
  final DeliveryStatus status;
  final DateTime createdAt;

  DeliveryRequest copyWith({
    int? id,
    String? packageCode,
    String? pickUpAddress,
    String? deliveryAddress,
    String? packageDescription,
    double? packageWeight,
    DeliveryStatus? status,
    DateTime? createdAt,
  }) {
    return DeliveryRequest(
      id: id ?? this.id,
      pickUpAddress: pickUpAddress ?? this.pickUpAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      packageCode: packageCode ?? this.packageCode,
      packageDescription: packageDescription ?? this.packageDescription,
      packageWeight: packageWeight ?? this.packageWeight,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    pickUpAddress,
    deliveryAddress,
    packageCode,
    packageDescription,
    packageWeight,
    status,
    createdAt,
  ];
}
