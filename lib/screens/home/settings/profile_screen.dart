import 'dart:io';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/button_theme_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String avatarImg = 'assets/avatar.png';

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

  ImageProvider _getImageProvider() {
    if (avatarImg.startsWith('assets/')) {
      return AssetImage(avatarImg);
    } else {
      return FileImage(File(avatarImg));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ModelData> progressData = [
      ModelData(label: "Registro", value: "01/07/2024"),
      ModelData(label: "Racha", value: "120 días"),
      ModelData(label: "Energía", value: "545"),
      ModelData(label: "Cursos Completados", value: "4"),
    ];
    List<ModelData> personalData = [
      ModelData(label: "", value: "Robinson Manuel Garces Rodriguez"),
      ModelData(label: "Sexo", value: "Masculino"),
      ModelData(label: "Fecha nac", value: "01/07/1980"),
      ModelData(label: "", value: "Bautizado"),
    ];
    List<ModelData> contactDetails = [
      ModelData(label: "", value: "robinsongarces@gmail.com"),
      ModelData(label: "Tel.:", value: "+598-9514056"),
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
                _headerDetails(),
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
                  onPressed: (){
                    Navigator.popAndPushNamed(context,'/layoutPage');
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

  _headerDetails() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/elipsisTop.png"),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 15,
            child: Container(
                height: 35.sp,
                width: 35.sp,
                decoration: BoxDecoration(
                    color: Color(0XFFFD8C43),
                    borderRadius: BorderRadius.circular(35.sp)),
                child: IconButton(
                    constraints: BoxConstraints(maxHeight: 35.0),
                    padding: EdgeInsets.all(0),
                    iconSize: 35.sp,
                    color: Colors.white,
                    onPressed: () {
                      // Navigator.pushNamed(context, "/layoutPage");
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35.sp,
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: _selectImage,
                child: Center(
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: 160, minHeight: 160),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(160),
                              border: Border.all(
                                  width: 6.0, color: Color(0XFF12CBC4))),
                            child: ClipOval(
                            child: Image(
                              image: _getImageProvider(),
                              fit: BoxFit.cover,
                              height: 160,
                              width: 160,
                              alignment: Alignment.topCenter,
                            ),
                            ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          right: 0,
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Color(0XFF12CBC4),
                                borderRadius: BorderRadius.circular(40)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                "Robinson",
                style: StylesApp(context).textStyleTitleOrange,
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  Image.asset("assets/kawaii_fire.png"),
                  Text(
                    "1000",
                    style: StylesApp(context)
                        .textStyleBody4
                        .copyWith(color: Color(0XFFFD8C43)),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class CardColumnWidget extends StatelessWidget {
  final String iconRight;
  final IconData iconLeft;
  final List data;
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
                          if(route != null){
                            Navigator.popAndPushNamed(context, route!);
                          } else {
                            if (kDebugMode) {
                              print("Mostramos modal");
                            }
                          }

                        },
                        icon: Icon(
                          iconLeft,
                          color: Colors.white,
                        ))),
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
