import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/screens/library/payment_methods_screen.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeliveryCoordinationScreen extends StatefulWidget {
  const DeliveryCoordinationScreen({super.key});

  @override
  State<DeliveryCoordinationScreen> createState() =>
      _DeliveryCoordinationScreenState();
}

class _DeliveryCoordinationScreenState
    extends State<DeliveryCoordinationScreen> {
  final NumberFormat _numberFormat = NumberFormat.decimalPattern();
  List<ModelData> _listCountries = [];
  List<ModelData> _listAreasCode = [];
  List<ModelData> _lisCities = [];
  // Lista de monedas soportadas con sus símbolos y configuraciones
  final List<CurrencyModel> _currencies = [
    CurrencyModel(
        id: "1",
        code: 'USD',
        symbol: '\$',
        name: 'Dólar Estadounidense',
        locale: 'en_US'),
    CurrencyModel(
        id: "2", code: 'EUR', symbol: '€', name: 'Euro', locale: 'de_DE'),
    CurrencyModel(
        id: "3",
        code: 'GBP',
        symbol: '£',
        name: 'Libra Esterlina',
        locale: 'en_GB'),
    CurrencyModel(
        id: "4",
        code: 'JPY',
        symbol: '¥',
        name: 'Yen Japonés',
        locale: 'ja_JP'),
    CurrencyModel(
        id: "5",
        code: 'BRL',
        symbol: 'R\$',
        name: 'Real Brasileño',
        locale: 'pt_BR'),
    CurrencyModel(
        id: "6",
        code: 'MXN',
        symbol: '\$',
        name: 'Peso Mexicano',
        locale: 'es_MX'),
    CurrencyModel(
        id: "7",
        code: 'PEN',
        symbol: 'S/',
        name: 'Sol Peruano',
        locale: 'es_PE'),
    CurrencyModel(
        id: "8",
        code: 'COP',
        symbol: '\$',
        name: 'Peso Colombiano',
        locale: 'es_CO'),
    CurrencyModel(
        id: "9",
        code: 'ARS',
        symbol: '\$',
        name: 'Peso Argentino',
        locale: 'es_AR'),
    CurrencyModel(
        id: "10",
        code: 'CLP',
        symbol: '\$',
        name: 'Peso Chileno',
        locale: 'es_CL'),
  ];
  List<ModelData> _lisCurrencies = [];
  ModelData? selectedCountry;
  ModelData? selectedAreaCode;
  ModelData? selectedCity;
  ModelData? selectedCurrency;
  String recipientName = '';
  String phoneNumber = '';
  int? _selectedOption = 0; // Inicialmente seleccionada la primera opción
  final TextEditingController _addressController = TextEditingController();
// Lista de opciones de entrega
  final List<DeliveryOption> _deliveryOptions = [
    DeliveryOption(
      id: "1",
      title: 'Librería el escudero de Dios',
      description:
          'Avenidas 18 de Julio 3564 entre ricos y Juan vidas zona Cordon',
      currency: "",
      price: '',
    ),
    DeliveryOption(
      id: "2",
      title: 'Retirar en la Iglesia Palabra de vida',
      description: 'Avenidas Teniente Rinaldi 2858, piedras blancas, CP 12300',
      currency: "",
      price: '',
    ),
    DeliveryOption(
      id: "3",
      title: 'Retirar en la Iglesia Cordon',
      description: 'Av. Rivera 2135, CP 11200',
      currency: "",
      price: '',
    ),
    DeliveryOption(
      id: "4",
      title: 'Entrega a domicilio',
      description: 'CP (12300)',
      currency: "",
      price: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        title: Text("Librería Cristiana"),
        titleTextStyle: StylesApp(context)
            .textStyleBody20
            .copyWith(color: StyleColor.white),
        backgroundColor: StyleColor.turquoise,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Subtítulo
            const Text(
              'Coordinación de entrega',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Información de ubicación y moneda
            GenericCoordinationWidget<ModelData>(
              countryDropdown: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: StyleColor.grayMedium,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CustomDropdownBottomWidget<ModelData>(
                  hintText: "Seleccione un país",
                  items: _listCountries,
                  onChanged: (newValue) async {
                    setState(() => selectedCountry = newValue);
                    await getAllCities(selectedCountry!.value);
                  },
                  selectedItem: selectedCountry,
                ),
              ),
              currencyDropdown: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: StyleColor.grayMedium,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CustomDropdownBottomWidget<ModelData>(
                  hintText: "Seleccione una moneda",
                  items: _lisCurrencies,
                  onChanged: (newValue) {
                    setState(() => selectedCurrency = newValue);
                    for (int i = 0; i < _deliveryOptions.length; i++) {
                      // Formatear según la moneda
                      final format = NumberFormat.currency(
                        locale: newValue!.originalData.locale,
                        symbol: newValue.originalData.symbol,
                        decimalDigits: 2,
                      );

                      setState(() {
                        _deliveryOptions[i] = _deliveryOptions[i].copyWith(
                            currency: newValue.label,
                            price: format.format(7)
                            );
                        print(_deliveryOptions[i].price);
                      });
                    }
                  },
                  selectedItem: selectedCurrency,
                ),
              ),
              showCity: true,
              phoneNumberLabel: "Numero re teléfono",
              cityDropdown: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: StyleColor.grayMedium,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CustomDropdownBottomWidget<ModelData>(
                  hintText: "Seleccione una ciudad",
                  items: _lisCities,
                  onChanged: (newValue) =>
                      setState(() => selectedCity = newValue),
                  selectedItem: selectedCity,
                ),
              ),
              showPhoneNumber: true,
              areaDropdown: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: StyleColor.grayMedium,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CustomDropdownBottomWidget<ModelData>(
                  hintText: "Código",
                  items: _listAreasCode,
                  onChanged: (newValue) =>
                      setState(() => selectedAreaCode = newValue),
                  selectedItem: selectedAreaCode,
                ),
              ),
              showRecipientName: true,
              recipientNameLabel: "Nombre de la persona a entregarle",
              showLabel: false,
              onRecipientNameChanged: (name) =>
                  setState(() => recipientName = name),
              onPhoneNumberChanged: (phone) =>
                  setState(() => phoneNumber = phone),
              padding: EdgeInsets.all(20),
              // Personalización opcional:
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Opciones de entrega con RadioButtons
            ..._buildDeliveryOptions(),
            // Campo de dirección (solo visible cuando está seleccionada entrega a domicilio)
            if (_selectedOption == 3) _buildAddressField(),

            const SizedBox(height: 30),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Botón de proceder al pago
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: ButtonThemeWidget(
                text: "Proceder al pago",
                buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                      backgroundColor:
                          WidgetStatePropertyAll(StyleColor.yellowLight),
                      textStyle: WidgetStatePropertyAll(StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: StyleColor.white)),
                    ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Nota
            const Text(
              'Nota: La entrega se hace entre 1 día y hasta un máximo de 14 días hábiles.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )),
    );
  }

  List<Widget> _buildDeliveryOptions() {
    return List.generate(_deliveryOptions.length, (index) {
      final option = _deliveryOptions[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: _selectedOption == index
                    ? Border.all(color: Colors.orange, width: 2)
                    : null,
              ),
              child: RadioListTile<int>(
                value: index,
                groupValue: _selectedOption,
                onChanged: (int? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
                activeColor: Colors.orange,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (option.price.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        option.price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: StyleColor.orange),
                child:
                    // option.price.isEmpty
                    // ? Text("${option.price} ${option.currency}")
                    // :
                    Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Gratis",
                    style: StylesApp(context).textStyleBody12,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dirección de entrega:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            hintText: 'Ingresa tu dirección completa',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Future<void> getAllCities(countryId) async {
    final responseState = await getStatesByCountry(countryId, null, null, null);
    if (responseState.error != null) {
      return;
    }
    setState(() {
      _lisCities = responseState.data
          .map<ModelData>(
              (state) => ModelData(label: state['name'], value: state['id']))
          .toList();
    });
  }

  Future<void> _initData() async {
    // cargamos países
    _listCountries = Provider.of<CatalogueProvider>(context, listen: false)
        .allCountries
        .map<ModelData>((country) => ModelData(
            label: country.name, value: country.id, originalData: country))
        .toList();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    LoginUser? currentUser = userProvider.currentUser;

    setState(() {
      selectedCountry = _listCountries.firstWhere(
        (x) => x.value == currentUser?.country!.id,
        orElse: () => ModelData(label: "", value: ""),
      );
    });

    if (selectedCountry!.value.isNotEmpty) {
      await getAllCities(selectedCountry!.value);
    }
    _listAreasCode = Provider.of<CatalogueProvider>(context, listen: false)
        .allAreasCode
        .map((area) => ModelData(label: area.code, value: area.id))
        .toList();

    _lisCurrencies = _currencies
        .map<ModelData>(
            (currency) => ModelData(label: currency.code, value: currency.id, originalData: currency))
        .toList();
  }
}
