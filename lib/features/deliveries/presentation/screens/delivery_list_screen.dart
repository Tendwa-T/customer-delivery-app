import 'package:customer_delivery_app/common/widgets/empty_state_widget.dart';
import 'package:customer_delivery_app/common/widgets/error_state_widget.dart';
import 'package:customer_delivery_app/core/navigation/router.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/bloc/delivery_bloc.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/widgets/delivery_card.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/widgets/filter_chips_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeliveryListScreen extends StatefulWidget {
  const DeliveryListScreen({super.key});

  @override
  State<DeliveryListScreen> createState() => _DeliveryListScreenState();
}

class _DeliveryListScreenState extends State<DeliveryListScreen> {
  final _searchController = TextEditingController();
  DeliveryStatus? _activeFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deliveries'),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search deliveries ...',
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          context.read<DeliveryBloc>().add(
                            const SearchDeliveries(''),
                          );
                        },
                        icon: const Icon(Icons.close),
                      ),
                  ],
                  onChanged: (query) {
                    setState(() {});
                    context.read<DeliveryBloc>().add(SearchDeliveries(query));
                  },
                ),
              ),
              // Filter Chips
              FilterChipsRow(
                filter: _activeFilter,
                onFilterChanged: (status) {
                  setState(() {
                    _activeFilter = status;
                  });
                  context.read<DeliveryBloc>().add(
                    FilterDeliveriesByStatus(status),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<DeliveryBloc, DeliveryState>(
        listener: (context, state) {
          if (state is DeliveryError && state.isEditGuarded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is DeliveryLoaded) {
            setState(() {
              _activeFilter = state.activeFilter;
              if (_searchController.text != state.query) {
                _searchController.text = state.query;
              }
            });
          }
        },
        builder: (context, state) {
          if (state is DeliveryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DeliveryEmpty) {
            return EmptyStateWidget(
              hasFilter:
                  _activeFilter != null || _searchController.text.isNotEmpty,
            );
          }

          if (state is DeliveryError && !state.isEditGuarded) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () =>
                  context.read<DeliveryBloc>().add(const LoadDeliveries()),
            );
          }

          if (state is DeliveryLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DeliveryBloc>().add(const LoadDeliveries());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final req = state.requests[index];
                  return DeliveryCard(
                    request: req,
                    onTap: () => context.goNamed(
                      RouteNames.detail,
                      pathParameters: {'id': req.id.toString()},
                      extra: req,
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
