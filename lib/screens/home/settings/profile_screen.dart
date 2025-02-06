import 'dart:convert';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';

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

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final fileSizeInBytes = imageFile.lengthSync();
      final fileSizeInMegabytes = fileSizeInBytes / (1024 * 1024);
      if (kDebugMode) {
        print(pickedFile.path);
      }
      if (fileSizeInMegabytes <= 5) {
        List<int> imageBytes = await imageFile.readAsBytes();

        String _base64Image = base64Encode(imageBytes);

        final mimeType = lookupMimeType(imageFile.path); // Obtiene el tipo MIME

        if (mimeType != null) {
          String dataUrl = "data:$mimeType;base64,$_base64Image";
          print(dataUrl); // Imprime la Data URL para pegarla en el navegador
        } else {
          print("No se pudo determinar el tipo MIME de la imagen.");
        }
        setState(() {
          avatarImg = pickedFile.path;
        });
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateAvatarUser(dataUser!.user.id, _base64Image);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Imagen muy grande'),
              content: Text(
                  'La imagen seleccionada excede el tamaño máximo de 5MB.'),
              actions: [
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    dataUser = userProvider.currentUser;

    List<ModelData> progressData = [
      ModelData(
        label: "Registro",
        value: dataUser!.createdAt.isNotEmpty
            ? getFormatedDate(int.parse(dataUser!.createdAt))
            : "",
      ),
      ModelData(label: "Racha", value: "${dataUser!.streakDaysCount} días"),
      ModelData(label: "Energía", value: "${dataUser!.expTotalUser}"),
      ModelData(label: "Cursos Completados", value: "4"),
    ];
    List<ModelData> personalData = [
      ModelData(label: "Nombre", value: dataUser!.name, showLabel: false),
      ModelData(
          label: "Apellido", value: "${dataUser?.lastName}", showLabel: false),
      ModelData(label: "Sexo", value: "${dataUser!.gender}"),
      ModelData(label: "Fecha nac", value: "${dataUser!.birthday}"),
      ModelData(
          label: "Bautizo",
          value: getIsBaptized(dataUser!.isBaptized ?? false),
          showLabel: false),
    ];
    List<ModelData> contactDetails = [
      ModelData(label: "Email", value: dataUser!.user.email, showLabel: false),
      ModelData(label: "Tel.", value: dataUser!.phoneNumber ?? ''),
    ];
    List<ModelData> locationData = [
      ModelData(label: "País", value: dataUser!.country?.country ?? ''),
      ModelData(label: "Ciudad", value: "Montevideo"),
      ModelData(
          label: "Iglesia",
          value: getChurchActive(dataUser!.user.userChurch) != null
              ? getChurchActive(dataUser!.user.userChurch)!.name
              : '')
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
                          if (data[i].showLabel || data[i].value.isNotEmpty)
                            Text.rich(
                              style: StylesApp(context).textStyleBodyWhite4,
                              TextSpan(
                                children: [
                                  if (data[i].label.isNotEmpty)
                                    if (data[i].showLabel)
                                      TextSpan(text: "${data[i].label}: "),
                                  TextSpan(
                                    text: data[i].value.isNotEmpty
                                        ? data[i].value
                                        : '',
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
                              return EditDetailDialog(
                                data: data,
                                onSave: (List<ModelData> dta) {
                                  print(dta.length);
                                  Navigator.pop(context);
                                  // servicio de actualización

                                  final userProvider = Provider.of<UserProvider>(context);
                                  userProvider.updateProfile(dta);
                                },
                              );
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
  final Function(List<ModelData>) onSave;
  const EditDetailDialog({super.key, required this.data, required this.onSave});

  @override
  State<EditDetailDialog> createState() => _editDetailDialog();
}

class _editDetailDialog extends State<EditDetailDialog> {
  late List<ModelData> _editingData;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _editingData = List.from(widget.data);
    for (var item in _editingData) {
      _controllers.add(TextEditingController(text: item.value));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

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

    final List<ModelData> listChurches = catalogueProvider.allChurches
        .map((church) => ModelData(value: church.id, label: church.name))
        .cast<ModelData>()
        .toList();
    List<ModelData> optionsSex = [
      ModelData(value: 'm', label: 'Masculino'),
      ModelData(value: 'f', label: 'Femenino')
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
                              itemCount: _editingData.length,
                              itemBuilder: (context, index) {
                                final item = _editingData[index];
                                return Column(
                                  children: [
                                    _buildField(
                                      item,
                                      index, // Pasa el índice
                                      dropDownList,
                                      prefixCode,
                                      optionsSex,
                                      listChurches,
                                      catalogueProvider.allChurches,
                                      catalogueProvider.allCountries,
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    )
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
                              // width: 239.0,
                              height: 40.0,
                              onPressed: () {
                                widget.onSave(_editingData);
                              },
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

  //Method buildField
  Widget _buildField(
      ModelData item,
      int index,
      List<ModelData> dropDownList,
      List<ModelData> listPrefixCode,
      List<ModelData> optionsSex,
      List<ModelData> optionsChurches,
      List<Church> listChurches,
      List<Country> listCatalogue) {
    if (item.label == 'Tel.') {
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
                    _editingData[index] = ModelData(
                      label: _editingData[index].label,
                      value:
                          '${newValue?.label} ${_editingData[index].value.split(' ')[1]}',
                      showLabel: _editingData[index].showLabel,
                    );
                  });
                },
                selectedItem: item.value.isNotEmpty
                    ? listPrefixCode.firstWhere(
                        (element) => element.label == item.value.split(' ')[0])
                    : null,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _controllers[index],
              keyboardType: TextInputType.phone,
              inputFormatters: [
                maskFormatterTel, // Permite solo números
              ],
              onChanged: (value) {
                _controllers[index].text = value;
                _editingData[index] = ModelData(
                  label: _editingData[index].label,
                  value:
                      '${_editingData[index].value.split(' ')[0]} ${_controllers[index].text.replaceAll(RegExp(r'[^\d]+'), '')}',
                  showLabel: _editingData[index].showLabel,
                );
              },
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
                        hintText: "Número de teléfono",
                      ),
              style: StylesApp(context)
                  .textStyleBody16
                  .copyWith(color: Colors.black),
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
              _editingData[index] = ModelData(
                label: _editingData[index].label,
                value: newValue!.value,
                showLabel: _editingData[index].showLabel,
              );
            });
          },
          selectedItem: item.value.isNotEmpty
              ? optionsSex.firstWhere(
                  (element) => element.value == item.value.toLowerCase())
              : null,
        ),
      );
    } else if (item.label == 'Fecha nac') {
      return DatePickerFormField(
        initialDate: item.value.isNotEmpty
            ? DateFormat("dd/MM/yyyy").parse(item.value)
            : DateTime.now().subtract(Duration(days: 15 * 365)),
        onChanged: (value) {
          _editingData[index] = ModelData(
            label: _editingData[index].label,
            value: value,
            showLabel: _editingData[index].showLabel,
          );
        },
      );
    } else if (item.label == 'Bautizo') {
      return BautizadoRadioButton(
        isBautizado: item.value == 'Bautizado',
        onChanged: (bool? value) {
          setState(() {
            _editingData[index] = ModelData(
              label: _editingData[index].label,
              value: value! ? "Bautizado" : "No Bautizado",
              showLabel: _editingData[index].showLabel,
            );
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
              _editingData[index] = ModelData(
                label: _editingData[index].label,
                value: newValue!.label,
                showLabel: _editingData[index].showLabel,
              );
            });
          },
          selectedItem: item.value.isNotEmpty
              ? dropDownList
                  .firstWhere((element) => element.label == item.value)
              : null,
        ),
      );
    } else if (item.label == 'Iglesia') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: CustomDropdownWidget<Church>(
          hintText: "Seleccione una Iglesia",
          items: optionsChurches,
          onChanged: (ModelData? newValue) {
            setState(() {
              _editingData[index] = ModelData(
                label: _editingData[index].label,
                value: newValue!.label,
                showLabel: _editingData[index].showLabel,
              );
            });
          },
          selectedItem: item.value.isNotEmpty
              ? optionsChurches
                  .firstWhere((element) => element.label == item.value)
              : null,
        ),
      );
    } else {
      return TextFormField(
        readOnly: item.label == 'Email',
        controller: _controllers[index],
        decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
              hintText: item.label,
            ),
        onChanged: (value) {
          _editingData[index] = ModelData(
            label: _editingData[index].label,
            value: value,
            showLabel: _editingData[index].showLabel,
          );
        },
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
