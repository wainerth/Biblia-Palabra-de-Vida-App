import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OfferingsScreen extends StatelessWidget {
  const OfferingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12CBC4),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
            foregroundColor: WidgetStatePropertyAll(StyleColor.white),
          ),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pushNamed(context, "/layoutPage");
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage("assets/elipsisTop.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icono de ofrendas
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
                            color: Color(0xFFFF914D),
                            fontFamily: 'LuckiestGuy',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Tu generosidad nos ayuda a continuar compartiendo la Palabra de Dios',
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: const Divider(color: Colors.white, thickness: 1),
              ),
              const SizedBox(height: 16),
              // Sección de monto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selecciona el monto:',
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAmountChip('\$/ 10', context),
                        _buildAmountChip('\$/ 20', context),
                        _buildAmountChip('\$/ 50', context),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'O ingresa otro monto',
                        labelStyle: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Montserrat',
                        ),
                        prefixText: '\$/ ',
                        prefixStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: StyleColor.orange),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: const Divider(color: Colors.white, thickness: 1),
              ),
              const SizedBox(height: 16),
              // Métodos de pago
              Padding(
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
                    _buildPaymentOption(
                      icon: Icons.credit_card,
                      title: 'Tarjeta de crédito/débito',
                      context: context,
                    ),
                    _buildPaymentOption(
                      icon: Icons.account_balance,
                      title: 'Transferencia bancaria',
                      context: context,
                    ),
                    _buildPaymentOption(
                      icon: Icons.pix,
                      title: 'Pago con PIX',
                      context: context,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Botón de donar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _showDonationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: StyleColor.orange,
                    foregroundColor: StyleColor.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Donar ahora',
                    style: StylesApp(context).textStyleBody18.copyWith(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '© 2025 Biblia Palabra de Vida',
                style: StylesApp(context).textStyleBody10.copyWith(
                      color: Colors.white70,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                    ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountChip(String amount, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        amount,
        style:  TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16,
      ),
      onTap: () {
        // Navegar a la pantalla de pago específica
      },
    );
  }

  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: const Color(0xFF12CBC4),
          title: Text(
            '¡Gracias por tu ofrenda!',
            style: TextStyle(
              color: StyleColor.orange,
              fontFamily: 'LuckiestGuy',
              fontSize: 22,
            ),
          ),
          content: Text(
            'Tu generosa contribución ayudará a expandir el Evangelio. Dios bendiga tu vida.',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Amén',
                style: TextStyle(
                  color: StyleColor.orange,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
