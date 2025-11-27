import 'package:biblia_palabra_de_vida_app/utils/currency_config.dart';
import 'package:biblia_palabra_de_vida_app/utils/currency_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/providers/exchange_rate_provider.dart';

class DonationAmountSelector extends StatefulWidget {
  final Function(double) onAmountSelected;
  final String? currency;
  final double initialAmount;

  const DonationAmountSelector({
    super.key,
    required this.onAmountSelected,
    this.currency,
    this.initialAmount = 0.0,
  });

  @override
  State<DonationAmountSelector> createState() => _DonationAmountSelectorState();
}

class _DonationAmountSelectorState extends State<DonationAmountSelector> {
  late double _selectedAmount;
  bool _showCustomInput = false;
  final TextEditingController _customAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedAmount = widget.initialAmount;
    // Cargar tasas de cambio si no están cargadas
    _loadExchangeRatesIfNeeded();
  }

  void _loadExchangeRatesIfNeeded() {
    final exchangeProvider =
        Provider.of<ExchangeRateProvider>(context, listen: false);
    if (exchangeProvider.ratesData == null) {
      exchangeProvider.fetchExchangeRates();
    }
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  bool get _isEnabled => widget.currency != null;

  String _getCurrencySymbol() {
    if (widget.currency == null) return '\$';

    switch (widget.currency!) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'BS':
        return 'Bs. ';
      default:
        return '\$';
    }
  }

  double _convertFromUSD(double usdAmount) {
    if (widget.currency == null) return usdAmount;
    final exchangeProvider =
        Provider.of<ExchangeRateProvider>(context, listen: false);
    return exchangeProvider.convertFromUSD(usdAmount, widget.currency!);
  }

  double _convertToUSD(double localAmount) {
    if (widget.currency == null) return localAmount;
    final exchangeProvider =
        Provider.of<ExchangeRateProvider>(context, listen: false);
    return exchangeProvider.convertToUSD(localAmount, widget.currency!);
  }

  double get _minimumAmountInLocalCurrency {
    return _convertFromUSD(1.0); // Mínimo 1 USD equivalente
  }

  String _getEquivalentInfo(double usdAmount) {
    if (widget.currency == null || widget.currency == 'USD') return '';

    final localAmount = _convertFromUSD(usdAmount);
    final symbol = _getCurrencySymbol();
    return ' (~$symbol${localAmount.toStringAsFixed(2)})';
  }

  void _handleAmountSelection(double usdAmount) {
    final localAmount = _convertFromUSD(usdAmount);
    setState(() {
      _selectedAmount = localAmount;
      _showCustomInput = false;
      _customAmountController.clear();
    });
    widget.onAmountSelected(usdAmount);
  }

  void _handleCustomAmount() {
    setState(() {
      _showCustomInput = true;
      _selectedAmount = 0.0;
    });
  }

  void _handleCustomAmountInput(String value, CurrencyConfig config) {
    if (value.isEmpty) {
      // Resetear a valores por defecto si está vacío
      _resetToDefaultValue(config);
      return;
    }

    // Validar formato según la moneda
    if (!_isValidFormat(value, config)) {
      _forceCorrectFormat(value, config);
      return;
    }

    // Convertir a número y validar límites
    double? amount = _parseAmount(value, config);
    if (amount != null) {
      _validateAmountLimits(amount, config);
    }

    final localAmount = double.tryParse(value) ?? 0.0;
    final usdAmount = _convertToUSD(localAmount);

    if (usdAmount >= 1.0) {
      setState(() {
        _selectedAmount = localAmount;
      });
      widget.onAmountSelected(_selectedAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exchangeProvider = Provider.of<ExchangeRateProvider>(context);
    final symbol = _getCurrencySymbol();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.currency != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Moneda: ${widget.currency!}',
                        style: StylesApp(context).textStyleBody12.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Estado de carga/error
          if (exchangeProvider.isLoading) _buildLoadingState(),

          if (exchangeProvider.error != null && widget.currency != null)
            _buildErrorState(exchangeProvider.error!),

          if (!exchangeProvider.isLoading && exchangeProvider.error == null)
            _buildContent(symbol, exchangeProvider),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando tasas de cambio...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.orange, size: 40),
          const SizedBox(height: 12),
          Text(
            'Error al cargar tasas',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Usando tasa por defecto',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String symbol, ExchangeRateProvider exchangeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monto a donar:',
          style: StylesApp(context).textStyleBody16.copyWith(
                color: StyleColor.white,
              ),
        ),

        const SizedBox(height: 20),

        // Montos fijos en USD con equivalentes
        Row(
          spacing: 4.0,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _buildAmountChip(10.0, symbol)),
            Expanded(child: _buildAmountChip(25.0, symbol)),
            Expanded(child: _buildAmountChip(50.0, symbol)),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 4.0,
          children: [
            Expanded(child: _buildAmountChip(100.0, symbol)),
            Expanded(child: _buildCustomAmountChip(symbol)),
          ],
        ),

        // Input personalizado
        if (_showCustomInput) _buildCustomAmountInput(symbol, widget.currency!),

        // Información de monto mínimo
        _buildMinimumAmountInfo(symbol),

        // Monto seleccionado
        if (_selectedAmount >= _minimumAmountInLocalCurrency)
          _buildSelectedAmountInfo(symbol),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAmountChip(double usdAmount, String symbol) {
    final localAmount = _convertFromUSD(usdAmount);
    final isSelected = _selectedAmount == localAmount && !_showCustomInput;
    final equivalentInfo = _getEquivalentInfo(usdAmount);

    return GestureDetector(
      onTap: _isEnabled ? () => _handleAmountSelection(usdAmount) : null,
      child: Opacity(
        opacity: _isEnabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          constraints: BoxConstraints(minWidth: 60),
          decoration: BoxDecoration(
            color: isSelected ? StyleColor.orange : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? StyleColor.orange : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$symbol${localAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: isSelected ? Colors.white : StyleColor.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (equivalentInfo.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  equivalentInfo,
                  style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAmountChip(String symbol) {
    final isSelected = _showCustomInput;

    return GestureDetector(
      onTap: _isEnabled ? _handleCustomAmount : null,
      child: Opacity(
        opacity: _isEnabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? StyleColor.orange : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? StyleColor.orange : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Text(
            'Otro',
            style: TextStyle(
              color: isSelected ? Colors.white : StyleColor.orange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAmountInput(String symbol, String currencyCode) {
    final CurrencyConfig config = CurrencyManager.getConfig(currencyCode);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingresa el monto:',
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _customAmountController,
            enabled: _isEnabled,
            keyboardType: TextInputType.numberWithOptions(
                decimal: config.decimalDigits > 0),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(
                  config.maxIntegerDigits + config.decimalDigits),
              _CurrencyInputFormatter(config: config),
            ],
            decoration: InputDecoration(
              hintText: _getHintText(config),
              prefixText: '$symbol ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              // Advertencia especial para VES
              suffixIcon: currencyCode == 'VES'
                  ? Tooltip(
                      message: 'Valores sujetos a alta volatilidad',
                      child: Icon(Icons.warning_amber, color: Colors.orange),
                    )
                  : null,
            ),
            onChanged: (value) => _handleCustomAmountInput(value, config),
          ),
          // Información específica para VES
          if (currencyCode == 'VES')
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '💡 Montos en Bolívares pueden variar rápidamente',
                style: StylesApp(context).textStyleBody12.copyWith(
                      color: Colors.orange[700],
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMinimumAmountInfo(String symbol) {
    final minUSD = _convertToUSD(_minimumAmountInLocalCurrency);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        'Mínimo equivalente a \$${minUSD.toStringAsFixed(2)} USD ($symbol${_minimumAmountInLocalCurrency.toStringAsFixed(2)})',
        style: StylesApp(context).textStyleBody12.copyWith(
              color: StyleColor.grayDark,
              fontStyle: FontStyle.italic,
            ),
      ),
    );
  }

  Widget _buildSelectedAmountInfo(String symbol) {
    final amountInUSD = _convertToUSD(_selectedAmount);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Monto seleccionado:',
                      style: StylesApp(context).textStyleBody12.copyWith(
                          fontWeight: FontWeight.w600,
                          color: StyleColor.grayDark),
                    ),
                    Text(
                      '$symbol${_selectedAmount.toStringAsFixed(2)}',
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Equivale a \$${amountInUSD.toStringAsFixed(2)} USD',
                      style: StylesApp(context).textStyleBody12.copyWith(
                            color: Colors.green[700],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Función para obtener el hint text dinámico según la moneda
  String _getHintText(CurrencyConfig config) {
    if (config.decimalDigits == 0) {
      return 'Ej: 1000'; // Monedas sin decimales como JPY
    } else if (config.decimalDigits == 2) {
      return 'Ej: 75.50'; // Monedas con 2 decimales como EUR, USD
    } else if (config.decimalDigits == 3) {
      return 'Ej: 25.500'; // Monedas con 3 decimales como BHD
    } else {
      return 'Ingrese monto';
    }
  }

// Función auxiliar para resetear a valor por defecto
  void _resetToDefaultValue(CurrencyConfig config) {
    if (config.decimalDigits == 0) {
      _customAmountController.text = '0';
    } else {
      String zeros = '0' * config.decimalDigits;
      _customAmountController.text = '0.$zeros';
    }
    _customAmountController.selection =
        TextSelection.collapsed(offset: _customAmountController.text.length);
  }

// Validar formato según configuración de moneda
  bool _isValidFormat(String value, CurrencyConfig config) {
    if (config.decimalDigits == 0) {
      // Solo números enteros
      return RegExp(r'^\d+$').hasMatch(value);
    } else {
      // Números con decimales específicos
      String pattern = r'^\d+\.\d{' + config.decimalDigits.toString() + r'}$';
      return RegExp(pattern).hasMatch(value);
    }
  }

// Forzar formato correcto si el usuario ingresa mal
  void _forceCorrectFormat(String value, CurrencyConfig config) {
    String cleanText = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanText.isEmpty) {
      _resetToDefaultValue(config);
      return;
    }

    // Limitar a máximo de dígitos permitidos
    if (cleanText.length > config.maxIntegerDigits + config.decimalDigits) {
      cleanText = cleanText.substring(
          0, config.maxIntegerDigits + config.decimalDigits);
    }

    if (config.decimalDigits == 0) {
      // Monedas sin decimales
      _customAmountController.text = cleanText;
    } else {
      // Monedas con decimales
      cleanText = cleanText.padLeft(config.decimalDigits, '0');
      String integerPart =
          cleanText.substring(0, cleanText.length - config.decimalDigits);
      String decimalPart =
          cleanText.substring(cleanText.length - config.decimalDigits);

      if (integerPart.isEmpty) integerPart = '0';

      _customAmountController.text = '$integerPart.$decimalPart';
    }

    _customAmountController.selection =
        TextSelection.collapsed(offset: _customAmountController.text.length);
  }

// Parsear amount según configuración
  double? _parseAmount(String value, CurrencyConfig config) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }

// Validar límites mínimo y máximo
  void _validateAmountLimits(double amount, CurrencyConfig config) {
    if (amount < config.minAmount) {
      // Puedes mostrar un error o ajustar automáticamente
      _showAmountError('Monto mínimo: ${config.symbol}${config.minAmount}');
    } else if (amount > config.maxAmount) {
      _showAmountError('Monto máximo: ${config.symbol}${config.maxAmount}');
    } else {
      _clearAmountError();
      // Aquí puedes procesar el monto válido
      _processValidAmount(amount);
    }
  }

// Mostrar error de monto
  void _showAmountError(String message) {
    // Depende de cómo manejes los errores en tu app
    // Puedes usar un SnackBar, cambiar el color del border, etc.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _clearAmountError() {
    // Limpiar cualquier error visual
  }

  void _processValidAmount(double amount) {
    // Tu lógica para procesar el monto válido
    print('Monto válido: $amount');
  }

  void _yourOriginalLogic(String value) {
    // Aquí va cualquier lógica adicional que ya tuvieras en tu _handleCustomAmountInput original
  }
}

// Formateado actualizado para ser dinámico
class _CurrencyInputFormatter extends TextInputFormatter {
  final CurrencyConfig config;

  _CurrencyInputFormatter({required this.config});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Filtrar solo dígitos
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Si está vacío, mostrar formato inicial según decimales
    if (cleanText.isEmpty) {
      return _getInitialValue();
    }

    // Limitar dígitos máximo según configuración de moneda
    int maxDigits = config.maxIntegerDigits + config.decimalDigits;
    if (cleanText.length > maxDigits) {
      cleanText = cleanText.substring(0, maxDigits);
    }

    // Comportamiento diferente según si tiene decimales o no
    if (config.decimalDigits == 0) {
      // Moneda sin decimales (JPY, KRW, etc.)
      return _formatWithoutDecimals(cleanText);
    } else {
      // Moneda con decimales
      return _formatWithDecimals(cleanText);
    }
  }

  TextEditingValue _getInitialValue() {
    if (config.decimalDigits == 0) {
      return TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(offset: 1),
      );
    } else {
      String decimalZeros = '0' * config.decimalDigits;
      return TextEditingValue(
        text: '0.$decimalZeros',
        selection: TextSelection.collapsed(offset: config.decimalDigits + 2),
      );
    }
  }

  TextEditingValue _formatWithoutDecimals(String cleanText) {
    int value = int.parse(cleanText);
    return TextEditingValue(
      text: value.toString(),
      selection: TextSelection.collapsed(offset: cleanText.length),
    );
  }

  TextEditingValue _formatWithDecimals(String cleanText) {
    // Completar con ceros a la izquierda para tener siempre los decimales completos
    cleanText = cleanText.padLeft(config.decimalDigits, '0');

    // Separar en parte entera y decimal
    String integerPart =
        cleanText.substring(0, cleanText.length - config.decimalDigits);
    String decimalPart =
        cleanText.substring(cleanText.length - config.decimalDigits);

    // Manejar caso cuando no hay suficientes dígitos para parte entera
    if (integerPart.isEmpty) {
      integerPart = '0';
    } else {
      int integerValue = int.parse(integerPart);
      integerPart = integerValue.toString();
    }

    String formattedText = '$integerPart.$decimalPart';

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class VenezuelanCurrencyHelper {
  static Future<CurrencyConfig> getUpdatedVESConfig() async {
    // En una app real, podrías consultar una API para valores actualizados
    // debido a la alta inflación en Venezuela

    return CurrencyConfig(
      symbol: 'Bs.D',
      code: 'VES',
      maxIntegerDigits: 12,
      decimalDigits: 2,
      minAmount: await _getCurrentMinAmount(),
      maxAmount: await _getCurrentMaxAmount(),
    );
  }

  static Future<double> _getCurrentMinAmount() async {
    // Consultar API o servicio para obtener mínimo actual
    // Por ahora retornamos un valor por defecto
    return 10000.00;
  }

  static Future<double> _getCurrentMaxAmount() async {
    // Consultar API o servicio para obtener máximo actual
    return 10000000000.00;
  }
}
