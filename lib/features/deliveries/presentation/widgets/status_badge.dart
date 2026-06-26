import 'package:customer_delivery_app/core/theme/theme.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final DeliveryStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColors = theme.extension<StatusColors>();
    final colorKey = _toColorKey(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColors!.containerFor(colorKey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.displayLabel,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: statusColors.foregroundFor(colorKey),
        ),
      ),
    );
  }

  DeliveryStatusColor _toColorKey(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.pending:
        return DeliveryStatusColor.pending;
      case DeliveryStatus.inTransit:
        return DeliveryStatusColor.inTransit;
      case DeliveryStatus.delivered:
        return DeliveryStatusColor.delivered;
      case DeliveryStatus.cancelled:
        return DeliveryStatusColor.cancelled;
    }
  }
}
