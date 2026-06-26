import 'dart:math';

import 'package:customer_delivery_app/core/utils/validators.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/bloc/delivery_bloc.dart';
import 'package:customer_delivery_app/features/deliveries/presentation/widgets/form_section.dart';
import 'package:customer_delivery_app/core/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeliveryFormScreen extends StatefulWidget {
  const DeliveryFormScreen({super.key, this.editId, this.initialReq});

  final int? editId;
  final DeliveryRequest? initialReq;

  bool get isEditing => editId != null;

  @override
  State<DeliveryFormScreen> createState() => _DeliveryFormScreenState();
}

class _DeliveryFormScreenState extends State<DeliveryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _deliveryController = TextEditingController();
  final _descController = TextEditingController();
  final _weightController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final r = widget.initialReq;
    if (r != null) {
      _pickupController.text = r.pickUpAddress;
      _deliveryController.text = r.deliveryAddress;
      _descController.text = r.packageDescription;
      _weightController.text = r.packageWeight.toString();
    }
  }

  String generatePackageCode() {
    const String prefix = 'PK-';
    const String digits = '0123456789';
    final Random random = Random();

    final String suffix = List.generate(
      4,
      (index) => digits[random.nextInt(digits.length)],
    ).join();

    return '$prefix$suffix';
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _deliveryController.dispose();
    _descController.dispose();
    _weightController.dispose();

    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final weight = double.parse(_weightController.text.trim());

    if (widget.isEditing && widget.initialReq != null) {
      final updated = widget.initialReq!.copyWith(
        pickUpAddress: _pickupController.text.trim(),
        deliveryAddress: _deliveryController.text.trim(),
        packageDescription: _descController.text.trim(),
        packageWeight: weight,
      );

      context.read<DeliveryBloc>().add(UpdateDelivery(updated));
    } else {
      final pkgCode = generatePackageCode();
      final request = DeliveryRequest(
        pickUpAddress: _pickupController.text.trim(),
        deliveryAddress: _deliveryController.text.trim(),
        packageDescription: _descController.text.trim(),
        packageWeight: weight,
        packageCode: pkgCode,
        createdAt: DateTime.now(),
      );
      context.read<DeliveryBloc>().add(AddDelivery(request));
    }
  }

  void _clearForm() {
    _pickupController.clear();
    _deliveryController.clear();
    _descController.clear();
    _weightController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<DeliveryBloc, DeliveryState>(
      listener: (context, state) {
        setState(() => _isLoading = state is DeliveryLoading);
        if (state is DeliveryOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
          _clearForm();
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(RouteNames.list);
          }
        }

        if (state is DeliveryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Edit request' : 'New request'),
          backgroundColor: colorScheme.surface,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form Section
                FormSection(
                  label: 'Pickup Details',
                  child: TextFormField(
                    controller: _pickupController,
                    decoration: const InputDecoration(
                      labelText: 'Pickup address',
                      hintText: 'e.g Moi Avenue, Nairobi',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.pickupAddress,
                    autofocus: !widget.isEditing,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 16),
                FormSection(
                  label: 'Drop-off Details',
                  child: TextFormField(
                    controller: _deliveryController,
                    decoration: const InputDecoration(
                      labelText: 'Drop off address',
                      hintText: 'e.g Langata rd, Nairobi',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.deliveryAddress,
                    autofocus: !widget.isEditing,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 16),
                FormSection(
                  label: 'Package Details',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          labelText: 'Package Description',
                          hintText: 'e.g. tray of eggs, documents, electronics',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                        ),
                        textCapitalization: .sentences,
                        validator: Validators.packageDescription,
                        textInputAction: .next,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          labelText: 'Package weight (kg)',
                          hintText: 'e.g 2.5',
                          prefixIcon: Icon(Icons.scale_outlined),
                          suffixText: "kg",
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: Validators.packageWeight,
                        textInputAction: .done,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.isEditing ? 'Save Changes' : 'Create request',
                        ),
                ),
                if (widget.isEditing) ...[
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (context.canPop()) context.pop();
                          },
                    child: Text('Cancel'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
