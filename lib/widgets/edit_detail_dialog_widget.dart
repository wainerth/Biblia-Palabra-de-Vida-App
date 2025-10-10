import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditDetailDialogWidget extends StatefulWidget {
  final List<ModelData> data;
  final Function(List<ModelData>) onSave;
  const EditDetailDialogWidget(
      {super.key, required this.data, required this.onSave});

  @override
  State<EditDetailDialogWidget> createState() => _EditDetailDialogWidget();
}

class _EditDetailDialogWidget extends State<EditDetailDialogWidget> {
  late List<ModelData> _editingData;
  final List<TextEditingController> _controllers = [];
  String? _selectedCountryId;
  String? _selectedStateId;
  List<ModelData> _statesList = [];
  List<ModelData> _citiesList = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _editingData = List.from(widget.data);
    for (var item in _editingData) {
      if (item.label == 'Tel.') {
        _controllers.add(TextEditingController(
            text: item.value.isNotEmpty
                ? maskFormatterTel.maskText(item.value.split(' ')[1])
                : ''));
      } else {
        _controllers.add(TextEditingController(text: item.value));
      }
    }

    // Inicializar valores de país, estado y ciudad si existen
    _initializeLocationValues().then((_) {
      setState(() {
        _isInitialized = true;
      });
    });
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
    return Dialog(
        alignment: Alignment.bottomCenter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Elimina las esquinas redondeadas
        ),
        insetPadding: EdgeInsets.only(top: 50),
        backgroundColor: Colors.white,
        child: _isInitialized ? _buildContent() : _buildLoadingState());
  }

  // Widget para el estado de carga
  Widget _buildLoadingState() {
    return Container(
      color: StyleColor.turquoise,
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            "Cargando datos...",
            style: StylesApp(context)
                .textStyleBody14
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget para el estado de error
  Widget _buildErrorState(dynamic error) {
    return Container(
      color: StyleColor.turquoise,
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 50),
          SizedBox(height: 20),
          Text(
            "Error al cargar los datos",
            style: StylesApp(context)
                .textStyleBody14
                .copyWith(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            error.toString(),
            style: StylesApp(context)
                .textStyleBody12
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ButtonThemeWidget(
            buttonStyle: StylesApp(context).btnWidgetSmall,
            text: 'Reintentar',
            width: 120.0,
            height: 40.0,
            onPressed: () {
              // Inicializar valores de país, estado y ciudad si existen
              _initializeLocationValues().then((_) {
                setState(() {
                  _isInitialized = true;
                });
              });
            },
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
            child: SizedBox(
              child: CustomDropdownBottomWidget<AreaCode>(
                hintText: "código",
                items: listPrefixCode,
                onChanged: (ModelData? newValue) {
                  setState(() {
                    _editingData[index] = ModelData(
                      label: _editingData[index].label,
                      clave: _editingData[index].clave,
                      value:
                          '${newValue?.value} ${_editingData[index].value.split(' ')[1]}',
                      showLabel: _editingData[index].showLabel,
                    );
                  });
                },
                selectedItem: item.value.isNotEmpty
                    ? item.value.contains(' ') &&
                            item.value.split(' ').length > 1 &&
                            item.value.split(' ')[0].isNotEmpty
                        ? listPrefixCode.firstWhere((element) =>
                            element.value == item.value.split(' ')[0])
                        : null
                    : null,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              inputFormatters: [
                maskFormatterTel, // Permite solo números
              ],
              controller: _controllers[index],
              keyboardType: TextInputType.phone,
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
                  .textStyleBody12
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
                value: newValue!.label,
                clave: _editingData[index].clave,
                showLabel: _editingData[index].showLabel,
              );
            });
          },
          selectedItem: item.value.isNotEmpty
              ? optionsSex.firstWhere((element) =>
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
          if (kDebugMode) {
            print(value);
          }
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
    } else if (item.label == 'País') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: CustomDropdownBottomWidget(
          hintText: "Seleccione un país",
          items: dropDownList,
          onChanged: (ModelData? newValue) async {
            setState(() {
              _editingData[index] = ModelData(
                label: _editingData[index].label,
                value: newValue!.label,
                clave: _editingData[index].clave,
                showLabel: _editingData[index].showLabel,
              );
            });
            await _loadStates(newValue!.value, null, null, null);
          },
          selectedItem: item.value.isNotEmpty
              ? dropDownList.firstWhere(
                  (element) => element.label == item.value,
                  orElse: null)
              : null,
        ),
      );
    } else if (item.label == 'Estado') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: CustomDropdownBottomWidget(
          hintText: "Seleccione un Estado",
          items: _statesList,
          onChanged: (ModelData? newValue) async {
            setState(() {
              _editingData[index] = ModelData<StateModel>(
                label: _editingData[index].label,
                value: newValue!.label,
                clave: _editingData[index].clave,
                showLabel: _editingData[index].showLabel,
                originalData: StateModel.fromJson(newValue.originalData),
              );
            });
            await _loadCities(newValue!.value, null, null, null);
          },
          selectedItem: item.value.isNotEmpty && _statesList.isNotEmpty
              ? _statesList.firstWhere((element) => element.label == item.value,
                  orElse: null)
              : null,
        ),
      );
    } else if (item.label == 'Ciudad') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: CustomDropdownBottomWidget(
          hintText: "Seleccione una Ciudad",
          items: _citiesList,
          onChanged: (ModelData? newValue) {
            setState(() {
              _editingData[index] = ModelData<CityModel>(
                label: _editingData[index].label,
                value: newValue!.label,
                clave: _editingData[index].clave,
                showLabel: _editingData[index].showLabel,
                originalData: CityModel.fromJson(newValue!.originalData),
              );
            });
          },
          selectedItem: item.value.isNotEmpty && _citiesList.isNotEmpty
              ? _citiesList.firstWhere((element) => element.label == item.value,
                  orElse: null)
              : null,
        ),
      );
    } else if (item.label == 'Iglesia') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: CustomDropdownBottomWidget(
          items: optionsChurches,
          hintText: "Seleccione una Iglesia",
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

  Future<void> _initializeLocationValues() async {
    setState(() {});
    final catalogueProvider =
        Provider.of<CatalogueProvider>(context, listen: false);

    // Buscar país si existe en los datos
    final countryItem = _editingData.firstWhere(
      (item) => item.label == 'País',
      orElse: () => ModelData(label: '', value: '', clave: ''),
    );

    if (countryItem.value.isNotEmpty) {
      final country = catalogueProvider.allCountries.firstWhere(
        (c) => c.name == countryItem.value,
        orElse: () => Country(id: '', name: '', countryCode: null),
      );
      if (country.id.isNotEmpty) {
        _selectedCountryId = country.id;
        await _loadStates(country.id, null, null, null);
      }
    }

    // Buscar estado si existe en los datos
    final stateItem = _editingData.firstWhere(
      (item) => item.label == 'Estado',
      orElse: () => ModelData(label: '', value: '', clave: ''),
    );

    if (stateItem.value.isNotEmpty && _selectedCountryId != null) {
      final ModelData state = _statesList.firstWhere(
        (s) => s.label == stateItem.value,
        orElse: () => ModelData(value: '', label: ''),
      );
      if (state.value.isNotEmpty) {
        _selectedStateId = state.value;
        await _loadCities(state.value, null, null, null);
      }
    }
  }

  Future<void> _loadStates(
      String id, int? limit, int? offset, String? search) async {
    setState(() {
      _statesList.clear(); // Limpiar la lista antes de cargar nuevos datos
      _citiesList.clear(); // Limpiar la lista de ciudades también
    });
    try {
      final stateResponse = await getStatesByCountry(id, limit, offset, search);

      if (stateResponse.data != null) {
        setState(() {
          _statesList = stateResponse.data!
              .map<ModelData>((state) => ModelData(
                  label: state['name'],
                  value: state['id'],
                  originalData: state))
              .toList();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading states: $e");
      }
    }
  }

  Future<void> _loadCities(
      String id, int? limit, int? offset, String? search) async {
    setState(() {
      _citiesList.clear(); // Limpiar la lista de ciudades también
    });
    try {
      final cityResponse = await getCitiesByState(id, limit, offset, search);

      if (cityResponse.data != null) {
        setState(() {
          _citiesList = cityResponse.data!
              .map<ModelData>((city) => ModelData(
                  value: city['id'], label: city['name'], originalData: city))
              .toList();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading City: $e");
      }
    }
  }

  Widget _buildContent() {
    final catalogueProvider =
        Provider.of<CatalogueProvider>(context, listen: false);

    final List<ModelData> dropDownList = catalogueProvider.allCountries
        .map((country) => ModelData(value: country.id, label: country.name))
        .cast<ModelData>()
        .toList();
    final List<ModelData> prefixCode = catalogueProvider.allAreasCode
        .map((areaCode) => ModelData(value: areaCode.id, label: areaCode.code))
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

    return Stack(
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
                            width: 150.0,
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
    );
  }
}
