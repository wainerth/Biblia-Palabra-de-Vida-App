import 'package:biblia_palabra_de_vida_app/services/exchange_rate_service.dart';
import 'package:flutter/foundation.dart';

class ExchangeRateProvider with ChangeNotifier {
  Map<String, dynamic>? _ratesData;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get ratesData => _ratesData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchExchangeRates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _ratesData = await ExchangeRateService.getExchangeRates();
      if (_ratesData == null) {
        _error = 'No se pudieron obtener las tasas de cambio';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double? getRateForCurrency(String currency) {
    return ExchangeRateService.getRateForCurrency(_ratesData, currency);
  }

  double convertFromUSD(double usdAmount, String toCurrency) {
    final rate = getRateForCurrency(toCurrency);
    if (rate == null) return usdAmount; // Fallback a USD
    return usdAmount * rate;
  }

  double convertToUSD(double localAmount, String fromCurrency) {
    final rate = getRateForCurrency(fromCurrency);
    if (rate == null) return localAmount; // Fallback a USD
    return localAmount / rate;
  }
}