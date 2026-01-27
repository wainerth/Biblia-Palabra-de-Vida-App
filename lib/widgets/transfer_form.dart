import 'dart:io';

import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class TransferForm extends StatefulWidget {
  const TransferForm({super.key});

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _bancoOrigenController = TextEditingController();
  final _titularController = TextEditingController();
  final _identificationController = TextEditingController();
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
    _identificationController.dispose();
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
              if (!RegExp(r'^[a-zA-ZÃ¡Ã©Ã­Ã³ÃºÃÃ‰ÃÃ“ÃšÃ±Ã‘\s]+$')
                  .hasMatch(value)) {
                return 'Solo se permiten letras y espacios';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),

          // Identificación
          TextFormField(
            controller: _identificationController,
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

          // BotÃ³n de enviar
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
