import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest/USD';
  
  static Future<Map<String, dynamic>?> getExchangeRates() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener tasas de cambio: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en ExchangeRateService: $e');
      }
      return null;
    }
  }

  static double? getRateForCurrency(Map<String, dynamic>? ratesData, String currency) {
    if (ratesData == null) return null;
    
    final rates = ratesData['rates'];
    if (rates != null && rates is Map<String, dynamic>) {
      return rates[currency]?.toDouble();
    }
    return null;
  }
}