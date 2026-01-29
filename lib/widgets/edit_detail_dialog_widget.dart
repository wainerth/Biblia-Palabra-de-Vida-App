import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/services/country_search_service.dart';
import 'package:biblia_palabra_de_vida_app/services/phone_validator_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';
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
  late final CountrySearchService _countrySearchService;

  late List<ModelData> _editingData;
  final List<TextEditingController> _controllers = [];
  String? _selectedCountryId;
  List<ModelData> _statesList = [];
  List<ModelData> _citiesList = [];
  bool loadingState = false;
  bool loadingCity = false;
  bool _isInitialized = false;
  String? initialPhoneCode;

  // Variables para controlar la selección inicial
  String? _initialStateId;
  String? _initialStateName;
  String? _initialCityId;
  String? _initialCityName;
  bool _isLoadingLocation = false;
  bool _autoSelectStateAfterLoad = false;
  bool _autoSelectCityAfterLoad = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _countrySearchService = CountrySearchService();

    _editingData = List.from(widget.data);
    for (var item in _editingData) {
      if (item.label == 'Tel.') {
        initialPhoneCode = item.originalData?.code;
        _controllers.add(TextEditingController(
            text: item.value.isNotEmpty ? item.value.split(' ')[1] : ''));
      } else {
        _controllers.add(TextEditingController(text: item.value));
      }
    }

    // Inicializar valores de país, estado y ciudad si existen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocationValues().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
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
        borderRadius: BorderRadius.zero,
      ),
      insetPadding: EdgeInsets.only(top: 50),
      backgroundColor: Colors.white.withValues(alpha: 0.1),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isTablet(context) ? 600 : double.infinity,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: StyleColor.white,
            ),
            child: _isInitialized ? _buildContent() : _buildLoadingState(),
          ),
        ),
      ),
    );
  }

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
      return SizedBox(
        child: Stack(
          children: [
            IntlPhoneFieldWithValidation(
              controller: _controllers[index],
              initialPhoneCode: initialPhoneCode,
              validator: (PhoneNumber? phone) {
                if (phone == null || phone.number.isEmpty) {
                  return 'El número de teléfono es obligatorio';
                }
                return PhoneValidatorService.validatePhoneNumber(phone);
              },
              onChanged: (phone) async {
                try {
                  AreaCode? code = await AreaCodeSearchService()
                      .getCodeAreaByCode(phone.countryCode);
                  _editingData[index] = ModelData(
                      label: _editingData[index].label,
                      clave: _editingData[index].clave,
                      value:
                          '${code?.id} ${phone.number.replaceAll(RegExp(r'[^\d]+'), '')}',
                      showLabel: _editingData[index].showLabel,
                      originalData: code);
                } catch (e) {
                  if (kDebugMode) {
                    print(
                        'Código de Area no encontrado para: ${phone.countryCode}');
                  }
                }
              },
            ),
            Positioned(
              right: -10,
              child: Tooltip(
                message: 'El número de operador no debe iniciar con 0',
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Información'),
                        content: Text(
                            style: StylesApp(context)
                                .textStyleBody14
                                .copyWith(color: StyleColor.black),
                            'El número de operador no debe iniciar con 0'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
          if (kDebugMode) print(value);
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
          label: "Bautizado:",
          value: item.value == 'Bautizado',
          onChanged: (newValue) {
            setState(() {
              _editingData[index] = ModelData(
                label: _editingData[index].label,
                value: newValue! ? "Bautizado" : "No Bautizado",
                clave: _editingData[index].clave,
                showLabel: _editingData[index].showLabel,
              );
            });
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
        child: OptimizedSearchableDropdown(
          hintText: "Seleccione un país",
          defaultValueId: _selectedCountryId,
          selectedItem: null,
          onChanged: (ModelData? newValue) async {
            if (newValue != null) {
              setState(() {
                _editingData[index] = ModelData(
                  label: _editingData[index].label,
                  value: newValue.label,
                  clave: _editingData[index].clave,
                  showLabel: _editingData[index].showLabel,
                  originalData: newValue.originalData,
                );
                _selectedCountryId = newValue.value;
              });

              // Limpiar estados y ciudades anteriores
              setState(() {
                _statesList.clear();
                _citiesList.clear();
              });

              // Si hay estado inicial guardado, activar auto selección
              if (_initialStateId != null && _initialStateName != null) {
                _autoSelectStateAfterLoad = true;
              }

              await _loadStates(newValue.value, null, null, null);
            } else {
              setState(() {
                _statesList.clear();
                _citiesList.clear();
                _selectedCountryId = null;
                _initialStateId = null;
                _initialStateName = null;
                _initialCityId = null;
                _initialCityName = null;
              });
            }
          },
          searchFunction: _searchCountries,
          fetchItemById: (id) => CountrySearchService().getCountryById(id),
          showClearButton: true,
          border: true,
          leadingIcon: Icon(
            Icons.location_on,
            color: StyleColor.cosmicBlue,
            size: 20,
          ),
        ),
      );
    } else if (item.label == 'Estado') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: Stack(
          children: [
            CustomDropdownBottomWidget(
              hintText: "Seleccione un Estado",
              items: _statesList,
              onChanged: (ModelData? newValue) async {
                if (newValue != null) {
                  setState(() {
                    _editingData[index] = ModelData<StateModel>(
                      label: _editingData[index].label,
                      value: newValue.label,
                      clave: _editingData[index].clave,
                      showLabel: _editingData[index].showLabel,
                      originalData: StateModel.fromJson(newValue.originalData),
                    );
                    _initialStateId = newValue.value;
                    _initialStateName = newValue.label;
                  });

                  // Si hay ciudad inicial guardada, activar auto selección
                  if (_initialCityId != null && _initialCityName != null) {
                    _autoSelectCityAfterLoad = true;
                  }

                  await _loadCities(newValue.value, null, null, null);
                } else {
                  setState(() {
                    _citiesList.clear();
                    _initialStateId = null;
                    _initialStateName = null;
                    _initialCityId = null;
                    _initialCityName = null;
                  });
                }
              },
              selectedItem: _findSelectedState(item),
              leadingIcon: Icon(
                Icons.location_city,
                color: StyleColor.cosmicBlue,
                size: 20,
              ),
            ),
            if (loadingState)
              Positioned(
                right: 0,
                bottom: 5,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(StyleColor.turquoise),
                ),
              ),
          ],
        ),
      );
    } else if (item.label == 'Ciudad') {
      return Container(
        constraints: BoxConstraints(
          minWidth: 160.0,
          maxWidth: StylesApp(context).sizeTextFormField.width,
        ),
        child: Stack(
          children: [
            CustomDropdownBottomWidget(
              hintText: "Seleccione una Ciudad",
              items: _citiesList,
              onChanged: (ModelData? newValue) {
                if (newValue != null) {
                  setState(() {
                    _editingData[index] = ModelData<CityModel>(
                      label: _editingData[index].label,
                      value: newValue.label,
                      clave: _editingData[index].clave,
                      showLabel: _editingData[index].showLabel,
                      originalData: CityModel.fromJson(newValue.originalData),
                    );
                    _initialCityId = newValue.value;
                    _initialCityName = newValue.label;
                  });
                } else {
                  setState(() {
                    _initialCityId = null;
                    _initialCityName = null;
                  });
                }
              },
              selectedItem: _findSelectedCity(item),
              leadingIcon: Icon(
                Icons.location_city,
                color: StyleColor.cosmicBlue,
                size: 20,
              ),
            ),
            if (loadingCity)
              Positioned(
                right: 0,
                bottom: 5,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(StyleColor.turquoise),
                ),
              ),
          ],
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
        style: StylesApp(context)
            .textStyleBody14
            .copyWith(color: StyleColor.black),
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
    if (!mounted) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // 1. Buscar país si existe en los datos
      final countryItem = _editingData.firstWhere(
        (item) => item.label == 'País',
        orElse: () => ModelData(label: '', value: '', clave: ''),
      );

      if (countryItem.value.isNotEmpty && countryItem.originalData != null) {
        // Extraer ID del país
        dynamic originalData = countryItem.originalData;
        if (originalData is Country) {
          _selectedCountryId = originalData.id;
        } else if (originalData is Map<String, dynamic>) {
          _selectedCountryId = originalData['id']?.toString();
        } else if (originalData is String) {
          _selectedCountryId = originalData;
        }

        // Guardar datos de estado si existen
        final stateItem = _editingData.firstWhere(
          (item) => item.label == 'Estado',
          orElse: () => ModelData(label: '', value: '', clave: ''),
        );

        if (stateItem.value.isNotEmpty) {
          _initialStateName = stateItem.value;
          if (stateItem.originalData != null) {
            dynamic stateOriginalData = stateItem.originalData;
            if (stateOriginalData is StateModel) {
              _initialStateId = stateOriginalData.id.toString();
            } else if (stateOriginalData is Map<String, dynamic>) {
              _initialStateId = stateOriginalData['id']?.toString();
            }
          }
        }

        // Guardar datos de ciudad si existen
        final cityItem = _editingData.firstWhere(
          (item) => item.label == 'Ciudad',
          orElse: () => ModelData(label: '', value: '', clave: ''),
        );

        if (cityItem.value.isNotEmpty) {
          _initialCityName = cityItem.value;
          if (cityItem.originalData != null) {
            dynamic cityOriginalData = cityItem.originalData;
            if (cityOriginalData is CityModel) {
              _initialCityId = cityOriginalData.id.toString();
            } else if (cityOriginalData is Map<String, dynamic>) {
              _initialCityId = cityOriginalData['id']?.toString();
            }
          }
        }

        // Si hay país, cargar sus estados
        if (_selectedCountryId != null && _selectedCountryId!.isNotEmpty) {
          _autoSelectStateAfterLoad = _initialStateId != null;
          await _loadStates(_selectedCountryId!, null, null, null);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error inicializando valores de ubicación: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _loadStates(
      String id, int? limit, int? offset, String? search) async {
    if (!mounted) return;

    setState(() {
      loadingState = true;
      _statesList.clear();
      _citiesList.clear();
    });

    try {
      final stateResponse = await getStatesByCountry(id, limit, offset, search);

      if (stateResponse.data != null && mounted) {
        setState(() {
          _statesList = stateResponse.data!
              .map<ModelData>((state) => ModelData(
                  label: state['name'],
                  value: state['id'].toString(),
                  originalData: state))
              .toList();
        });

        // Después de cargar estados, si hay que auto seleccionar
        if (_autoSelectStateAfterLoad && _initialStateId != null) {
          _autoSelectStateAfterLoad = false;

          final stateToSelect = _findStateById(_initialStateId!);
          if (stateToSelect != null) {
            // Encontrar el índice del estado en _editingData
            final stateIndex =
                _editingData.indexWhere((item) => item.label == 'Estado');
            if (stateIndex != -1) {
              // Actualizar _editingData con el estado seleccionado
              setState(() {
                _editingData[stateIndex] = ModelData<StateModel>(
                  label: _editingData[stateIndex].label,
                  value: stateToSelect.label,
                  clave: _editingData[stateIndex].clave,
                  showLabel: _editingData[stateIndex].showLabel,
                  originalData: StateModel.fromJson(stateToSelect.originalData),
                );
                _initialStateId = stateToSelect.value;
                _initialStateName = stateToSelect.label;
              });

              // Cargar ciudades del estado seleccionado
              _autoSelectCityAfterLoad = _initialCityId != null;
              await _loadCities(_initialStateId!, null, null, null);
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error cargando estados: $e");
      }
    } finally {
      if (mounted) {
        setState(() => loadingState = false);
      }
    }
  }

  Future<void> _loadCities(
      String id, int? limit, int? offset, String? search) async {
    if (!mounted) return;

    setState(() {
      loadingCity = true;
      _citiesList.clear();
    });

    try {
      final cityResponse = await getCitiesByState(id, limit, offset, search);

      if (cityResponse.data != null && mounted) {
        setState(() {
          _citiesList = cityResponse.data!
              .map<ModelData>((city) => ModelData(
                  value: city['id'].toString(),
                  label: city['name'],
                  originalData: city))
              .toList();
        });

        // Después de cargar ciudades, si hay que auto seleccionar
        if (_autoSelectCityAfterLoad && _initialCityId != null) {
          _autoSelectCityAfterLoad = false;

          final cityToSelect = _findCityById(_initialCityId!);
          if (cityToSelect != null) {
            // Encontrar el índice de la ciudad en _editingData
            final cityIndex =
                _editingData.indexWhere((item) => item.label == 'Ciudad');
            if (cityIndex != -1) {
              setState(() {
                _editingData[cityIndex] = ModelData<CityModel>(
                  label: _editingData[cityIndex].label,
                  value: cityToSelect.label,
                  clave: _editingData[cityIndex].clave,
                  showLabel: _editingData[cityIndex].showLabel,
                  originalData: CityModel.fromJson(cityToSelect.originalData),
                );
                _initialCityId = cityToSelect.value;
                _initialCityName = cityToSelect.label;
              });
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error cargando ciudades: $e");
      }
    } finally {
      if (mounted) {
        setState(() => loadingCity = false);
      }
    }
  }

  // Métodos auxiliares para buscar
  ModelData? _findStateById(String id) {
    if (_statesList.isEmpty) return null;
    try {
      return _statesList.firstWhere((state) => state.value == id);
    } catch (e) {
      return null;
    }
  }

  ModelData? _findCityById(String id) {
    if (_citiesList.isEmpty) return null;
    try {
      return _citiesList.firstWhere((city) => city.value == id);
    } catch (e) {
      return null;
    }
  }

  ModelData? _findSelectedState(ModelData item) {
    if (item.value.isEmpty || _statesList.isEmpty) return null;

    // Primero buscar por ID si lo tenemos
    if (_initialStateId != null) {
      final state = _findStateById(_initialStateId!);
      if (state != null) return state;
    }

    // Buscar por nombre
    try {
      return _statesList.firstWhere((element) => element.label == item.value);
    } catch (e) {
      return null;
    }
  }

  ModelData? _findSelectedCity(ModelData item) {
    if (item.value.isEmpty || _citiesList.isEmpty) return null;

    // Primero buscar por ID si lo tenemos
    if (_initialCityId != null) {
      final city = _findCityById(_initialCityId!);
      if (city != null) return city;
    }

    // Buscar por nombre
    try {
      return _citiesList.firstWhere((element) => element.label == item.value);
    } catch (e) {
      return null;
    }
  }

  Widget _buildContent() {
    // Mostrar loading si aún se está cargando la ubicación
    if (_isLoadingLocation) {
      return _buildLoadingState();
    }

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
                SizedBox(height: 30),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    child: Form(
                      key: _formKey,
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
                                      index,
                                      dropDownList,
                                      prefixCode,
                                      optionsSex,
                                      listChurches,
                                      catalogueProvider.allChurches,
                                      catalogueProvider.allCountries,
                                    ),
                                    SizedBox(height: 12.0)
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
                                _saveData();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_editingData);
    } else {
      showSnackBar('Por favor, corrija los errores en el formulario',
          type: SnackBarType.error);
    }
  }

  Future<PaginationModel<ModelData>> _searchCountries(
      String query, int page) async {
    return _countrySearchService.searchCountries(
      query: query,
      page: page,
      limit: 15,
    );
  }
}
