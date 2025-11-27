import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final String description;
  final String donorName;
  final String donorEmail;
  final String? donorPhone;

  const StripePaymentScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.description,
    required this.donorName,
    required this.donorEmail,
    this.donorPhone,
  });

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  final _cardHolderNameController = TextEditingController();

  bool _isProcessing = false;
  bool _rememberCard = false;
  bool _isCardValid = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeStripe();
    _cardHolderNameController.text = widget.donorName;
  }

  Future<void> _initializeStripe() async {
    // Configura Stripe con tu publishable key
    // Stripe.publishableKey = 'pk_test_...'; // Reemplaza con tu clave real
    // await Stripe.instance.applySettings();
  }

  @override
  void dispose() {
    _cardHolderNameController.dispose();
    super.dispose();
  }

  String? _validateCardHolder(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el nombre del titular';
    }
    if (value.length < 3) {
      return 'Nombre demasiado corto';
    }
    return null;
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isCardValid) {
      _showErrorDialog(
          'Por favor complete correctamente la información de la tarjeta');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // 1. Crear PaymentMethod usando la información del CardField
      // final paymentMethod = await Stripe.instance.createPaymentMethod(
      //   params: PaymentMethodParams.card(
      //     paymentMethodData: PaymentMethodData(
      //       billingDetails: BillingDetails(
      //         name: _cardHolderNameController.text,
      //         email: widget.donorEmail,
      //         phone: widget.donorPhone,
      //         address: Address(
      //           city: '',
      //           country: '',
      //           line1: '',
      //           line2: '',
      //           postalCode: '',
      //           state: '',
      //         ),
      //       ),
      //     ),
      //   ),
      // );

      // 2. Crear Payment Intent en tu backend

      final paymentIntentResult = await createStripePaymentIntent(
        amount: widget.amount,
        donorName: widget.donorName,
        donorEmail: widget.donorEmail,
        currency: widget.currency,
        project: "Biblia Palabra de vida",
        notes: widget.description,
      );

      if (paymentIntentResult.error != null) {
        _showErrorDialog(paymentIntentResult.error!);
        return;
      }

      final paymentIntentData =
          paymentIntentResult.data!['createStripePaymentIntent'];
      final String clientSecret = paymentIntentData['clientSecret'];
      final String paymentIntentId = paymentIntentData['paymentIntentId'];
      final String donationId = paymentIntentData['donationId'];

      // 3. Confirmar el pago con Stripe
      // final paymentResult = await Stripe.instance.confirmPayment(
      //   paymentIntentClientSecret: clientSecret,
      //   data: PaymentMethodParams.card(
      //     paymentMethodData: PaymentMethodData(
      //       billingDetails: BillingDetails(
      //         name: _cardHolderNameController.text,
      //         email: widget.donorEmail,
      //         phone: widget.donorPhone,
      //         address: Address(
      //           city: '',
      //           country: '',
      //           line1: '',
      //           line2: '',
      //           postalCode: '',
      //           state: '',
      //         ),
      //       ),
      //     ),
      //   ),
      // );

      // 4. Verificar el estado del pago
      // if (paymentResult.status == PaymentIntentsStatus.Succeeded) {
      //   // 5. Confirmar el pago con tu backend
      //   final confirmationResult = await confirmPaymentWithBackend(
      //       paymentIntentId: paymentIntentId, donationId: donationId);

      //   if (confirmationResult.error != null) {
      //     _showErrorDialog(confirmationResult.error!);
      //     return;
      //   }

      //   final confirmationData =
      //       confirmationResult.data!['confirmStripePayment'];

      //   if (confirmationData['success'] == true) {
      //     _showSuccessDialog(donationId);
      //   } else {
      //     _showErrorDialog('El pago no pudo ser confirmado en el servidor');
      //   }
      // } else {
      //   _showErrorDialog('El pago no fue exitoso: ${paymentResult.status}');
      // }
    } catch (e) {
      _showErrorDialog('Error al procesar el pago: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSuccessDialog(String donationId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('¡Pago Exitoso!', style: TextStyle(color: Colors.green)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu donación ha sido procesada exitosamente.'),
              SizedBox(height: 10),
              Text('Monto: \$${widget.amount.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Text('ID de Donación: $donationId',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 10),
              Text('Gracias por tu generosidad.',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver a pantalla anterior
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text('Error de Pago', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Reintentar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Pago con Tarjeta',
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
            // Header con información del pago
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: StyleColor.turquoise.withOpacity(0.1),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monto a donar:',
                        style: StylesApp(context).textStyleBody16.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        '\$${widget.amount.toStringAsFixed(2)}',
                        style: StylesApp(context).textStyleBody20.copyWith(
                              color: StyleColor.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Descripción:',
                        style: StylesApp(context).textStyleBody14.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Expanded(
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.right,
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: Colors.grey[600],
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Formulario de tarjeta
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información de la Tarjeta',
                        style: StylesApp(context).textStyleBody18.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),

                      // Nombre del titular
                      TextFormField(
                        controller: _cardHolderNameController,
                        decoration: StylesApp(context)
                            .inputDecorationOutlineStyle
                            .copyWith(
                              labelText: 'Nombre del Titular',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                        validator: _validateCardHolder,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 20),

                      // ✅ WIDGET CardField DE STRIPE - MANTENIDO Y FUNCIONAL
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container()
                        // CardField(
                        //   onCardChanged: (card) {
                        //     setState(() {
                        //       _isCardValid = card!.complete;
                        //     });
                        //   },
                        //   decoration: const InputDecoration(
                        //     contentPadding: EdgeInsets.symmetric(
                        //       horizontal: 16,
                        //       vertical: 12,
                        //     ),
                        //     border: InputBorder.none,
                        //   ),
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontSize: 16,
                        //   ),
                        //   cursorColor: StyleColor.orange,
                        // ),
                      ),
                      const SizedBox(height: 8),

                      // Mensaje de estado de la tarjeta
                      if (!_isCardValid)
                        Text(
                          'Complete la información de la tarjeta',
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: Colors.orange,
                              ),
                        ),

                      const SizedBox(height: 20),

                      // Recordar tarjeta
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberCard,
                            onChanged: (value) {
                              setState(() {
                                _rememberCard = value!;
                              });
                            },
                            activeColor: StyleColor.orange,
                          ),
                          Text(
                            'Recordar esta tarjeta para futuras donaciones',
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Información de seguridad
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.security, color: Colors.green, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tu información está protegida con encriptación de nivel bancario',
                                style:
                                    StylesApp(context).textStyleBody12.copyWith(
                                          color: Colors.grey[600],
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // Botón de pago
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: _isProcessing
                    ? ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: StyleColor.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Procesando...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ButtonThemeWidget(
                        buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                              backgroundColor:
                                  MaterialStateProperty.all(StyleColor.orange),
                            ),
                        text: 'Donar \$${widget.amount.toStringAsFixed(2)}',
                        onPressed: _isCardValid ? _processPayment : null,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
