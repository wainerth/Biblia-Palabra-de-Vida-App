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
      ModelData(
          label: "Bautizo",
          value: getIsBaptized(
            dataUser!.isBaptized ?? false,
          ),
          showLabel: false,
          clave: "isBaptized"),
    ];
    List<ModelData> contactDetails = [
      ModelData(
        label: "Email",
        value: dataUser!.email!,
        showLabel: false,
      ),
      // ModelData(
      //     label: "Tel.",
      //     value: dataUser != null && dataUser!.profileAreaCode != null
      //         ? dataUser!.profileAreaCode!.id
      //         : '',
      //     clave: "profileAreaCode"),
      ModelData(
          label: "Tel.",
          value:
              "${dataUser != null && dataUser!.profileAreaCode != null ? dataUser!.profileAreaCode!.id : ''} ${dataUser!.phoneNumber ?? ''}",
          clave: "phoneNumber"),
    ];
    List<ModelData> locationData = [
      ModelData(
          label: "País",
          value: dataUser!.country?.country ?? '',
          clave: "country"),
      ModelData(
        label: "Ciudad",
        value: dataUser!.city ?? '',
        clave: "city",
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // _headerDetails(),
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
                // SizedBox(
                //   height: 40,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool verificarBase64(String cadenaBase64) {
    // 1. Verificar la longitud
    if (cadenaBase64.length % 4 != 0) {
      if (kDebugMode) {
        print("La cadena Base64 es incompleta (longitud incorrecta).");
      }
      return false;
    }

    // 2. Verificar caracteres de relleno
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

    // 3. Intentar decodificar
    try {
      base64Decode(cadenaBase64); // Intenta decodificar
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
    // Encuentra el item cuyo label sea 'Tel.'
    String areaCode = '';
    String phone = '';
    final encontrado = data.firstWhere(
      (item) => item.label == 'Tel.',
      orElse: () => ModelData(label: '', value: ''),
    );
    if (encontrado.value.isNotEmpty) {
      (areaCode, phone) = parsePhoneNumberSimple(context, encontrado.value);
    }
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
                                        ? data[i].label == 'Tel.'
                                            ? '$areaCode $phone'
                                            : data[i].value
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
                              return EditDetailDialogWidget(
                                data: data,
                                onSave: (List<ModelData> dta) async {
                                  LoadingService().showLoading(context);
                                  final userProvider =
                                      Provider.of<UserProvider>(context,
                                          listen: false);
                                  final catalogueProvider =
                                      Provider.of<CatalogueProvider>(context,
                                          listen: false);
                                  final user = userProvider.currentUser;
                                  // servicio de actualización
                                  final dataToSend = UpdateDataProfile(
                                    identifier: user?.identifier ?? '',
                                    name: user?.name ?? '',
                                    lastname: user?.lastname ?? '',
                                    birthdate: user?.birthdate ?? '',
                                    city: '',
                                    country: user?.country != null
                                        ? user!.country
                                        : null,
                                    gender: user?.gender ?? '',
                                    isBaptized: user?.isBaptized,
                                    profileAreaCode: user?.profileAreaCode,
                                    phoneNumber: user?.phoneNumber ?? '',
                                    church: user!.userChurch.isNotEmpty
                                        ? user.userChurch.where((ch) => ch.status == true).firstOrNull
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
                                      await userProvider
                                          .updateProfile(dataEnviar);
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
                                    final response =
                                        await userProvider.updateUserChurch(
                                            user.userId,
                                            dataEnviar.dataProfiles.church!.id,
                                            catalogueProvider.allChurches);

                                    if (response.error != null) {
                                      LoadingService().hideLoading();
                                      await showCustomDialog(
                                        context,
                                        message: response.error!,
                                        dialogType: DialogType.error,
                                      );
                                    }
                                  }

                                  Navigator.pop(context);
                                  LoadingService().hideLoading();
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
