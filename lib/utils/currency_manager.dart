import 'package:biblia_palabra_de_vida_app/utils/currency_config.dart';

class CurrencyManager {
  static final Map<String, CurrencyConfig> currencies = {
    // Monedas con 2 decimales (las más comunes)
    'USD': CurrencyConfig(
        symbol: '\$',
        code: 'USD',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.01,
        maxAmount: 100000.00),
    'EUR': CurrencyConfig(
        symbol: '€',
        code: 'EUR',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.01,
        maxAmount: 100000.00),
    'GBP': CurrencyConfig(
        symbol: '£',
        code: 'GBP',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.01,
        maxAmount: 100000.00),
    'CAD': CurrencyConfig(
        symbol: '\$',
        code: 'CAD',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.01,
        maxAmount: 100000.00),
    'AUD': CurrencyConfig(
        symbol: '\$',
        code: 'AUD',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.01,
        maxAmount: 100000.00),
    'NZD': CurrencyConfig(
        symbol: '\$',
        code: 'NZD',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.01,
        maxAmount: 100000.00),
    'CHF': CurrencyConfig(
        symbol: 'CHF',
        code: 'CHF',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.01,
        maxAmount: 100000.00),
    'MXN': CurrencyConfig(
        symbol: '\$',
        code: 'MXN',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.10,
        maxAmount: 100000.00),
    'BRL': CurrencyConfig(
        symbol: 'R\$',
        code: 'BRL',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.10,
        maxAmount: 100000.00),
    'ARS': CurrencyConfig(
        symbol: '\$',
        code: 'ARS',
        maxIntegerDigits: 8,
        decimalDigits: 2,
        minAmount: 10.00,
        maxAmount: 10000000.00),

    // Monedas sin decimales
    'JPY': CurrencyConfig(
        symbol: '¥',
        code: 'JPY',
        maxIntegerDigits: 8,
        decimalDigits: 0,
        minAmount: 100,
        maxAmount: 10000000),
    'KRW': CurrencyConfig(
        symbol: '₩',
        code: 'KRW',
        maxIntegerDigits: 8,
        decimalDigits: 0,
        minAmount: 1000,
        maxAmount: 100000000),
    'VND': CurrencyConfig(
        symbol: '₫',
        code: 'VND',
        maxIntegerDigits: 9,
        decimalDigits: 0,
        minAmount: 10000,
        maxAmount: 1000000000),
    'IDR': CurrencyConfig(
        symbol: 'Rp',
        code: 'IDR',
        maxIntegerDigits: 9,
        decimalDigits: 0,
        minAmount: 10000,
        maxAmount: 1000000000),
    'CLP': CurrencyConfig(
        symbol: '\$',
        code: 'CLP',
        maxIntegerDigits: 8,
        decimalDigits: 0,
        minAmount: 1000,
        maxAmount: 100000000),

    // Monedas con 3 decimales
    'BHD': CurrencyConfig(
        symbol: 'BD',
        code: 'BHD',
        maxIntegerDigits: 5,
        decimalDigits: 3,
        minAmount: 0.100,
        maxAmount: 10000.000),
    'JOD': CurrencyConfig(
        symbol: 'JD',
        code: 'JOD',
        maxIntegerDigits: 5,
        decimalDigits: 3,
        minAmount: 0.100,
        maxAmount: 10000.000),
    'KWD': CurrencyConfig(
        symbol: 'KD',
        code: 'KWD',
        maxIntegerDigits: 5,
        decimalDigits: 3,
        minAmount: 0.100,
        maxAmount: 10000.000),
    'OMR': CurrencyConfig(
        symbol: 'OMR',
        code: 'OMR',
        maxIntegerDigits: 5,
        decimalDigits: 3,
        minAmount: 0.100,
        maxAmount: 10000.000),
    'TND': CurrencyConfig(
        symbol: 'DT',
        code: 'TND',
        maxIntegerDigits: 5,
        decimalDigits: 3,
        minAmount: 0.100,
        maxAmount: 10000.000),

    // Monedas con 0-3 decimales (especiales)
    'CZK': CurrencyConfig(
        symbol: 'Kč',
        code: 'CZK',
        maxIntegerDigits: 7,
        decimalDigits: 2,
        minAmount: 1.00,
        maxAmount: 1000000.00),
    'HUF': CurrencyConfig(
        symbol: 'Ft',
        code: 'HUF',
        maxIntegerDigits: 8,
        decimalDigits: 0,
        minAmount: 100,
        maxAmount: 100000000),
    'ISK': CurrencyConfig(
        symbol: 'kr',
        code: 'ISK',
        maxIntegerDigits: 8,
        decimalDigits: 0,
        minAmount: 100,
        maxAmount: 100000000),

    // BOLÍVAR VENEZOLANO - Caso especial por hiperinflación
    // Hasta 9,999,999,999 (necesario por inflación)
    'VES': CurrencyConfig(
      symbol: 'Bs',
      code: 'VES',
      maxIntegerDigits: 10,
      decimalDigits: 2,
      minAmount: 1000.00,
      maxAmount: 1000000000.00,
    ),
    // Bolívar Soberano (anterior) - por si acaso
    'VEF': CurrencyConfig(
      symbol: 'Bs.S',
      code: 'VEF',
      maxIntegerDigits: 10,
      decimalDigits: 2,
      minAmount: 1000.00,
      maxAmount: 1000000000.00,
    ),
    // Más monedas latinoamericanas
    'COP': CurrencyConfig(
        symbol: '\$',
        code: 'COP',
        maxIntegerDigits: 8,
        decimalDigits: 2,
        minAmount: 100.00,
        maxAmount: 100000000.00),
    'PEN': CurrencyConfig(
        symbol: 'S/',
        code: 'PEN',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 1.00,
        maxAmount: 100000.00),
    'UYU': CurrencyConfig(
        symbol: '\$',
        code: 'UYU',
        maxIntegerDigits: 7,
        decimalDigits: 2,
        minAmount: 10.00,
        maxAmount: 1000000.00),
    'BOB': CurrencyConfig(
        symbol: 'Bs',
        code: 'BOB',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 1.00,
        maxAmount: 100000.00),
    'PYG': CurrencyConfig(
        symbol: '₲',
        code: 'PYG',
        maxIntegerDigits: 9,
        decimalDigits: 0,
        minAmount: 10000,
        maxAmount: 1000000000),
    'DOP': CurrencyConfig(
        symbol: '\$',
        code: 'DOP',
        maxIntegerDigits: 7,
        decimalDigits: 2,
        minAmount: 10.00,
        maxAmount: 1000000.00),
    'GTQ': CurrencyConfig(
        symbol: 'Q',
        code: 'GTQ',
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 1.00,
        maxAmount: 100000.00),
    'CRC': CurrencyConfig(
        symbol: '₡',
        code: 'CRC',
        maxIntegerDigits: 8,
        decimalDigits: 2,
        minAmount: 100.00,
        maxAmount: 10000000.00),
    'NIO': CurrencyConfig(
        symbol: 'C\$',
        code: 'NIO',
        maxIntegerDigits: 7,
        decimalDigits: 2,
        minAmount: 10.00,
        maxAmount: 1000000.00),
    'HNL': CurrencyConfig(
        symbol: 'L',
        code: 'HNL',
        maxIntegerDigits: 7,
        decimalDigits: 2,
        minAmount: 10.00,
        maxAmount: 1000000.00),
    'SVC': CurrencyConfig(
        symbol: '\$',
        code: 'SVC',
        maxIntegerDigits: 7,
        decimalDigits: 2,
        minAmount: 1.00,
        maxAmount: 1000000.00),
  };

  static CurrencyConfig getConfig(String currencyCode) {
    return currencies[currencyCode] ?? _getDefaultConfig(currencyCode);
  }

  static CurrencyConfig _getDefaultConfig(String currencyCode) {
    // Detectar monedas latinoamericanas específicas
    if (_isHighInflationCurrency(currencyCode)) {
      return CurrencyConfig(
        symbol: currencyCode,
        code: currencyCode,
        maxIntegerDigits: 10, // Más dígitos por inflación
        decimalDigits: 2,
        minAmount: 1000.00,
        maxAmount: 1000000000.00,
      );
    } else if (_isLatinAmericanCurrency(currencyCode)) {
      return CurrencyConfig(
        symbol: currencyCode,
        code: currencyCode,
        maxIntegerDigits: 8,
        decimalDigits: 2,
        minAmount: 10.00,
        maxAmount: 10000000.00,
      );
    } else if (_isCurrencyWithoutDecimals(currencyCode)) {
      return CurrencyConfig(
        symbol: currencyCode,
        code: currencyCode,
        maxIntegerDigits: 8,
        decimalDigits: 0,
        minAmount: 100,
        maxAmount: 10000000,
      );
    } else if (_isCurrencyWithThreeDecimals(currencyCode)) {
      return CurrencyConfig(
        symbol: currencyCode,
        code: currencyCode,
        maxIntegerDigits: 5,
        decimalDigits: 3,
        minAmount: 0.100,
        maxAmount: 10000.000,
      );
    } else {
      // Por defecto: 2 decimales
      return CurrencyConfig(
        symbol: currencyCode,
        code: currencyCode,
        maxIntegerDigits: 6,
        decimalDigits: 2,
        minAmount: 0.01,
        maxAmount: 100000.00,
      );
    }
  }

  static bool _isHighInflationCurrency(String code) {
    final highInflation = ['VES', 'VEF', 'ARS', 'ZWL'];
    return highInflation.contains(code);
  }

  static bool _isLatinAmericanCurrency(String code) {
    final latamCurrencies = [
      'MXN',
      'BRL',
      'COP',
      'PEN',
      'UYU',
      'BOB',
      'PYG',
      'DOP',
      'GTQ',
      'CRC',
      'NIO',
      'HNL',
      'SVC',
      'PAB',
      'TTD',
      'JMD'
    ];
    return latamCurrencies.contains(code);
  }

  static bool _isCurrencyWithoutDecimals(String code) {
    final noDecimalCurrencies = [
      'JPY',
      'KRW',
      'VND',
      'IDR',
      'CLP',
      'HUF',
      'ISK',
      'PYG'
    ];
    return noDecimalCurrencies.contains(code);
  }

  static bool _isCurrencyWithThreeDecimals(String code) {
    final threeDecimalCurrencies = ['BHD', 'JOD', 'KWD', 'OMR', 'TND'];
    return threeDecimalCurrencies.contains(code);
  }
}
