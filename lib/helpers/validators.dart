class Validators {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, introduce un valor válido';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    RegExp regExp = RegExp(r'[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+');

    if (value != null && regExp.hasMatch(value)) {
      return null;
    } else {
      return 'Por favor, introduce un email válido';
    }
  }

  static String? validatePassword(String? password) {
    if (password == null || password.length < 6) {
      return 'Por favor, introduce una contraseña con al menos 6 caracteres.';
    }
    return null;
  }
}
