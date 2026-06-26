import 'package:customer_delivery_app/common/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';

class DeliveryListScreen extends StatelessWidget {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = MediaQuery.sizeOf(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Center(child: Icon(Icons.add)),
      ),
      appBar: AppBar(
        leading: Icon(
          Icons.local_shipping_outlined,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          'GS-Delivery',
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_outlined),
                    hintText: 'Search tracking number or address',
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text("All Requests"),
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: null,
                        selected: true,
                        selectedColor: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      FilterChip(
                        label: const Text("Pending"),
                        labelStyle: TextStyle(color: Colors.black),
                        onSelected: null,
                        selected: false,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      FilterChip(
                        label: const Text("In Transit"),
                        onSelected: null,
                        selected: false,
                      ),
                      const SizedBox(width: 4),
                      FilterChip(
                        label: const Text("Cancelled"),
                        onSelected: null,
                        selected: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
