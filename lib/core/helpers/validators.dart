class ValidatorsAuth {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    value = value.toLowerCase();

    // Expressão regular para validar o e-mail
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    // Verifica se o e-mail corresponde à expressão regular
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }

    // Verifica se o e-mail contém espaços em branco
    if (value.contains(' ')) {
      return 'E-mail não pode conter espaços em branco';
    }

    // Verifica se o domínio possui pelo menos um ponto final e caracteres após o ponto final
    final domainParts = value.split('@').last.split('.');
    if (domainParts.length < 2 || domainParts.any((part) => part.isEmpty)) {
      return 'Domínio inválido';
    }

    return null;
  }

  // verifica se o campo de senha está preenchido
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}

class ValidatorsProfile {
  // verifica se o campo de nome completo está preenchido
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    final nameParts = value.trim().split(' ');
    if (nameParts.length < 2) {
      return 'Por favor, insira seu nome completo (Nome e Sobrenome)';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    value = value.toLowerCase();

    // Expressão regular para validar o e-mail
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    // Verifica se o e-mail corresponde à expressão regular
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }

    // Verifica se o e-mail contém espaços em branco
    if (value.contains(' ')) {
      return 'E-mail não pode conter espaços em branco';
    }

    // Verifica se o domínio possui pelo menos um ponto final e caracteres após o ponto final
    final domainParts = value.split('@').last.split('.');
    if (domainParts.length < 2 || domainParts.any((part) => part.isEmpty)) {
      return 'Domínio inválido';
    }

    return null;
  }
}
