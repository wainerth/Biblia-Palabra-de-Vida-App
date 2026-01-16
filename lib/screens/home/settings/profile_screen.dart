import 'dart:convert';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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
      String dataUrl = '';
      if (fileSizeInMegabytes <= 5) {
        List<int> imageBytes = await imageFile.readAsBytes();

        String base64Image = base64Encode(imageBytes);
        verificarBase64(base64Image);
        final mimeType = lookupMimeType(imageFile.path); // Obtiene el tipo MIME

        if (mimeType != null) {
          dataUrl = "data:$mimeType;base64,$base64Image";

          if (kDebugMode) {
            print(dataUrl);
          } // Imprime la Data URL para pegarla en el navegador
        } else {
          if (kDebugMode) {
            print("No se pudo determinar el tipo MIME de la imagen.");
          }
        }
        setState(() {
          avatarImg = pickedFile.path;
        });
        LoadingService().showLoading(context);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final ResponseData responseUpdateAvatar =
            await userProvider.updateAvatarUser(dataUser!.userId, dataUrl);
        if (responseUpdateAvatar.error != null) {
          LoadingService().hideLoading();
          await showCustomDialog(
            context,
            message: responseUpdateAvatar.error!,
            dialogType: DialogType.error,
          );
          return;
        }
        LoadingService().hideLoading();
      } else {
        if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    dataUser = userProvider.currentUser;
    List<ModelData> optionsSex = [
      ModelData(value: 'M', label: 'Masculino'),
      ModelData(value: 'F', label: 'Femenino')
    ];

    final String userGender = (dataUser!.gender != null &&
            dataUser!.gender!.isNotEmpty)
        ? optionsSex.firstWhere((sex) => sex.value == dataUser!.gender).label
        : '';
    List<ModelData> progressData = [
      ModelData(
        label: "Registro",
        value: dataUser!.createdAt.isNotEmpty
            ? getFormattedDate(int.parse(dataUser!.createdAt))
            : "",
      ),
      ModelData(
          label: "Racha",
          value: "${dataUser!.streakDaysCount} días",
          clave: "streakDaysCount"),
      ModelData(
          label: "Energía",
          value: "${dataUser!.energyPoints}",
          clave: "expTotalUser"),
      ModelData(
          label: "Cursos Completados", value: "${dataUser!.completedCourse}"),
    ];
    List<ModelData> personalData = [
      ModelData(
          label: "Nombre",
          value: dataUser!.name,
          showLabel: false,
          clave: "name"),
      ModelData(
          label: "Apellido",
          value: "${dataUser?.lastname}",
          showLabel: false,
          clave: "lastname"),
      ModelData(
        label: "Sexo",
        value: userGender,
        clave: "gender",
      ),
      ModelData(
        label: "Fecha nac",
        value: "${dataUser!.birthdate}",
        clave: "birthdate",
      ),
    ];
    List<ModelData> contactDetails = [
      ModelData(
        label: "Email",
        value: dataUser!.email!,
        showLabel: false,
      ),
      ModelData(
        label: "Tel.",
        value:
            "${dataUser != null && dataUser!.profileAreaCode != null ? dataUser!.profileAreaCode!.id : ''} ${dataUser!.phoneNumber ?? ''}",
        clave: "phoneNumber",
        originalData: dataUser?.profileAreaCode,
      ),
    ];
    List<ModelData> locationData = [
      ModelData(
          label: "País",
          value: dataUser!.country?.name ?? '',
          clave: "country",
          originalData: dataUser!.country),
      ModelData(
        label: "Estado",
        value: dataUser!.state?.name ?? '',
        clave: "state",
        originalData: dataUser!.state,
      ),
      ModelData(
        label: "Ciudad",
        value: dataUser!.city?.name ?? '',
        clave: "city",
        originalData: dataUser!.city,
      ),
      ModelData(
        label: "Iglesia",
        clave: 'church',
        value: getChurchActive(dataUser!.userChurch) != null
            ? getChurchActive(dataUser!.userChurch)!.churchName!
            : '',
      )
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Color(0XFF12CBC4)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Si el ancho es mayor a 600px (tablet), usar diseño de dos columnas
              if (constraints.maxWidth > 600) {
                return _buildTabletLayout(
                  context,
                  progressData,
                  personalData,
                  contactDetails,
                  locationData,
                );
              } else {
                // Para móvil, mantener el diseño actual
                return _buildMobileLayout(
                  context,
                  progressData,
                  personalData,
                  contactDetails,
                  locationData,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // Diseño para móvil (igual al actual)
  Widget _buildMobileLayout(
    BuildContext context,
    List<ModelData> progressData,
    List<ModelData> personalData,
    List<ModelData> contactDetails,
    List<ModelData> locationData,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileHeader(
            avatarImg: dataUser!.imgProfileUser != null
                ? dataUser!.imgProfileUser!.urlImg
                : '',
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
            height: 10,
          ),
          CardColumnWidget(
            iconRight: "assets/User.png",
            data: personalData,
            iconLeft: Icons.edit,
          ),
          SizedBox(
            height: 10,
          ),
          CardColumnWidget(
            iconRight: "assets/Link.png",
            data: contactDetails,
            iconLeft: Icons.edit,
          ),
          SizedBox(
            height: 10,
          ),
          CardColumnWidget(
            iconRight: "assets/Map_pin.png",
            data: locationData,
            iconLeft: Icons.edit,
            divider: false,
          ),
          SizedBox(
            height: 20.0,
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
        ],
      ),
    );
  }

  // Diseño para tablet (dos columnas)
  Widget _buildTabletLayout(
    BuildContext context,
    List<ModelData> progressData,
    List<ModelData> personalData,
    List<ModelData> contactDetails,
    List<ModelData> locationData,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Columna Izquierda (40% del ancho)
            Expanded(
              flex: 4,
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header con avatar en columna izquierda
                    ProfileHeader(
                      avatarImg: dataUser!.imgProfileUser != null
                          ? dataUser!.imgProfileUser!.urlImg
                          : '',
                      onSelectImage: _selectImage,
                    ),

                    SizedBox(height: 20.0),

                    // Botón Volver en la columna izquierda
                    ButtonThemeWidget(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/layoutPage');
                      },
                      text: "Volver",
                      buttonStyle: StylesApp(context).btnWidgetSmall,
                      textStyle: StylesApp(context).textStyleBody7,
                      width: double.infinity,
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: 20.0),

            // Columna Derecha (60% del ancho)
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cards en una cuadrícula de 2 columnas
                    _buildCardsGrid(
                      context,
                      progressData,
                      personalData,
                      contactDetails,
                      locationData,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar las cards en cuadrícula (tablet)
  Widget _buildCardsGrid(
    BuildContext context,
    List<ModelData> progressData,
    List<ModelData> personalData,
    List<ModelData> contactDetails,
    List<ModelData> locationData,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.5, // Ajusta la proporción de las cards
      children: [
        // Card de Progreso
        _buildTabletCard(
          context,
          icon: "assets/Flag.png",
          title: "Progreso",
          data: progressData,
          iconLeft: Icons.trending_up,
          highlightLabel: true,
          route: "/detailsProgressPage",
          color: Color(0XFF12CBC4), // Color de fondo específico
        ),

        // Card de Datos Personales
        _buildTabletCard(
          context,
          icon: "assets/User.png",
          title: "Datos Personales",
          data: personalData,
          iconLeft: Icons.edit,
          color: Color(0XFF12CBC4),
        ),

        // Card de Contacto
        _buildTabletCard(
          context,
          icon: "assets/Link.png",
          title: "Contacto",
          data: contactDetails,
          iconLeft: Icons.edit,
          color: Color(0XFF12CBC4),
        ),

        // Card de Ubicación
        _buildTabletCard(
          context,
          icon: "assets/Map_pin.png",
          title: "Ubicación",
          data: locationData,
          iconLeft: Icons.edit,
          color: Color(0XFF12CBC4),
        ),
      ],
    );
  }

  // Widget para crear una card en tablet
  Widget _buildTabletCard(
    BuildContext context, {
    required String icon,
    required String title,
    required List<ModelData> data,
    required IconData iconLeft,
    bool highlightLabel = false,
    String? route,
    required Color color,
  }) {
    String areaCode = '';
    String phone = '';
    final encontrado = data.firstWhere(
      (item) => item.label == 'Tel.',
      orElse: () => ModelData(label: '', value: ''),
    );
    parsePhoneNumberSimple(context, encontrado.value).then((result) {
      areaCode = result.$1; // Para records: $1 es el primer elemento
      phone = result.$2; // $2 es el segundo elemento

      // Si necesitas actualizar la UI después
      if (mounted) {
        setState(() {});
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y icono
                Row(
                  children: [
                    Image.asset(
                      icon,
                      width: 24.0,
                      height: 24.0,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      title,
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: Colors.white,
                            // fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),

                SizedBox(height: 12.0),

                // Contenido de la card
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      if (!item.showLabel && item.value.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              if (item.label.isNotEmpty && item.showLabel)
                                TextSpan(
                                  text: "${item.label}: ",
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        // fontSize: 12.0,
                                      ),
                                ),
                              TextSpan(
                                text: item.value.isNotEmpty
                                    ? item.label == 'Tel.'
                                        ? '$areaCode $phone'
                                        : item.value
                                    : '',
                                style:
                                    StylesApp(context).textStyleBody12.copyWith(
                                          color: (highlightLabel &&
                                                  (index == 1 || index == 2))
                                              ? Colors.orange
                                              : Colors.white,
                                          // fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Botón de edición
          Positioned(
            top: 8.0,
            right: 8.0,
            child: GestureDetector(
              onTap: () {
                if (route != null) {
                  Navigator.popAndPushNamed(context, route);
                } else {
                  _openDialogEdit(data);
                }
              },
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(
                  iconLeft,
                  color: Colors.white,
                  size: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool verificarBase64(String cadenaBase64) {
    if (cadenaBase64.length % 4 != 0) {
      if (kDebugMode) {
        print("La cadena Base64 es incompleta (longitud incorrecta).");
      }
      return false;
    }

    if (cadenaBase64.contains("=")) {
      int indicePrimerRelleno = cadenaBase64.indexOf("=");
      if (indicePrimerRelleno != cadenaBase64.length - 1 &&
          indicePrimerRelleno != cadenaBase64.length - 2) {
        if (kDebugMode) {
          print("La cadena Base64 es inválida (relleno en medio).");
        }
        return false;
      }
    }

    try {
      base64Decode(cadenaBase64);
    } catch (error) {
      if (kDebugMode) {
        print("La cadena Base64 es inválida (error de decodificación): $error");
      }
      return false;
    }

    if (kDebugMode) {
      print("La cadena Base64 parece válida.");
    }
    return true;
  }

  void _openDialogEdit(List<ModelData> data) {
    showDialog(
        useSafeArea: true,
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return EditDetailDialogWidget(
            data: data,
            onSave: (List<ModelData> dta) async {
              LoadingService().showLoading(context);
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final catalogueProvider =
                  Provider.of<CatalogueProvider>(context, listen: false);
              final user = userProvider.currentUser;
              // servicio de actualización
              final dataToSend = UpdateDataProfile(
                identifier: user?.identifier ?? '',
                name: user?.name ?? '',
                lastname: user?.lastname ?? '',
                birthdate: user?.birthdate ?? '',
                country: user?.country != null ? user!.country : null,
                state: user?.state,
                city: user?.city,
                gender: user?.gender ?? '',
                isBaptized: user?.isBaptized,
                profileAreaCode: user?.profileAreaCode,
                phoneNumber: user?.phoneNumber ?? '',
                church: user!.userChurch.isNotEmpty
                    ? user.userChurch
                        .where((ch) => ch.status == true)
                        .firstOrNull
                    : null,
              );
              final UserProfile dataEnviar = UserProfile(
                  userId: user.userId,
                  dataProfiles: updateFromModelData(
                      context,
                      dataToSend,
                      dta,
                      catalogueProvider.allCountries,
                      catalogueProvider.allChurches));

              final responseUpdateProfile =
                  await userProvider.updateProfile(dataEnviar);
              if (responseUpdateProfile.error != null) {
                LoadingService().hideLoading();
                await showCustomDialog(
                  context,
                  message: responseUpdateProfile.error!,
                  dialogType: DialogType.error,
                );
                return;
              }
              if (dataEnviar.dataProfiles.church != null) {
                final response = await userProvider.updateUserChurch(
                    user.userId,
                    dataEnviar.dataProfiles.church!.id,
                    catalogueProvider.allChurches);

                if (response.error != null) {
                  LoadingService().hideLoading();
                  if (mounted) {
                    await showCustomDialog(
                      context,
                      message: response.error!,
                      dialogType: DialogType.error,
                    );
                  }
                }
              }

              Navigator.pop(context);
              LoadingService().hideLoading();
            },
          );
        });
  }
}

class CardColumnWidget extends StatefulWidget {
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
  State<CardColumnWidget> createState() => _CardColumnWidgetState();
}

class _CardColumnWidgetState extends State<CardColumnWidget> {
  @override
  Widget build(BuildContext context) {
    // Encuentra el item cuyo label sea 'Tel.'
    String areaCode = '';
    String phone = '';
    final encontrado = widget.data.firstWhere(
      (item) => item.label == 'Tel.',
      orElse: () => ModelData(label: '', value: ''),
    );
    parsePhoneNumberSimple(context, encontrado.value).then((result) {
      areaCode = result.$1; // Para records: $1 es el primer elemento
      phone = result.$2; // $2 es el segundo elemento
      if (mounted) {
        // Si necesitas actualizar la UI después
        setState(() {});
      }
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                        widget.iconRight,
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
                        for (var i = 0; i < widget.data.length; i++) ...[
                          if (widget.data[i].showLabel ||
                              widget.data[i].value.isNotEmpty)
                            Text.rich(
                              style: StylesApp(context).textStyleBodyWhite4,
                              TextSpan(
                                children: [
                                  if (widget.data[i].label.isNotEmpty)
                                    if (widget.data[i].showLabel)
                                      TextSpan(
                                          text: "${widget.data[i].label}: "),
                                  TextSpan(
                                    text: widget.data[i].value.isNotEmpty
                                        ? widget.data[i].label == 'Tel.'
                                            ? '$areaCode $phone'
                                            : widget.data[i].value
                                        : '',
                                    style: StylesApp(context)
                                        .textStyleBodyWhite4
                                        .copyWith(
                                          color: (widget.highlightLabel &&
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
                      if (widget.route != null) {
                        Navigator.popAndPushNamed(context, widget.route!);
                      } else {
                        // Abrir el diálogo de edición Tablet
                        _openDialogEdit(widget.data);
                      }
                    },
                    icon: Icon(
                      widget.iconLeft,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.divider)
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

  void _openDialogEdit(List<ModelData> data) {
    showDialog(
        useSafeArea: true,
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return EditDetailDialogWidget(
            data: data,
            onSave: (List<ModelData> dta) async {
              LoadingService().showLoading(context);
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final catalogueProvider =
                  Provider.of<CatalogueProvider>(context, listen: false);
              final user = userProvider.currentUser;
              // servicio de actualización
              final dataToSend = UpdateDataProfile(
                identifier: user?.identifier ?? '',
                name: user?.name ?? '',
                lastname: user?.lastname ?? '',
                birthdate: user?.birthdate ?? '',
                country: user?.country != null ? user!.country : null,
                state: user?.state,
                city: user?.city,
                gender: user?.gender ?? '',
                isBaptized: user?.isBaptized,
                profileAreaCode: user?.profileAreaCode,
                phoneNumber: user?.phoneNumber ?? '',
                church: user!.userChurch.isNotEmpty
                    ? user.userChurch
                        .where((ch) => ch.status == true)
                        .firstOrNull
                    : null,
              );
              final UserProfile dataEnviar = UserProfile(
                  userId: user.userId,
                  dataProfiles: updateFromModelData(
                      context,
                      dataToSend,
                      dta,
                      catalogueProvider.allCountries,
                      catalogueProvider.allChurches));

              final responseUpdateProfile =
                  await userProvider.updateProfile(dataEnviar);
              if (responseUpdateProfile.error != null) {
                LoadingService().hideLoading();
                await showCustomDialog(
                  context,
                  message: responseUpdateProfile.error!,
                  dialogType: DialogType.error,
                );
                return;
              }
              if (dataEnviar.dataProfiles.church != null) {
                final response = await userProvider.updateUserChurch(
                    user.userId,
                    dataEnviar.dataProfiles.church!.id,
                    catalogueProvider.allChurches);

                if (response.error != null) {
                  LoadingService().hideLoading();
                  if (mounted) {
                    await showCustomDialog(
                      context,
                      message: response.error!,
                      dialogType: DialogType.error,
                    );
                  }
                }
              }

              Navigator.pop(context);
              LoadingService().hideLoading();
            },
          );
        });
  }
}
