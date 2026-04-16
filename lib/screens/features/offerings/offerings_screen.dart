import 'package:biblia_palabra_de_vida_app/main.dart';
import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/screens/features/offerings/stripe_payment_screen.dart';
import 'package:biblia_palabra_de_vida_app/services/phone_validator_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/transfer_form.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferingsScreen extends StatefulWidget {
  const OfferingsScreen({super.key});

  @override
  State<OfferingsScreen> createState() => _OfferingsScreenState();
}

class _OfferingsScreenState extends State<OfferingsScreen> {
  String? _selectedCurrency;
  double? _selectedAmount = 0.0;
  bool _isEnabled = false;
  // Key para DonationAmountSelector
  UniqueKey _donationSelectorKey = UniqueKey();

  final List<ModelData> _currencies = [
    ModelData(label: 'USD - Dólar Americano', value: 'USD'),
    ModelData(label: 'EUR - Euro', value: 'EUR'),
    ModelData(label: 'BS - Bolívar', value: 'BS'),
  ];

  // Reemplaza con tu Payment Link real de Stripe
  final String stripePaymentLink = "https://buy.stripe.com/test_xxxxxxxxxxxx";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    _isEnabled = _selectedCurrency != null &&
        _selectedAmount != null &&
        _selectedAmount! > 0;
    return Scaffold(
      backgroundColor: const Color(0xFF12CBC4),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
            foregroundColor: WidgetStatePropertyAll(StyleColor.white),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          onPressed: () => Navigator.pushNamed(context, "/layoutPage"),
          icon: const Icon(Icons.arrow_back, size: 30),
        ),
        backgroundColor: StyleColor.white,
        title: Text(
          'Ofrendas y Donaciones',
          style: StylesApp(context).textStyleBody20.copyWith(
                color: StyleColor.orange,
                fontFamily: 'LuckiestGuy',
                fontSize: 20,
              ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    // Header Section
                    _buildHeader(context),

                    // Message Section
                    _buildMessageSection(context),

                    // Currency Selection
                    _buildCurrencySection(context),

                    DonationAmountSelector(
                      key: _donationSelectorKey,
                      currency: _selectedCurrency,
                      onAmountSelected: (value) {
                        setState(() {
                          _selectedAmount = value;
                          _isEnabled = _selectedCurrency != null && value > 0;
                        });
                      },
                    ),
                    _buildPaymentMethods(context, currentUser),
                  ],
                ),
              ),
            ),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/elipsisTop.png"),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.volunteer_activism,
              size: 50,
              color: StyleColor.orange,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Apoya Nuestra Misión',
            style: StylesApp(context).textStyleBody24.copyWith(
                  color: const Color(0xFFFF914D),
                  fontFamily: 'LuckiestGuy',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMessageSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            'Tu generosidad nos ayuda a continuar compartiendo la Palabra de Dios',
            textAlign: TextAlign.center,
            style: StylesApp(context).textStyleBody16.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white, thickness: 1),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCurrencySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona la moneda:',
            style: StylesApp(context).textStyleBody16.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          // Dropdown de monedas
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: StyleColor.orange, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.currency_exchange, color: StyleColor.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDropdownBottomWidget(
                      border: false,
                      hintText: "Moneda ",
                      items: _currencies,
                      onChanged: (ModelData? newValue) async {
                        setState(() {
                          _selectedCurrency = newValue?.value;
                          _selectedAmount =
                              null; // Reset monto al cambiar moneda
                          _donationSelectorKey = UniqueKey();
                        });
                      },
                      selectedItem: _currencies.firstWhere(
                        (element) => element.value == _selectedCurrency,
                        orElse: () =>
                            ModelData(label: 'Selecciona moneda', value: ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(BuildContext context, dynamic currentUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Método de pago:',
            style: StylesApp(context).textStyleBody16.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          // Stripe - Tarjetas de crédito/débito
          _buildPaymentOption(
            isEnabled: _isEnabled,
            currency: _selectedCurrency,
            amount: _selectedAmount,
            icon: Icons.credit_card,
            title: 'Tarjeta de crédito/débito',
            subtitle: 'Pago seguro con Stripe',
            context: context,
            onTap: () => _processStripePayment(context, currentUser),
          ),

          // Payment Link de Stripe
          _buildPaymentOption(
            isEnabled: _isEnabled,
            currency: _selectedCurrency,
            amount: _selectedAmount,
            icon: Icons.link,
            title: 'Múltiples Métodos de Pago',
            subtitle: 'PayPal, Google Pay, Apple Pay',
            context: context,
            onTap: () => _launchStripePaymentLink(
                _selectedCurrency, _selectedAmount, currentUser),
          ),

          // Transferencia bancaria
          _buildPaymentOption(
            isEnabled: _isEnabled,
            currency: _selectedCurrency,
            amount: _selectedAmount,
            icon: Icons.account_balance,
            title: 'Transferencia bancaria',
            subtitle: 'Transferencia manual',
            context: context,
            onTap: () => _showBankTransferOptions(context),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String? currency,
    required double? amount,
    required IconData icon,
    required String title,
    required String subtitle,
    required BuildContext context,
    isEnabled = true,
    Function()? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isEnabled ? Colors.white : StyleColor.grayMedium.withAlpha(20),
      child: ListTile(
        leading: Icon(icon, color: StyleColor.orange, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Montserrat',
            fontSize: 12,
          ),
        ),
        enabled: isEnabled,
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: isEnabled ? onTap : null,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        '© 2025 Biblia Palabra de Vida',
        style: StylesApp(context).textStyleBody10.copyWith(
              color: Colors.white70,
              fontSize: 13,
              fontFamily: 'Montserrat',
            ),
      ),
    );
  }

  // === MÉTODOS DE PAGO ACTUALIZADOS ===

  void _processStripePayment(BuildContext context, dynamic currentUser) {
    _showDonorInfoForm(
        context, currentUser, _selectedCurrency, _selectedAmount);
  }

  // void _processStripePaymentLink(BuildContext context, dynamic currentUser) {
  //   _showDonationAmountSelector(
  //     context: context,
  //     onAmountSelected: (amount) {
  //       _launchStripePaymentLink(amount, currentUser);
  //     },
  //   );
// void _showDonationAmountSelector({
//   required BuildContext context,
//   required Function(double) onAmountSelected,
// }) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return Padding(
//         padding: const EdgeInsets.all(20),
//         child: DonationAmountSelector(
//           currency: _selectedCurrency!,
//           initialAmount: 25.0,
//           onCancel: () => Navigator.pop(context),
//           onAmountSelected: (amount) {
//             Navigator.pop(context); // Cerrar el bottom sheet
//             onAmountSelected(amount);
//           },
//         ),
//       );
//     },
//   );
// }

  void _showDonorInfoForm(BuildContext context, dynamic currentUser,
      String? currency, double? amount) {
    final donorNameController = TextEditingController(
        text: "${currentUser?.name ?? ''} ${currentUser.lastname ?? ''}");
    final donorEmailController =
        TextEditingController(text: currentUser?.email ?? '');
    final donorPhoneController =
        TextEditingController(text: currentUser?.phoneNumber ?? '');
    String initialPhoneCode = currentUser?.profileAreaCode != null
        ? currentUser?.profileAreaCode.code
        : "UY";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // ← Esto es clave
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              // ← Usar SingleChildScrollView
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Información del Donante',
                        style: StylesApp(context).textStyleBody18.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Por favor ingresa los datos del titular de la tarjeta:',
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),

                  const SizedBox(height: 20),

                  // Formulario de datos del donante
                  TextFormField(
                    controller: donorNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Titular*',
                      hintText: 'Como aparece en la tarjeta',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: donorEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email*',
                      hintText: 'email@ejemplo.com',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      if (!value.contains('@')) {
                        return 'Ingresa un email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  IntlPhoneFieldWithValidation(
                    controller: donorPhoneController,
                    initialPhoneCode: initialPhoneCode,
                    validator: (PhoneNumber? phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return 'El número de teléfono es obligatorio';
                      }
                      return PhoneValidatorService.validatePhoneNumber(phone);
                    },
                    onChanged: (phone) {
                      if (kDebugMode) {
                        print('Country Code: ${phone.countryCode}');
                        print('Complete Number: ${phone.completeNumber}');
                        print('Country ISO: ${phone.countryISOCode}');
                        print('Raw Number: ${phone.number}');

                        final rules = PhoneValidatorService.getCountryRules(
                            phone.countryISOCode);
                        if (rules != null) {
                          print(
                              'Country Rules: ${rules.name} - Min: ${rules.minLength}, Max: ${rules.maxLength}');
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: StyleColor.orange),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: StyleColor.orange),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (donorNameController.text.isNotEmpty &&
                                donorEmailController.text.isNotEmpty &&
                                donorEmailController.text.contains('@')) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StripePaymentScreen(
                                    amount: amount!,
                                    description:
                                        'Donación - Biblia Palabra de Vida',
                                    donorName: donorNameController.text,
                                    donorEmail: donorEmailController.text,
                                    donorPhone:
                                        donorPhoneController.text.isEmpty
                                            ? null
                                            : donorPhoneController.text,
                                    currency: _selectedCurrency!,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: StyleColor.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Continuar al Pago',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Espacio extra para el teclado
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _launchStripePaymentLink(
      String? currency, double? amount, dynamic currentUser) async {
    try {
      final uri = Uri.parse(stripePaymentLink).replace(
        queryParameters: {
          'prefilled_email': currentUser?.email ?? '',
          'client_reference_id': 'user_${currentUser?.id ?? 'guest'}',
        },
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorDialog('No se pudo abrir el enlace de pago');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

// Mantener tus métodos existentes para transferencias bancarias
  void _showBankTransferOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: StyleColor.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selecciona un Banco',
                  style: StylesApp(context).textStyleBody20.copyWith(
                        color: StyleColor.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showTransferForm(context),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: StyleColor.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Banco de Venezuela",
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        color: StyleColor.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Cuenta de Ahorro",
                              style: StylesApp(context)
                                  .textStyleBody14
                                  .copyWith(color: Colors.grey[700]),
                            ),
                            Text(
                              "V-1876273",
                              style: StylesApp(context)
                                  .textStyleBody14
                                  .copyWith(color: Colors.grey[700]),
                            ),
                            Text(
                              "01020380550000006417",
                              style: StylesApp(context)
                                  .textStyleBody14
                                  .copyWith(color: Colors.grey[700]),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTransferForm(BuildContext context) {
    Navigator.pop(context); // Cierra el modal de bancos
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
                  foregroundColor: WidgetStatePropertyAll(StyleColor.white),
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 30),
              ),
              backgroundColor: StyleColor.white,
              title: Text(
                'Datos de Transferencia',
                style: StylesApp(context).textStyleBody20.copyWith(
                      color: StyleColor.orange,
                      fontFamily: 'LuckiestGuy',
                      fontSize: 20,
                    ),
              ),
            ),
            body: const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: TransferForm(),
            ),
          ),
        );
      },
    );
  }
}
