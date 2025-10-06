import 'dart:io';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class OfferingsScreen extends StatelessWidget {
  const OfferingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                    // Payment Methods
                    _buildPaymentMethods(context),
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

  Widget _buildPaymentMethods(BuildContext context) {
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
          // _buildPaymentOption(
          //   icon: Icons.credit_card,
          //   title: 'Tarjeta de crédito/débito',
          //   context: context,
          //   onTap: () => debugPrint("Tarjeta seleccionada"),
          // ),
          _buildPaymentOption(
            icon: Icons.account_balance,
            title: 'Transferencia bancaria',
            context: context,
            onTap: () => _showBankTransferOptions(context),
          ),
          // _buildPaymentOption(
          //   icon: Icons.pix,
          //   title: 'Pago con PIX',
          //   context: context,
          //   onTap: () => debugPrint("PIX seleccionado"),
          // ),
          const SizedBox(height: 24),
        ],
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

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required BuildContext context,
    Function()? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: onTap,
    );
  }

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
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
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
                              color: Colors.black.withOpacity(0.1),
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

class TransferForm extends StatefulWidget {
  const TransferForm({super.key});

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _bancoOrigenController = TextEditingController();
  final _titularController = TextEditingController();
  final _identificacionController = TextEditingController();
  final _numeroCuentaController = TextEditingController();
  final _numeroReferenciaController = TextEditingController();

  File? _captureImage;
  ModelData? _selectedBancoOrigen;

  final List<ModelData> _bancos = [
    ModelData(label: 'Banco de Venezuela', value: '1'),
    ModelData(label: 'Banesco', value: '2'),
    ModelData(label: 'Mercantil', value: '3'),
    ModelData(label: 'Provincial', value: '4'),
    ModelData(label: 'Bancaribe', value: '5'),
    ModelData(label: 'BOD', value: '6'),
    ModelData(label: 'Banco del Tesoro', value: '7'),
    ModelData(label: 'Otro', value: '8')
  ];

  @override
  void dispose() {
    _bancoOrigenController.dispose();
    _titularController.dispose();
    _identificacionController.dispose();
    _numeroCuentaController.dispose();
    _numeroReferenciaController.dispose();
    super.dispose();
  }


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _captureImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _captureImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banco Origen
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              border: Border.all(
                color: StyleColor.grayDark,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.account_balance),
                ),
                Expanded(
                  child: CustomDropdownBottomWidget(
                    border: true,
                    hintText: 'Banco de Origen',
                    items: _bancos,
                    onChanged: (ModelData? newValue) {
                      setState(() {
                        _selectedBancoOrigen = newValue;
                      });
                    },
                    selectedItem: _selectedBancoOrigen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Titular de la cuenta
          TextFormField(
            controller: _titularController,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  labelText: 'Titular de la Cuenta',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.person),
                ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el nombre del titular';
              }
              if (value.length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
                return 'Solo se permiten letras y espacios';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),

          // Identificación
          TextFormField(
            controller: _identificacionController,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  labelText: 'Número de Identificación',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.badge),
                ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el número de identificación';
              }
              if (value.length < 6) {
                return 'La identificación debe tener al menos 6 dígitos';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Solo se permiten números';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Número de cuenta
          TextFormField(
            controller: _numeroCuentaController,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  labelText: 'Número de Cuenta',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.credit_card),
                ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el número de cuenta';
              }
              if (value.length < 4) {
                return 'El número de cuenta debe tener al menos 4 dígitos';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Solo se permiten números';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Número de referencia
          TextFormField(
            controller: _numeroReferenciaController,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  labelText: 'Número de Referencia',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.receipt),
                ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el número de referencia';
              }
              if (value.length < 4) {
                return 'El número de referencia debe tener al menos 4 dígitos';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Solo se permiten números';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Imagen del comprobante
          Text(
            'Comprobante de Transferencia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          _captureImage == null
              ? OutlinedButton(
                  onPressed: _pickImage,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 100),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: StyleColor.turquoise,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Adjuntar Comprobante',
                        style: StylesApp(context)
                            .textStyleBody14
                            .copyWith(color: StyleColor.turquoise),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_captureImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: _removeImage,
                        ),
                      ),
                    ),
                  ],
                ),

          const SizedBox(height: 24),

          // Botón de enviar
          SizedBox(
              width: double.infinity,
              child: ButtonThemeWidget(
                buttonStyle: StylesApp(context).btnWidgetSmall,
                text: 'Enviar Transferencia',
                onPressed: () {},
              )
              //  ElevatedButton(
              //   onPressed: _submitForm,
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   child: const Text(
              //     'Enviar Transferencia',
              //     style: TextStyle(fontSize: 16),
              //   ),
              // ),
              ),
        ],
      ),
    );
  }
}
