class Validators {
  const Validators._();

  static String? pickupAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pickup address is required';
    }
    if (value.trim().length < 5) {
      return 'Please enter a valid pickup address';
    }
    return null;
  }

  static String? deliveryAddres(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Delivery Address is required';
    }
    if (value.trim().length < 5) {
      return 'Please enter a valid delivery address';
    }
    return null;
  }

  static String? packageDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Package description is required';
    }
    return null;
  }

  static String? packageWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Package weight is required';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid number';
    }
    if (parsed <= 0) {
      return 'Weight must be greater than 0';
    }
    return null;
  }
}
