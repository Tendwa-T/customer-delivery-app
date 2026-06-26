import 'package:customer_delivery_app/core/navigation/router.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/bloc/delivery_bloc.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Load the screen, then load the request then load the view
class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({
    super.key,
    required this.deliveryId,
    this.request,
  });

  final int deliveryId;
  final DeliveryRequest? request;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryBloc, DeliveryState>(
      builder: (context, state) {
        DeliveryRequest? currentRequest;

        if (state is DeliveryLoaded) {
          currentRequest = state.requests.cast<DeliveryRequest?>().firstWhere(
            (r) => r?.id == deliveryId,
            orElse: () => null,
          );
        }
        currentRequest ??= request;

        if (currentRequest != null) {
          return _DetailView(request: currentRequest);
        }

        if (state is DeliveryLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Delivery request not found')),
        );
      },
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.request});

  final DeliveryRequest request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = request.status.canEdit;

    return BlocListener<DeliveryBloc, DeliveryState>(
      listener: (context, state) {
        if (state is DeliveryOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
          if (state.message.toLowerCase().contains('delete')) {
            context.goNamed(RouteNames.list);
          }
        }

        if (state is DeliveryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Request detail'),
          backgroundColor: theme.colorScheme.surface,
          actions: [
            if (isPending)
              IconButton(
                onPressed: () => context.goNamed(
                  RouteNames.edit,
                  pathParameters: {'id': request.id.toString()},
                  extra: request,
                ),
                icon: Icon(Icons.edit_outlined),
                tooltip: 'Edit Request',
              ),
            if (isPending)
              IconButton(
                onPressed: () => _confirmDelete(context),
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                tooltip: 'Delete request',
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  StatusBadge(status: request.status),
                  const Spacer(),
                  Text(
                    _formatDate(request.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _DetailCard(
                children: [
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Pickup address',
                    value: request.deliveryAddress,
                    iconColor: theme.colorScheme.primary,
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.location_on,
                    label: 'Delivery Address',
                    value: request.deliveryAddress,
                    iconColor: theme.colorScheme.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _DetailCard(
                children: [
                  _DetailRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'Package description',
                    value: request.packageDescription,
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.scale_outlined,
                    label: 'Package weight',
                    value: '${request.packageWeight} kg',
                  ),
                ],
              ),

              if (!isPending) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This request cannot be edited or deleted because '
                          'its status is "${request.status.displayLabel}".',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (request.status == DeliveryStatus.pending ||
                  request.status == DeliveryStatus.inTransit)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'Actions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (request.status == DeliveryStatus.pending)
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                context.read<DeliveryBloc>().add(
                                  UpdateDeliveryStatus(
                                    request.id!,
                                    DeliveryStatus.inTransit,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.local_shipping_outlined),
                              label: const Text('Start Transit'),
                            ),
                          ),
                        if (request.status == DeliveryStatus.inTransit)
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                context.read<DeliveryBloc>().add(
                                  UpdateDeliveryStatus(
                                    request.id!,
                                    DeliveryStatus.delivered,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('Deliver'),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                              side: BorderSide(color: theme.colorScheme.error),
                            ),
                            onPressed: () {
                              context.read<DeliveryBloc>().add(
                                UpdateDeliveryStatus(
                                  request.id!,
                                  DeliveryStatus.cancelled,
                                ),
                              );
                            },
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (diaContext) => AlertDialog(
        title: const Text('Delete Request? '),
        content: const Text(
          'This action cannot be undone. '
          'The delivery request will be deleted permanently',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(diaContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              Navigator.of(diaContext).pop();
              context.read<DeliveryBloc>().add(DeleteDelivery(request.id!));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: .start, children: children),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: .start,
      children: [
        Icon(icon, size: 20, color: iconColor ?? colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
