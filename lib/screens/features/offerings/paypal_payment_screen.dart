import 'package:flutter/material.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalPaymentScreen extends StatefulWidget {
  final double amount;
  final String description;

  const PayPalPaymentScreen({
    super.key,
    required this.amount,
    required this.description,
  });

  @override
  State<PayPalPaymentScreen> createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  bool _isLoading = true;
  bool _paymentCompleted = false;
  // late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    // Simular inicialización de PayPal
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _startPayPalPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Integración con PayPal usando el paquete paypal_payment
     
      // var result = await PayPalPayment(
      //   environment: Environment.sandbox, // Cambiar a production
      //   clientId: 'TU_CLIENT_ID',
      //   secretKey: 'TU_SECRET_KEY',
      //   transactions: [
      //     {
      //       "amount": {
      //         "total": widget.amount.toStringAsFixed(2),
      //         "currency": "USD",
      //       },
      //       "description": widget.description,
      //     }
      //   ],
      // ).checkout();
     

      // Simulación de pago exitoso
      await Future.delayed(const Duration(seconds: 3));
      
      _showSuccessDialog();
      
    } catch (e) {
      _showErrorDialog('Error al procesar con PayPal: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Alternativa con WebView
  Widget _buildPayPalWebView() {
    return Column(
      children: [
        // Header informativo
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue[700], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Serás redirigido a PayPal para completar tu donación de forma segura',
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: Colors.blue[700],
                      ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Integración con PayPal',
                    style: StylesApp(context).textStyleBody18.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aquí se cargaría el WebView de PayPal',
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: Colors.grey[500],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              const SizedBox(width: 10),
              Text('¡Donación Exitosa!', style: TextStyle(color: Colors.green)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu donación a través de PayPal ha sido procesada.'),
              const SizedBox(height: 10),
              Text('Monto: \$${widget.amount.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              Text(
                'Recibirás un correo de confirmación de PayPal.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver a pantalla anterior
              },
              child: const Text('Aceptar'),
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
              const SizedBox(width: 10),
              Text('Error de Pago', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Reintentar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
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
          'Pago con PayPal',
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
            // Resumen de la donación
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

            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _buildPaymentOptions(),
            ),

            // Información de seguridad
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.security, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago 100% seguro con PayPal',
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tu información financiera está protegida. No almacenamos los datos de tu tarjeta.',
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(StyleColor.orange),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Preparando pago con PayPal...',
            style: StylesApp(context).textStyleBody16.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Logo de PayPal
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.payment,
                  size: 80,
                  color: Colors.blue[700],
                ),
                const SizedBox(height: 16),
                Text(
                  'PayPal',
                  style: StylesApp(context).textStyleBody24.copyWith(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'La forma más segura de pagar online',
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Ventajas de PayPal
          _buildAdvantageItem(
            icon: Icons.security,
            title: 'Protección del comprador',
            description: 'Tu dinero está protegido contra pagos no autorizados',
          ),
          const SizedBox(height: 16),
          _buildAdvantageItem(
            icon: Icons.speed,
            title: 'Pago rápido',
            description: 'Sin necesidad de ingresar datos de tarjeta cada vez',
          ),
          const SizedBox(height: 16),
          _buildAdvantageItem(
            icon: Icons.credit_card,
            title: 'Múltiples opciones',
            description: 'Paga con tu cuenta PayPal, tarjeta o saldo',
          ),
          const SizedBox(height: 40),

          // Botón de acción
          SizedBox(
            width: double.infinity,
            child: ButtonThemeWidget(
              buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
                  ),
              text: 'Continuar con PayPal',
              onPressed: _startPayPalPayment,
            ),
          ),
          const SizedBox(height: 16),

          // Opción alternativa
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Elegir otro método de pago',
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: Colors.grey[600],
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantageItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}