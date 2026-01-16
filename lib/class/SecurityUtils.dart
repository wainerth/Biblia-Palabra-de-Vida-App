class SecurityUtils {
  // Validar formato de email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  // Sanitizar inputs - eliminar caracteres peligrosos (VERSIÓN CORREGIDA)
  static String sanitizeInput(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'[<>"' ';()&\\/\\-\\-]'), '')
        .substring(0, input.length > 100 ? 100 : input.length);
  }

  // Detectar patrones de SQL injection (VERSIÓN CORREGIDA)
  static bool hasSqlInjectionPatterns(String input) {
    final dangerousWords = [
      'UNION',
      'SELECT',
      'INSERT',
      'UPDATE',
      'DELETE',
      'DROP',
      'CREATE',
      'ALTER',
      'EXEC',
      'EXECUTE',
      'SCRIPT',
      'OR 1=1',
      'AND 1=1',
      'WAITFOR',
      'DELAY',
      'SHUTDOWN',
      '--',
      '/*',
      '*/'
    ];

    final upperInput = input.toUpperCase();
    return dangerousWords.any((word) => upperInput.contains(word));
  }

  // Validar fuerza de contraseña
  static bool isStrongPassword(String password) {
    if (password.length < 6) return false;

    // final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    // final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    // final hasDigits = RegExp(r'[0-9]').hasMatch(password);
    // final hasSpecialChars =
        // RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return true; //hasUpperCase && hasLowerCase && hasSpecialChars;
  }

  // Limpiar y validar inputs para GraphQL
  static String prepareInputForGraphQL(String input) {
    final sanitized = sanitizeInput(input);

    if (hasSqlInjectionPatterns(sanitized)) {
      throw FormatException('Entrada contiene patrones sospechosos');
    }

    return sanitized;
  }
}
