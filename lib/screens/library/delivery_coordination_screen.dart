import 'package:biblia_palabra_de_vida_app/screens/library/payment_methods_screen.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class DeliveryCoordinationScreen extends StatefulWidget {
  const DeliveryCoordinationScreen({super.key});

  @override
  State<DeliveryCoordinationScreen> createState() =>
      _DeliveryCoordinationScreenState();
}

class _DeliveryCoordinationScreenState
    extends State<DeliveryCoordinationScreen> {
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
            Row(
              children: [
                _buildInfoChip('Uruguay'),
                const SizedBox(width: 8),
                _buildInfoChip('USD'),
              ],
            ),

            const SizedBox(height: 16),

            // Información de ciudad
            Row(
              children: [
                _buildInfoChip('Montevideo'),
                const SizedBox(width: 8),
                _buildInfoChip('V'),
              ],
            ),

            const SizedBox(height: 16),

            // Campo de texto para nombre
            _buildTextField('Nombre de la persona a entregarle'),

            const SizedBox(height: 16),

            // Campo de texto para teléfono
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField('1598'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: _buildTextField('Numero de telefono'),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Opciones de entrega
            _buildOpcionEntrega(
              'Libreria el escudero de Dios',
              'Avendas 18 de Julio 3564 entre ricos y Juan vidas zona Cordon',
            ),

            const SizedBox(height: 16),
            _buildOpcionEntrega(
              'Retirar en la Iglesia Palabra de vida',
              'Avendas Teniente rinaldi 2858, piedras blancas, CP 12300',
            ),

            const SizedBox(height: 16),
            _buildOpcionEntrega(
              'Retirar en la Iglesia Cordon',
              'Av. Rivera 2135, CP 11200',
            ),

            const SizedBox(height: 16),
            _buildOpcionEntrega(
              'Entrega a domicilio',
              'CP (12300)\nS/90 USD',
            ),

            const SizedBox(height: 16),
            _buildTextField('Dirección de entrega'),

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
              'Nota: La entrega se hace entre 1 día y hasta un maximo de 14 días hábiles.',
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

  Widget _buildInfoChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey[200],
      labelStyle: const TextStyle(fontSize: 12),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildOpcionEntrega(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
