// phone_validator_service.dart
import 'package:flutter/foundation.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneValidatorService {
  // 🔹 PAÍSES QUE REQUIEREN VALIDACIÓN ESPECIAL
  static final Map<String, CountryPhoneRules> _countryRules = {
    // ========== AMÉRICA DEL NORTE ==========
    'US': CountryPhoneRules(
      countryCode: '+1',
      name: 'Estados Unidos',
      minLength: 10,
      maxLength: 10,
      validOperators: ['2', '3', '4', '5', '6', '7', '8', '9'], // Códigos de área
      requiresLeadingZero: false,
      description: '10 dígitos (código área + número)',
      strictValidation: true,
    ),
    'CA': CountryPhoneRules(
      countryCode: '+1',
      name: 'Canadá',
      minLength: 10,
      maxLength: 10,
      validOperators: ['2', '3', '4', '5', '6', '7', '8', '9'],
      requiresLeadingZero: false,
      description: '10 dígitos (código área + número)',
      strictValidation: true,
    ),
    'MX': CountryPhoneRules(
      countryCode: '+52',
      name: 'México',
      minLength: 10,
      maxLength: 10,
      validOperators: ['1', '55', '81', '33', '656', '664'],
      requiresLeadingZero: false,
      description: '10 dígitos (lada + número)',
      strictValidation: true,
    ),

    // ========== AMÉRICA LATINA ==========
    'UY': CountryPhoneRules(
      countryCode: '+598',
      name: 'Uruguay',
      minLength: 8,
      maxLength: 8,
      validOperators: ['92', '93', '94', '95', '96', '97', '98', '99'],
      requiresLeadingZero: false,
      description: 'Números móviles: 8 dígitos que comienzan con 9',
      strictValidation: true,
    ),
    'VE': CountryPhoneRules(
      countryCode: '+58',
      name: 'Venezuela',
      minLength: 10,
      maxLength: 10,
      validOperators: ['412', '414', '416', '424', '426'],
      requiresLeadingZero: false,
      description: 'Móviles: 10 dígitos (0412 → 412)',
      strictValidation: true,
    ),
    'AR': CountryPhoneRules(
      countryCode: '+54',
      name: 'Argentina',
      minLength: 10,
      maxLength: 10,
      validOperators: ['11', '221', '223', '261', '299', '341', '351', '381'],
      requiresLeadingZero: false,
      description: 'Celulares: 10 dígitos sin 15',
      strictValidation: true,
    ),
    'BR': CountryPhoneRules(
      countryCode: '+55',
      name: 'Brasil',
      minLength: 10,
      maxLength: 11,
      validOperators: ['11', '21', '31', '41', '51', '61', '71', '81', '91'],
      requiresLeadingZero: false,
      description: 'DDD + 8-9 dígitos',
      strictValidation: true,
    ),
    'CL': CountryPhoneRules(
      countryCode: '+56',
      name: 'Chile',
      minLength: 9,
      maxLength: 9,
      validOperators: ['9'],
      requiresLeadingZero: false,
      description: 'Móviles: 9 dígitos que comienzan con 9',
      strictValidation: true,
    ),
    'CO': CountryPhoneRules(
      countryCode: '+57',
      name: 'Colombia',
      minLength: 10,
      maxLength: 10,
      validOperators: ['3'],
      requiresLeadingZero: false,
      description: 'Móviles: 10 dígitos que comienzan con 3',
      strictValidation: true,
    ),

    // ========== EUROPA ==========
    'ES': CountryPhoneRules(
      countryCode: '+34',
      name: 'España',
      minLength: 9,
      maxLength: 9,
      validOperators: ['6', '7'],
      requiresLeadingZero: false,
      description: '9 dígitos (móviles: 6,7)',
      strictValidation: true,
    ),
    'IT': CountryPhoneRules(
      countryCode: '+39',
      name: 'Italia',
      minLength: 9,
      maxLength: 10,
      validOperators: ['3'],
      requiresLeadingZero: true,
      description: 'Requiere 0 inicial (04... → 4...)',
      strictValidation: true,
    ),
    'FR': CountryPhoneRules(
      countryCode: '+33',
      name: 'Francia',
      minLength: 9,
      maxLength: 9,
      validOperators: ['6', '7'],
      requiresLeadingZero: false,
      description: '9 dígitos (móviles: 6,7)',
      strictValidation: true,
    ),
    'DE': CountryPhoneRules(
      countryCode: '+49',
      name: 'Alemania',
      minLength: 10,
      maxLength: 11,
      validOperators: ['15', '16', '17'],
      requiresLeadingZero: false,
      description: '10-11 dígitos (móviles: 15,16,17)',
      strictValidation: true,
    ),
    'GB': CountryPhoneRules(
      countryCode: '+44',
      name: 'Reino Unido',
      minLength: 10,
      maxLength: 10,
      validOperators: ['7'],
      requiresLeadingZero: false,
      description: '10 dígitos (móviles: 7)',
      strictValidation: true,
    ),

    // Agrega aquí los demás países que necesites...
  };

  // 🔹 VALIDACIÓN PRINCIPAL MEJORADA
  static String? validatePhoneNumber(PhoneNumber? phone) {
    if (phone == null || phone.number.isEmpty) {
      return "Por favor, ingresa tu número de teléfono.";
    }

    final String cleanNumber = phone.number.replaceAll(RegExp(r'[^\d]'), '');
    final String countryCode = phone.countryCode;
    final String countryIsoCode = phone.countryISOCode;

    if (kDebugMode) {
      print('🔍 Validating phone: $cleanNumber for country: $countryIsoCode ($countryCode)');
    }

    // 🔹 VALIDACIÓN PARA PAÍSES CON REGLAS ESPECÍFICAS
    if (_countryRules.containsKey(countryIsoCode)) {
      final validationResult = _validateWithCountryRules(
        cleanNumber, 
        _countryRules[countryIsoCode]!
      );
      
      if (kDebugMode && validationResult != null) {
        if (kDebugMode) {
          print('❌ Validation failed: $validationResult');
        }
      }
      
      return validationResult;
    }

    // 🔹 VALIDACIÓN PARA PAÍSES NO LISTADOS (más estricta)
    return _validateUnlistedCountry(cleanNumber, countryCode, countryIsoCode);
  }

  // 🔹 VALIDACIÓN CON REGLAS ESPECÍFICAS DEL PAÍS
  static String? _validateWithCountryRules(
    String number, 
    CountryPhoneRules rules
  ) {
    // Validar longitud mínima
    if (number.length < rules.minLength) {
      return "${rules.name} debe tener al menos ${rules.minLength} dígitos.";
    }

    // Validar longitud máxima
    if (number.length > rules.maxLength) {
      return "El número de ${rules.name} no puede tener\n más de ${rules.maxLength} dígitos.";
    }

    // Validar código de operador si está definido y es validación estricta
    if (rules.strictValidation && rules.validOperators.isNotEmpty) {
      bool validOperator = false;
      for (String operator in rules.validOperators) {
        if (number.startsWith(operator)) {
          validOperator = true;
          break;
        }
      }
      
      if (!validOperator) {
        return "Número inválido para ${rules.name}. Debe comenzar con: ${rules.validOperators.join(', ')}";
      }
    }

    if (kDebugMode) {
      print('✅ Phone validation passed for ${rules.name}');
    }

    return null; // Válido
  }

  // 🔹 VALIDACIÓN PARA PAÍSES NO LISTADOS (más inteligente)
  static String? _validateUnlistedCountry(
    String number, 
    String countryCode, 
    String countryIsoCode
  ) {
    // Longitud basada en el código del país
    final expectedLength = _getExpectedLengthForCountry(countryCode);
    
    if (number.length < expectedLength.min) {
      return "El número es demasiado corto. Mínimo ${expectedLength.min} dígitos.";
    }

    if (number.length > expectedLength.max) {
      return "El número es demasiado largo. Máximo ${expectedLength.max} dígitos.";
    }

    // Validación de caracteres (solo dígitos)
    if (!RegExp(r'^\d+$').hasMatch(number)) {
      return "El número debe contener solo dígitos.";
    }

    if (kDebugMode) {
      print('✅ Generic validation passed for $countryIsoCode: $number (${number.length} digits)');
    }

    return null;
  }

  // 🔹 OBTENER LONGITUD ESPERADA BASADA EN CÓDIGO DEL PAÍS
  static _PhoneLength _getExpectedLengthForCountry(String countryCode) {
    switch (countryCode) {
      case '+1': // USA, Canada
        return _PhoneLength(min: 10, max: 10);
      case '+7': // Rusia, Kazakhstan
        return _PhoneLength(min: 10, max: 10);
      case '+20': // Egipto
        return _PhoneLength(min: 10, max: 10);
      case '+27': // Sudáfrica
        return _PhoneLength(min: 9, max: 9);
      case '+30': // Grecia
        return _PhoneLength(min: 10, max: 10);
      case '+31': // Países Bajos
        return _PhoneLength(min: 9, max: 9);
      case '+32': // Bélgica
        return _PhoneLength(min: 9, max: 9);
      case '+33': // Francia
        return _PhoneLength(min: 9, max: 9);
      case '+34': // España
        return _PhoneLength(min: 9, max: 9);
      case '+36': // Hungría
        return _PhoneLength(min: 9, max: 9);
      case '+39': // Italia
        return _PhoneLength(min: 9, max: 10);
      case '+41': // Suiza
        return _PhoneLength(min: 9, max: 9);
      case '+43': // Austria
        return _PhoneLength(min: 10, max: 13);
      case '+44': // Reino Unido
        return _PhoneLength(min: 10, max: 10);
      case '+45': // Dinamarca
        return _PhoneLength(min: 8, max: 8);
      case '+46': // Suecia
        return _PhoneLength(min: 9, max: 9);
      case '+47': // Noruega
        return _PhoneLength(min: 8, max: 8);
      case '+48': // Polonia
        return _PhoneLength(min: 9, max: 9);
      case '+49': // Alemania
        return _PhoneLength(min: 10, max: 11);
      case '+51': // Perú
        return _PhoneLength(min: 9, max: 9);
      case '+52': // México
        return _PhoneLength(min: 10, max: 10);
      case '+53': // Cuba
        return _PhoneLength(min: 8, max: 8);
      case '+54': // Argentina
        return _PhoneLength(min: 10, max: 10);
      case '+55': // Brasil
        return _PhoneLength(min: 10, max: 11);
      case '+56': // Chile
        return _PhoneLength(min: 9, max: 9);
      case '+57': // Colombia
        return _PhoneLength(min: 10, max: 10);
      case '+58': // Venezuela
        return _PhoneLength(min: 10, max: 10);
      case '+60': // Malasia
        return _PhoneLength(min: 9, max: 10);
      case '+61': // Australia
        return _PhoneLength(min: 9, max: 9);
      case '+62': // Indonesia
        return _PhoneLength(min: 9, max: 11);
      case '+63': // Filipinas
        return _PhoneLength(min: 10, max: 10);
      case '+64': // Nueva Zelanda
        return _PhoneLength(min: 8, max: 9);
      case '+65': // Singapur
        return _PhoneLength(min: 8, max: 8);
      case '+66': // Tailandia
        return _PhoneLength(min: 9, max: 9);
      case '+81': // Japón
        return _PhoneLength(min: 10, max: 10);
      case '+82': // Corea del Sur
        return _PhoneLength(min: 9, max: 10);
      case '+84': // Vietnam
        return _PhoneLength(min: 9, max: 9);
      case '+86': // China
        return _PhoneLength(min: 11, max: 11);
      case '+90': // Turquía
        return _PhoneLength(min: 10, max: 10);
      case '+91': // India
        return _PhoneLength(min: 10, max: 10);
      case '+92': // Pakistán
        return _PhoneLength(min: 10, max: 10);
      case '+93': // Afganistán
        return _PhoneLength(min: 9, max: 9);
      case '+94': // Sri Lanka
        return _PhoneLength(min: 9, max: 9);
      case '+95': // Myanmar
        return _PhoneLength(min: 8, max: 9);
      case '+98': // Irán
        return _PhoneLength(min: 10, max: 10);
      case '+212': // Marruecos
        return _PhoneLength(min: 9, max: 9);
      case '+213': // Argelia
        return _PhoneLength(min: 9, max: 9);
      case '+216': // Túnez
        return _PhoneLength(min: 8, max: 8);
      case '+218': // Libia
        return _PhoneLength(min: 9, max: 9);
      case '+220': // Gambia
        return _PhoneLength(min: 7, max: 7);
      case '+221': // Senegal
        return _PhoneLength(min: 9, max: 9);
      case '+222': // Mauritania
        return _PhoneLength(min: 8, max: 8);
      case '+223': // Malí
        return _PhoneLength(min: 8, max: 8);
      case '+224': // Guinea
        return _PhoneLength(min: 9, max: 9);
      case '+225': // Costa de Marfil
        return _PhoneLength(min: 10, max: 10);
      case '+226': // Burkina Faso
        return _PhoneLength(min: 8, max: 8);
      case '+227': // Níger
        return _PhoneLength(min: 8, max: 8);
      case '+228': // Togo
        return _PhoneLength(min: 8, max: 8);
      case '+229': // Benín
        return _PhoneLength(min: 8, max: 8);
      case '+230': // Mauricio
        return _PhoneLength(min: 7, max: 7);
      case '+231': // Liberia
        return _PhoneLength(min: 7, max: 8);
      case '+232': // Sierra Leona
        return _PhoneLength(min: 8, max: 8);
      case '+233': // Ghana
        return _PhoneLength(min: 9, max: 9);
      case '+234': // Nigeria
        return _PhoneLength(min: 10, max: 10);
      case '+235': // Chad
        return _PhoneLength(min: 8, max: 8);
      case '+236': // República Centroafricana
        return _PhoneLength(min: 8, max: 8);
      case '+237': // Camerún
        return _PhoneLength(min: 9, max: 9);
      case '+238': // Cabo Verde
        return _PhoneLength(min: 7, max: 7);
      case '+239': // Santo Tomé y Príncipe
        return _PhoneLength(min: 7, max: 7);
      case '+240': // Guinea Ecuatorial
        return _PhoneLength(min: 9, max: 9);
      case '+241': // Gabón
        return _PhoneLength(min: 7, max: 7);
      case '+242': // República del Congo
        return _PhoneLength(min: 9, max: 9);
      case '+243': // República Democrática del Congo
        return _PhoneLength(min: 9, max: 9);
      case '+244': // Angola
        return _PhoneLength(min: 9, max: 9);
      case '+245': // Guinea-Bisáu
        return _PhoneLength(min: 7, max: 7);
      case '+246': // Territorio Británico del Océano Índico
        return _PhoneLength(min: 7, max: 7);
      case '+247': // Ascensión
        return _PhoneLength(min: 4, max: 4);
      case '+248': // Seychelles
        return _PhoneLength(min: 7, max: 7);
      case '+249': // Sudán
        return _PhoneLength(min: 9, max: 9);
      case '+250': // Ruanda
        return _PhoneLength(min: 9, max: 9);
      case '+251': // Etiopía
        return _PhoneLength(min: 9, max: 9);
      case '+252': // Somalia
        return _PhoneLength(min: 8, max: 8);
      case '+253': // Yibuti
        return _PhoneLength(min: 8, max: 8);
      case '+254': // Kenia
        return _PhoneLength(min: 9, max: 9);
      case '+255': // Tanzania
        return _PhoneLength(min: 9, max: 9);
      case '+256': // Uganda
        return _PhoneLength(min: 9, max: 9);
      case '+257': // Burundi
        return _PhoneLength(min: 8, max: 8);
      case '+258': // Mozambique
        return _PhoneLength(min: 9, max: 9);
      case '+260': // Zambia
        return _PhoneLength(min: 9, max: 9);
      case '+261': // Madagascar
        return _PhoneLength(min: 9, max: 9);
      case '+262': // Reunión
        return _PhoneLength(min: 9, max: 9);
      case '+263': // Zimbabue
        return _PhoneLength(min: 9, max: 9);
      case '+264': // Namibia
        return _PhoneLength(min: 9, max: 9);
      case '+265': // Malaui
        return _PhoneLength(min: 9, max: 9);
      case '+266': // Lesoto
        return _PhoneLength(min: 8, max: 8);
      case '+267': // Botsuana
        return _PhoneLength(min: 8, max: 8);
      case '+268': // Suazilandia
        return _PhoneLength(min: 8, max: 8);
      case '+269': // Comoras
        return _PhoneLength(min: 7, max: 7);
      case '+290': // Santa Elena
        return _PhoneLength(min: 4, max: 4);
      case '+291': // Eritrea
        return _PhoneLength(min: 7, max: 7);
      case '+297': // Aruba
        return _PhoneLength(min: 7, max: 7);
      case '+298': // Islas Feroe
        return _PhoneLength(min: 6, max: 6);
      case '+299': // Groenlandia
        return _PhoneLength(min: 6, max: 6);
      case '+350': // Gibraltar
        return _PhoneLength(min: 8, max: 8);
      case '+351': // Portugal
        return _PhoneLength(min: 9, max: 9);
      case '+352': // Luxemburgo
        return _PhoneLength(min: 9, max: 9);
      case '+353': // Irlanda
        return _PhoneLength(min: 9, max: 9);
      case '+354': // Islandia
        return _PhoneLength(min: 7, max: 7);
      case '+355': // Albania
        return _PhoneLength(min: 9, max: 9);
      case '+356': // Malta
        return _PhoneLength(min: 8, max: 8);
      case '+357': // Chipre
        return _PhoneLength(min: 8, max: 8);
      case '+358': // Finlandia
        return _PhoneLength(min: 9, max: 9);
      case '+359': // Bulgaria
        return _PhoneLength(min: 9, max: 9);
      case '+370': // Lituania
        return _PhoneLength(min: 8, max: 8);
      case '+371': // Letonia
        return _PhoneLength(min: 8, max: 8);
      case '+372': // Estonia
        return _PhoneLength(min: 7, max: 7);
      case '+373': // Moldavia
        return _PhoneLength(min: 8, max: 8);
      case '+374': // Armenia
        return _PhoneLength(min: 8, max: 8);
      case '+375': // Bielorrusia
        return _PhoneLength(min: 9, max: 9);
      case '+376': // Andorra
        return _PhoneLength(min: 6, max: 6);
      case '+377': // Mónaco
        return _PhoneLength(min: 8, max: 8);
      case '+378': // San Marino
        return _PhoneLength(min: 10, max: 10);
      case '+379': // Ciudad del Vaticano
        return _PhoneLength(min: 10, max: 10);
      case '+380': // Ucrania
        return _PhoneLength(min: 9, max: 9);
      case '+381': // Serbia
        return _PhoneLength(min: 9, max: 9);
      case '+382': // Montenegro
        return _PhoneLength(min: 8, max: 8);
      case '+383': // Kosovo
        return _PhoneLength(min: 8, max: 8);
      case '+385': // Croacia
        return _PhoneLength(min: 9, max: 9);
      case '+386': // Eslovenia
        return _PhoneLength(min: 8, max: 8);
      case '+387': // Bosnia y Herzegovina
        return _PhoneLength(min: 8, max: 8);
      case '+389': // Macedonia del Norte
        return _PhoneLength(min: 8, max: 8);
      case '+420': // República Checa
        return _PhoneLength(min: 9, max: 9);
      case '+421': // Eslovaquia
        return _PhoneLength(min: 9, max: 9);
      case '+423': // Liechtenstein
        return _PhoneLength(min: 7, max: 7);
      case '+500': // Islas Malvinas
        return _PhoneLength(min: 5, max: 5);
      case '+501': // Belice
        return _PhoneLength(min: 7, max: 7);
      case '+502': // Guatemala
        return _PhoneLength(min: 8, max: 8);
      case '+503': // El Salvador
        return _PhoneLength(min: 8, max: 8);
      case '+504': // Honduras
        return _PhoneLength(min: 8, max: 8);
      case '+505': // Nicaragua
        return _PhoneLength(min: 8, max: 8);
      case '+506': // Costa Rica
        return _PhoneLength(min: 8, max: 8);
      case '+507': // Panamá
        return _PhoneLength(min: 8, max: 8);
      case '+508': // San Pedro y Miquelon
        return _PhoneLength(min: 6, max: 6);
      case '+509': // Haití
        return _PhoneLength(min: 8, max: 8);
      case '+590': // Guadalupe
        return _PhoneLength(min: 9, max: 9);
      case '+591': // Bolivia
        return _PhoneLength(min: 8, max: 8);
      case '+592': // Guyana
        return _PhoneLength(min: 7, max: 7);
      case '+593': // Ecuador
        return _PhoneLength(min: 9, max: 9);
      case '+594': // Guayana Francesa
        return _PhoneLength(min: 9, max: 9);
      case '+595': // Paraguay
        return _PhoneLength(min: 9, max: 9);
      case '+596': // Martinica
        return _PhoneLength(min: 9, max: 9);
      case '+597': // Surinam
        return _PhoneLength(min: 7, max: 7);
      case '+598': // Uruguay
        return _PhoneLength(min: 8, max: 8);
      case '+599': // Antillas Neerlandesas
        return _PhoneLength(min: 7, max: 7);
      case '+670': // Timor Oriental
        return _PhoneLength(min: 7, max: 7);
      case '+672': // Territorios Australianos
        return _PhoneLength(min: 6, max: 6);
      case '+673': // Brunéi
        return _PhoneLength(min: 7, max: 7);
      case '+674': // Nauru
        return _PhoneLength(min: 7, max: 7);
      case '+675': // Papúa Nueva Guinea
        return _PhoneLength(min: 8, max: 8);
      case '+676': // Tonga
        return _PhoneLength(min: 5, max: 5);
      case '+677': // Islas Salomón
        return _PhoneLength(min: 5, max: 5);
      case '+678': // Vanuatu
        return _PhoneLength(min: 5, max: 5);
      case '+679': // Fiyi
        return _PhoneLength(min: 7, max: 7);
      case '+680': // Palaos
        return _PhoneLength(min: 7, max: 7);
      case '+681': // Wallis y Futuna
        return _PhoneLength(min: 6, max: 6);
      case '+682': // Islas Cook
        return _PhoneLength(min: 5, max: 5);
      case '+683': // Niue
        return _PhoneLength(min: 4, max: 4);
      case '+685': // Samoa
        return _PhoneLength(min: 5, max: 5);
      case '+686': // Kiribati
        return _PhoneLength(min: 5, max: 5);
      case '+687': // Nueva Caledonia
        return _PhoneLength(min: 6, max: 6);
      case '+688': // Tuvalu
        return _PhoneLength(min: 5, max: 5);
      case '+689': // Polinesia Francesa
        return _PhoneLength(min: 6, max: 6);
      case '+690': // Tokelau
        return _PhoneLength(min: 4, max: 4);
      case '+691': // Micronesia
        return _PhoneLength(min: 7, max: 7);
      case '+692': // Islas Marshall
        return _PhoneLength(min: 7, max: 7);
      case '+850': // Corea del Norte
        return _PhoneLength(min: 8, max: 8);
      case '+852': // Hong Kong
        return _PhoneLength(min: 8, max: 8);
      case '+853': // Macao
        return _PhoneLength(min: 8, max: 8);
      case '+855': // Camboya
        return _PhoneLength(min: 9, max: 9);
      case '+856': // Laos
        return _PhoneLength(min: 9, max: 9);
      case '+880': // Bangladés
        return _PhoneLength(min: 10, max: 10);
      case '+886': // Taiwan
        return _PhoneLength(min: 9, max: 9);
      case '+960': // Maldivas
        return _PhoneLength(min: 7, max: 7);
      case '+961': // Líbano
        return _PhoneLength(min: 8, max: 8);
      case '+962': // Jordania
        return _PhoneLength(min: 9, max: 9);
      case '+963': // Siria
        return _PhoneLength(min: 9, max: 9);
      case '+964': // Irak
        return _PhoneLength(min: 10, max: 10);
      case '+965': // Kuwait
        return _PhoneLength(min: 8, max: 8);
      case '+966': // Arabia Saudita
        return _PhoneLength(min: 9, max: 9);
      case '+967': // Yemen
        return _PhoneLength(min: 9, max: 9);
      case '+968': // Omán
        return _PhoneLength(min: 8, max: 8);
      case '+970': // Palestina
        return _PhoneLength(min: 9, max: 9);
      case '+971': // Emiratos Árabes Unidos
        return _PhoneLength(min: 9, max: 9);
      case '+972': // Israel
        return _PhoneLength(min: 9, max: 9);
      case '+973': // Baréin
        return _PhoneLength(min: 8, max: 8);
      case '+974': // Catar
        return _PhoneLength(min: 8, max: 8);
      case '+975': // Bután
        return _PhoneLength(min: 8, max: 8);
      case '+976': // Mongolia
        return _PhoneLength(min: 8, max: 8);
      case '+977': // Nepal
        return _PhoneLength(min: 10, max: 10);
      case '+992': // Tayikistán
        return _PhoneLength(min: 9, max: 9);
      case '+993': // Turkmenistán
        return _PhoneLength(min: 8, max: 8);
      case '+994': // Azerbaiyán
        return _PhoneLength(min: 9, max: 9);
      case '+995': // Georgia
        return _PhoneLength(min: 9, max: 9);
      case '+996': // Kirguistán
        return _PhoneLength(min: 9, max: 9);
      case '+998': // Uzbekistán
        return _PhoneLength(min: 9, max: 9);
      default:
        return _PhoneLength(min: 7, max: 15); // Longitud genérica
    }
  }

  // 🔹 OBTENER NÚMERO COMPLETO FORMATEADO
  static String getCompletePhoneNumber(PhoneNumber phone) {
    final String cleanNumber = phone.number.replaceAll(RegExp(r'[^\d]'), '');
    return '${phone.countryCode}$cleanNumber';
  }

  // 🔹 OBTENER REGLAS DE UN PAÍS ESPECÍFICO
  static CountryPhoneRules? getCountryRules(String countryIsoCode) {
    return _countryRules[countryIsoCode];
  }

  // 🔹 VERIFICAR SI UN PAÍS REQUIERE VALIDACIÓN ESPECIAL
  static bool requiresSpecialValidation(String countryIsoCode) {
    return _countryRules.containsKey(countryIsoCode);
  }
}

// 🔹 MODELO MEJORADO PARA REGLAS DE TELÉFONO
class CountryPhoneRules {
  final String countryCode;
  final String name;
  final int minLength;
  final int maxLength;
  final List<String> validOperators;
  final bool requiresLeadingZero;
  final String description;
  final bool strictValidation;

  CountryPhoneRules({
    required this.countryCode,
    required this.name,
    required this.minLength,
    required this.maxLength,
    required this.validOperators,
    required this.requiresLeadingZero,
    required this.description,
    this.strictValidation = false,
  });

  @override
  String toString() {
    return '$name ($countryCode): $description';
  }
}

// 🔹 CLASE AUXILIAR PARA LONGITUD
class _PhoneLength {
  final int min;
  final int max;

  _PhoneLength({required this.min, required this.max});
}