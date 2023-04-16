class Validators {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, introduce un valor válido';
    }

    return null;
  }

  static String? validateCurrentEmail(String? value, email) {
    if (value == null || value.isEmpty) {
      return 'Debe introducir la dirección de correo asociada a su perfil.';
    } else if (value != email) {
      return 'Debe introducir la dirección de correo asociada a su perfil.';
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

  static String? validateDateTimeRange(String? value, int advanced) {
    RegExp regExp = RegExp(
        r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01]) ([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');

    DateTime? dateTime;
    DateTime now;
    if (value != null && regExp.hasMatch(value)) {
      dateTime = DateTime.parse(value);
      now = DateTime.now();
      final difference =
          dateTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
      final differenceInDays =
          Duration(days: (difference / (1000 * 60 * 60 * 24)).floor()).inDays;

      if (!dateTime.isAfter(now)) {
        return 'Solo puedes crear eventos con fecha en el futuro.';
      }

      if (advanced != -1 && differenceInDays > advanced) {
        return 'Solo puedes crear eventos con $advanced días de antelación.';
      }

      return null;
    } else {
      return 'Invalid date format';
    }
  }

  static String? validateDate(String? value) {
    RegExp regExp =
        RegExp(r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$');

    if (value != null && regExp.hasMatch(value)) {
      return null;
    } else {
      return 'Por favor, introduce una fecha con el formato YYYY-mm-dd';
    }
  }

  static String? validateTime(String? value) {
    RegExp regExp = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');

    if (value != null && regExp.hasMatch(value)) {
      return null;
    } else {
      return 'Por favor, introduce una hora con el formato HH:mm';
    }
  }

  static String? validatePassword(String? password) {
    if (password == null || password.length < 6) {
      return 'Por favor, introduce una contraseña con al menos 6 caracteres.';
    }
    return null;
  }
}
