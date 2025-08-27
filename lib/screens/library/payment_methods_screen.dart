import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
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
                'Medios de pago',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Selección de moneda
              const Text('Seleccione la moneda de pago'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildInfoChip('USD'),
                  const SizedBox(width: 8),
                  _buildInfoChip('V'),
                ],
              ),

              const SizedBox(height: 24),

              // Lista de productos
              _buildProductoItem(
                  '(Audiolibro) el poder de la oración', '50,00 USD'),
              _buildProductoItem(
                  '(Libro) la creación de Dios tan colorida', '15,00 USD'),
              _buildProductoItem('(Libro Online) No estás solo', '10,00 USD'),
              _buildProductoItem('Costo de Envío', '5,00 USD'),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Tabla de totales
              _buildTotalRow('Nato', '62,40 USD'),
              _buildTotalRow('IVA', '17,60 USD'),
              _buildTotalRow('Total a pagar', '80,00 USD', isTotal: true),

              const SizedBox(height: 24),

              // Métodos de pago
              const Text(
                'Pagar con',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Botón de PayPal
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    'PayPal',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Otras opciones de pago
              _buildMethodPay('Transferencia Bancaria'),
              _buildMethodPay('Prometo'),
              _buildMethodPay('Pago con tarjeta de Crédito'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey[200],
      labelStyle: const TextStyle(fontSize: 12),
    );
  }


  Widget _buildProductoItem(String nombre, String precio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              nombre,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            precio,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodPay(String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: const Icon(Icons.circle, size: 16, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Text(
            method,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
