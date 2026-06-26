import 'package:flutter/material.dart';

class DeliveryItemCard extends StatelessWidget {
  const DeliveryItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            // Card Header (Icon - Column(Id - Name) - Status)
            Row(children: []),
            const SizedBox(height: 6),

            // Pickup(Row(Icon - textField with hint)) - Delivery(Row(Icon - textField with hint))
            Column(children: []),

            Divider(),

            // Weight - ActionButtons
            Row(children: []),
          ],
        ),
      ),
    );
  }
}
