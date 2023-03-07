class Validators {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty)
      return 'Por favor, introduce un valor válido';
  }
}
