import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:flutter/material.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  final DeliveryStatus? filter;
  final ValueChanged<DeliveryStatus?> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(context, label: 'All', status: null),
          const SizedBox(width: 8),
          _chip(context, label: 'Pending', status: DeliveryStatus.pending),
          const SizedBox(width: 8),
          _chip(context, label: 'In Transit', status: DeliveryStatus.inTransit),
          const SizedBox(width: 8),
          _chip(context, label: 'Delivered', status: DeliveryStatus.delivered),
          const SizedBox(width: 8),
          _chip(context, label: 'Cancelled', status: DeliveryStatus.cancelled),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required DeliveryStatus? status,
  }) {
    final isSelected = filter == status;
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onFilterChanged(status),
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface,
        fontSize: 13,
      ),
      side: BorderSide(
        color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        width: 0.5,
      ),
    );
  }
}
