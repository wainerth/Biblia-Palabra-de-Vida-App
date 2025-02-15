import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditDetailDialogWidget extends StatefulWidget {
  final List<ModelData> data;
  final Function(List<ModelData>) onSave;
  const EditDetailDialogWidget(
      {super.key, required this.data, required this.onSave});

  @override
  State<EditDetailDialogWidget> createState() => _editDetailDialogWidget();
}

class _editDetailDialogWidget extends State<EditDetailDialogWidget> {
  late List<ModelData> _editingData;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _editingData = List.from(widget.data);
    for (var item in _editingData) {
      if (item.label == 'Tel.') {
        _controllers.add(TextEditingController(
            text: item.value.isNotEmpty ? item.value.split(' ')[1] : ''));
      } else {
        _controllers.add(TextEditingController(text: item.value));
      }
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
                      clave: _editingData[index].clave,
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
                  clave: _editingData[index].clave,
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
        child: CustomDropdownBottomWidget(
          hintText: "Seleccione Sexo",
          items: optionsSex,
          onChanged: (ModelData? newValue) {
            setState(() {
              _editingData[index] = ModelData(
                label: _editingData[index].label,
                value: newValue!.value,
                clave: _editingData[index].clave,
                showLabel: _editingData[index].showLabel,
              );
            });
          },
          selectedItem: item.value.isNotEmpty
              ? optionsSex.firstWhere(
                  (element) => 
                  element.label.toLowerCase() == item.value.toLowerCase())
              : null,
        ),
      );
    } else if (item.label == 'Fecha nac') {
      return DatePickerFormField(
        initialDate: item.value.isNotEmpty
            ? DateFormat("dd/MM/yyyy").parse(item.value)
            : DateTime.now().subtract(Duration(days: 15 * 365)),
        onChanged: (value) {
          print(value);
          _editingData[index] = ModelData(
            label: _editingData[index].label,
            value: value,
            clave: _editingData[index].clave,
            showLabel: _editingData[index].showLabel,
          );
        },
      );
    } else if (item.label == 'Bautizo') {
      return RadioButtonWidget<bool>(
          // Ejemplo con opciones de tipo String
          label: "Bautizado:",
          value: item.value == 'Bautizado',
          onChanged: (newValue) => {
                setState(() {
                  _editingData[index] = ModelData(
                    label: _editingData[index].label,
                    value: newValue! ? "Bautizado" : "No Bautizado",
                    clave: _editingData[index].clave,
                    showLabel: _editingData[index].showLabel,
                  );
                })
              },
          options: [
            RadioButtonOption(value: true, label: "Si"),
            RadioButtonOption(value: false, label: "No")
          ]);

      // BautizadoRadioButton(
      //   isBautizado: item.value == 'Bautizado',
      //   onChanged: (bool? value) {
      //     setState(() {
      //       _editingData[index] = ModelData(
      //         label: _editingData[index].label,
      //         value: value! ? "Bautizado" : "No Bautizado",
      //         clave: _editingData[index].clave,
      //         showLabel: _editingData[index].showLabel,
      //       );
      //     });
      //   },
      // );
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
                clave: _editingData[index].clave,
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
                clave: _editingData[index].clave,
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
            clave: _editingData[index].clave,
            showLabel: _editingData[index].showLabel,
          );
        },
      );
    }
  }
}
