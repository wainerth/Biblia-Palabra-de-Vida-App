import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String avatarImg = 'assets/avatar.png';
  LoginUser? dataUser;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (kDebugMode) {
          print(pickedFile.path);
        }
        avatarImg = pickedFile.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    dataUser = authProvider.currentUser;

    List<ModelData> progressData = [
      ModelData(
        label: "Registro",
        value: getFormatedDate(int.parse(dataUser!.createdAt)),
      ),
      ModelData(label: "Racha", value: "${dataUser!.streakDaysCount} días"),
      ModelData(label: "Energía", value: "${dataUser!.expTotalUser}"),
      ModelData(label: "Cursos Completados", value: "4"),
    ];
    List<ModelData> personalData = [
      ModelData(label: "Nombre", value: dataUser!.name, showLabel: false),
      ModelData(label: "Sexo", value: "Masculino"),
      ModelData(label: "Fecha nac", value: "01/07/1980"),
      ModelData(label: "Bautizo", value: "Bautizado", showLabel: false),
    ];
    List<ModelData> contactDetails = [
      ModelData(
          label: "Email", value: "robinsongarces@gmail.com", showLabel: false),
      ModelData(label: "Tel.:", value: "+58 4267406377"),
    ];
    List<ModelData> locationData = [
      ModelData(label: "País", value: "Uruguay"),
      ModelData(label: "Ciudad", value: "Montevideo"),
      ModelData(label: "Iglesia", value: "Palabra de Vida"),
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Color(0XFF12CBC4)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // _headerDetails(),
                ProfileHeader(
                  avatarImg: dataUser!.imgProfileUser,
                  onSelectImage: _selectImage,
                ),
                SizedBox(
                  height: 23.0,
                ),
                CardColumnWidget(
                  iconRight: "assets/Flag.png",
                  data: progressData,
                  iconLeft: Icons.trending_up,
                  highlightLabel: true,
                  route: "/detailsProgressPage",
                ),
                SizedBox(
                  height: 16,
                ),
                CardColumnWidget(
                  iconRight: "assets/User.png",
                  data: personalData,
                  iconLeft: Icons.edit,
                ),
                SizedBox(
                  height: 16,
                ),
                CardColumnWidget(
                  iconRight: "assets/Link.png",
                  data: contactDetails,
                  iconLeft: Icons.edit,
                ),
                SizedBox(
                  height: 16,
                ),
                CardColumnWidget(
                  iconRight: "assets/Map_pin.png",
                  data: locationData,
                  iconLeft: Icons.edit,
                  divider: false,
                ),
                SizedBox(
                  height: 35.0,
                ),
                ButtonThemeWidget(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/layoutPage');
                  },
                  text: "Volver",
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  textStyle: StylesApp(context).textStyleBody7,
                  width: 239.0,
                  height: 40.0,
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardColumnWidget extends StatelessWidget {
  final String iconRight;
  final IconData iconLeft;
  final List<ModelData> data;
  final bool highlightLabel;
  final bool divider;
  final String? route;
  const CardColumnWidget(
      {super.key,
      required this.iconRight,
      required this.iconLeft,
      this.divider = true,
      required this.data,
      this.highlightLabel = false,
      this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 10, bottom: 16),
          child: Stack(
            children: [
              Row(
                spacing: 10.0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        iconRight,
                        width: 40.sp,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < data.length; i++) ...[
                          Text.rich(
                            style: StylesApp(context).textStyleBodyWhite4,
                            TextSpan(
                              children: [
                                if (data[i].label.isNotEmpty)
                                  if (data[i].showLabel)
                                    TextSpan(text: "${data[i].label}: "),
                                TextSpan(
                                  text: data[i].value,
                                  style: StylesApp(context)
                                      .textStyleBodyWhite4
                                      .copyWith(
                                        color: (highlightLabel &&
                                                (i == 1 || i == 2))
                                            ? Colors.orange
                                            : Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 2,
                child: Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.sp),
                    color: Colors.orange,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(maxWidth: 40.sp),
                    iconSize: 30.sp,
                    onPressed: () {
                      if (route != null) {
                        Navigator.popAndPushNamed(context, route!);
                      } else {
                        showDialog(
                            useSafeArea: true,
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return EditDetailDialog(data: data);
                            });
                      }
                    },
                    icon: Icon(
                      iconLeft,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (divider)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            height: 2.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white, // Co
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.25), // Color de la sombra
                  spreadRadius: 2, // Extensión de la sombra
                  blurRadius: 5, // Difuminado de la sombra
                  offset: Offset(0, 3), // Desplazamiento de la sombra
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class EditDetailDialog extends StatefulWidget {
  final List<ModelData> data;
  const EditDetailDialog({super.key, required this.data});

  @override
  State<EditDetailDialog> createState() => _editDetailDialog();
}

class _editDetailDialog extends State<EditDetailDialog> {
  @override
  Widget build(BuildContext context) {
    final catalogueProvider =
        Provider.of<CatalogueProvider>(context, listen: false);

    final List<ModelData> dropDownList = catalogueProvider.allCountries
        .map((country) => ModelData(value: country.id, label: country.country))
        .cast<ModelData>()
        .toList();
    final List<ModelData> prefixCode = catalogueProvider.allCountries
        .map((country) =>
            ModelData(value: country.id, label: country.countryCode))
        .cast<ModelData>()
        .toList();
    List<ModelData> optionsSex = [
      ModelData(value: 'masculino', label: 'Masculino'),
      ModelData(value: 'femenino', label: 'Femenino'),
      ModelData(
          value: 'otro',
          label: 'Otro'), // Opción adicional para personas no binarias
      ModelData(
          value: 'desconocido',
          label: 'Desconocido'), // Opción para cuando no se conoce el sexo
    ];
    return Dialog(
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Elimina las esquinas redondeadas
      ),
      insetPadding: EdgeInsets.only(top: 50),
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: StyleColor.turquoise,
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: Column(
                children: [
                  HeadScreenNotAvatar(
                    title: "Edición de Datos",
                    onRoute: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: widget.data.length,
                              itemBuilder: (context, index) {
                                final item = widget.data[index];
                                return Column(
                                  children: [
                                    _buildField(
                                        item,
                                        dropDownList,
                                        prefixCode,
                                        optionsSex,
                                        catalogueProvider.allCountries),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: ButtonThemeWidget(
                              buttonStyle: StylesApp(context).btnWidgetSmall,
                              text: 'Guardar',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
      ModelData item,
      List<ModelData> dropDownList,
      List<ModelData> listPrefixCode,
      List<ModelData> optionsSex,
      List<Country> listCatalogue) {
    final FocusNode _focusNode = FocusNode();
    String phoneNumber = '';
    ModelData? _selectedData;
    ModelData? _selectedDataSex;
    String? bautizado;
    var _selectedCountry = null;
    var _selectedCountryCode = null;

    final TextEditingController _phoneNumberController =
        TextEditingController();
    final TextEditingController _textEditController =
        TextEditingController(text: item.value);

    if (item.label == 'Tel.:') {
      _phoneNumberController.text = '';
      phoneNumber = maskFormatterTel
          .maskText(item.value.isNotEmpty ? item.value.split(' ')[1] : '');

      _selectedCountryCode = item.value.isNotEmpty
          ? listPrefixCode.firstWhere(
              (element) => element.label == item.value.split(' ')[0])
          : null;
      return Row(
        spacing: 10,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: CustomDropdownWidget<Country>(
                hintText: "código",
                items: listPrefixCode,
                onChanged: (ModelData? newValue) {
                  setState(() {
                    _selectedCountryCode = newValue;
                  });
                },
                selectedItem: _selectedCountryCode,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              // controller: _phoneNumberController,
              initialValue: phoneNumber,
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                maskFormatterTel, // Permite solo números
              ],
              onFieldSubmitted: (value) {
                _phoneNumberController.text =
                    value.replaceAll(RegExp(r'[^\d]+'), '');
              },
              onChanged: (value) {
                _phoneNumberController.text =
                    value.replaceAll(RegExp(r'[^\d]+'), '');
              },
              decoration: StylesApp(context).inputDecorationStyle.copyWith(
                    hintText: "Número de teléfono",
                  ),
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor, ingresa tu número de teléfono.";
                }
                return null;
              },
            ),
          )
        ],
      );
    } else if (item.label == 'Sexo') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: CustomDropdownWidget<SexModel>(
          hintText: "Seleccione Sexo",
          items: optionsSex,
          onChanged: (ModelData? newValue) {
            setState(() {
              _selectedDataSex = newValue;
            });
          },
          selectedItem: _selectedDataSex,
        ),
      );
    } else if (item.label == 'Bautizo') {
      bautizado = item.value;
      return BautizadoRadioButton(
        isBautizado: bautizado == 'Bautizado',
        onChanged: (bool? value) {
          setState(() {
            bautizado = "No Bautizado";
          });
        },
      );
    } else if (item.label == 'País') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: CustomDropdownWidget<Country>(
          hintText: "Seleccione un país",
          items: dropDownList,
          onChanged: (ModelData? newValue) {
            setState(() {
              _selectedData = newValue;
              _selectedCountry = listCatalogue
                  .firstWhere((country) => country.id == newValue!.value);
            });
          },
          selectedItem: _selectedData,
        ),
      );
    } else {
      return TextFormField(
        controller: _textEditController,
        decoration: StylesApp(context).inputDecorationStyle.copyWith(
              hintText: item.label,
            ),
      );
    }
  }
}

class BautizadoRadioButton extends StatefulWidget {
  final bool isBautizado;
  final Function(bool?)? onChanged;
  const BautizadoRadioButton(
      {super.key, required this.isBautizado, this.onChanged});

  @override
  State<BautizadoRadioButton> createState() => _BautizadoRadioButtonState();
}

class _BautizadoRadioButtonState extends State<BautizadoRadioButton> {
  // Variable para almacenar la opción seleccionada

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          '¿Está bautizado?',
          style:
              StylesApp(context).textStyleBody16.copyWith(color: Colors.black),
        ), // Etiqueta para el grupo de RadioButtons
        Radio<bool>(
          value: true, // Valor para la opción "Sí"
          activeColor: StyleColor.turquoise,
          groupValue:
              widget.isBautizado, // Grupo al que pertenece este RadioButton
          onChanged: widget.onChanged,
        ),
        Text('Sí',
            style: StylesApp(context)
                .textStyleBody16
                .copyWith(color: Colors.black)), // Etiqueta para la opción "Sí"
        Radio<bool>(
          value: false, // Valor para la opción "No"
          activeColor: StyleColor.turquoise,
          groupValue:
              widget.isBautizado, // Grupo al que pertenece este RadioButton
          onChanged: widget.onChanged,
        ),
        Text('No',
            style: StylesApp(context)
                .textStyleBody16
                .copyWith(color: Colors.black)), // Etiqueta para la opción "No"
      ],
    );
  }
}
