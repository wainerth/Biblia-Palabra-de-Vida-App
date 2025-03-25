import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BibleScreen extends StatelessWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/elipsisTopColor.png"),
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
                        height: 35.0,
                        width: 35.0,
                        decoration: BoxDecoration(
                            color: Color(0XFFFD8C43),
                            borderRadius: BorderRadius.circular(35.0)),
                        child: IconButton(
                            constraints: BoxConstraints(maxHeight: 35.0),
                            padding: EdgeInsets.all(0),
                            iconSize: 35.0,
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 35.0,
                            ))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: ButtonThemeWidget(
                          text: "RVR 1960",
                          buttonStyle: StylesApp(context).btnWidgetSmall,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                List<ModelData> bibleVersions = [
                                  ModelData(label: 'RVR 1960', value: 'Reina-Valera 1960'),
                                  ModelData(label: 'NVI', value: 'Nueva Versión Internacional'),
                                  ModelData(label: 'LBLA', value: 'La Biblia de las Américas'),
                                  ModelData(label: 'DHH', value: 'Dios Habla Hoy'),
                                  ModelData(label: 'TLA', value: 'Traducción en Lenguaje Actual'),
                                  ModelData(label: 'NBD', value: 'Nueva Biblia de los Hispanos'),
                                  ModelData(label: 'PDT', value: 'Palabra de Dios para Todos'),
                                ];

                                return Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10.0),
                                      CustomDropdownBottomWidget<ModelData>(
                                        hintText: "Seleccione una versión",
                                        items: bibleVersions,
                                        onChanged: (ModelData? newValue) {
                                          // Handle the change
                                        },
                                        selectedItem: bibleVersions[0],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "S. juan",
                          style: StylesApp(context)
                              .textStyleTitleWithe
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "22",
                          style: StylesApp(context)
                              .textStyleTitleWithe
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 15,
                      child: Column(
                        children: [
                          IconButton(
                            constraints: BoxConstraints(maxHeight: 35.0),
                            padding: EdgeInsets.all(0),
                            iconSize: 35.0,
                            color: Colors.white,
                            onPressed: () {},
                            icon: Icon(
                              Icons.volume_up_outlined,
                              size: 35.0,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Text("Página de La biblia"),
          ],
        ),
      ),
    );
  }
}
