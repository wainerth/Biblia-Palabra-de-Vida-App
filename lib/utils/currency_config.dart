class CurrencyConfig {
  final String symbol;
  final String code;
  final int maxIntegerDigits;
  final int decimalDigits;
  final double minAmount;
  final double maxAmount;

  const CurrencyConfig({
    required this.symbol,
    required this.code,
    required this.maxIntegerDigits,
    required this.decimalDigits,
    required this.minAmount,
    required this.maxAmount,
  });
}
