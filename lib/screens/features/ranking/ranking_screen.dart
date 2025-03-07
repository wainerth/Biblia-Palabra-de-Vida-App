import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<League> ranking = [
    League(
      id: "1",
      name: "Principiante",
      minMembers: 1,
      maxMembers: 10,
      img: ImageDetails(urlImg: "assets/league1.png"),
      color: "64E8FC",
      status: "active",
    ),
    League(
      id: "2",
      name: "Creyente",
      minMembers: 1,
      maxMembers: 10,
      img: ImageDetails(urlImg: "assets/league1.png"),
      color: "602D18",
      status: "active",
    ),
    League(
      id: "3",
      name: "Seguidor",
      minMembers: 1,
      maxMembers: 10,
      img: ImageDetails(urlImg: "assets/league1.png"),
      color: "D67A56",
      status: "active",
    ),
    League(
      id: "4",
      name: "Discípulo",
      minMembers: 1,
      maxMembers: 10,
      img: ImageDetails(urlImg: "assets/league1.png"),
      color: "12CBC4",
      status: "active",
    ),
    League(
      id: "5",
      name: "Soldado",
      minMembers: 1,
      maxMembers: 10,
      img: ImageDetails(urlImg: "assets/league1.png"),
      color: "64E8FC",
      status: "active",
    ),
    League(
      id: "6",
      name: "Guerrero",
      minMembers: 1,
      maxMembers: 10,
      img: ImageDetails(urlImg: "assets/league1.png"),
      color: "64E8FC",
      status: "active",
    ),
    League(
      id: "7",
      name: "Siervo",
      minMembers: 1,
      maxMembers: 10,
      img: ImageDetails(urlImg: "assets/league1.png"),
      color: "64E8FC",
      status: "active",
    ),
    League(
      id: "8",
      name: "Lider",
      minMembers: 1,
      maxMembers: 10,
      img: ImageDetails(urlImg: "assets/league1.png"),
      color: "64E8FC",
      status: "active",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ranking.length,
      child: RankingScreenView(ranking: ranking),
    );
  }
}

class RankingScreenView extends StatelessWidget {
  final List<League> ranking;
  const RankingScreenView({super.key, required this.ranking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleColor.turquoise,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // body
              Container(
                child: Column(
                  children: [
                    // Pestañas
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        indicatorPadding: EdgeInsets.all(0),
                        indicatorSize: TabBarIndicatorSize.label,
                        isScrollable: true,
                        tabs: ranking
                            .map(
                              (league) => Tab(
                                height: 80,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(
                                                "0xFF${league.color}"))
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(int.parse(
                                                "0xFF${league.color}")),
                                            spreadRadius: 1,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        height: 38,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Color(
                                              int.parse("0xFF${league.color}")),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.5),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(league.img.urlImg),
                                      ),
                                    ),
                                    if (DefaultTabController.of(context)
                                            .index ==
                                        ranking.indexOf(league))
                                      
                                      Container(
                                        width: 30,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    Text(
                                      league.name,
                                      style: StylesApp(context)
                                          .textStyleBody14
                                          .copyWith(
                                            color:
                                                DefaultTabController.of(context)
                                                            .index ==
                                                        ranking.indexOf(league)
                                                    ? StyleColor.turquoise
                                                    : StyleColor.orange,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, top: 0, right: 8),
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TabBarView(
                        children: ranking
                            .map((league) => _buildRankingList())
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 15, // Ejemplo: 10 usuarios en el ranking
      itemBuilder: (context, index) {
        if (index == 5) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward_rounded, color: Colors.green),
                Text(
                  'Zona de Ascenso',
                  style: StylesApp(context)
                      .textStyleBody14
                      .copyWith(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.arrow_upward_rounded, color: Colors.green),
              ],
            ),
          );
        } else if (index == 15) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.arrow_downward_rounded, color: Colors.red),
                Text(
                  'Zona de Descenso',
                  style: StylesApp(context)
                      .textStyleBody14
                      .copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.arrow_downward_rounded, color: Colors.red),
              ],
            ),
          );
        } else {
          String mono = '';
          if (index == 0) {
            mono = 'assets/position1.png';
          } else if (index == 1) {
            mono = 'assets/position2.png';
          } else if (index == 2) {
            mono = 'assets/position3.png';
          }
          Color color;
          if (index < 5) {
            color = Colors.green;
          } else if (index > 15) {
            color = Colors.red;
          } else {
            color = Colors.black;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 45,
                            height: 45,
                            child: Center(
                              child: Text("${index + 1}",
                                  style: StylesApp(context)
                                      .textStyleBody20
                                      .copyWith(color: color)),
                            ),
                          ),
                        ),
                        if (index < 3)
                          Image.asset(
                            mono,
                            height: 45,
                            fit: BoxFit.fill,
                          ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          'assets/avatar.png'), // Reemplaza con la imagen del usuario
                    ),
                    Text(
                      'Robinson',
                      style: StylesApp(context)
                          .textStyleBody20
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),

                Text(
                  'exp ${500 - index * 10}',
                  style: StylesApp(context)
                      .textStyleBody14
                      .copyWith(color: Colors.black),
                ), // Reemplaza con el exp del usuario
              ],
            ),
          );

          // ListTile(
          //   leading: CircleAvatar(
          //     backgroundImage: AssetImage(
          //         'assets/avatar.png'), // Reemplaza con la imagen del usuario
          //   ),
          //   title: Text(
          //       'Usuario ${index + 1}'), // Reemplaza con el nombre del usuario
          //   subtitle: Text('Posición: ${index + 1}'),
          //   trailing: Text(
          //       'exp ${500 - index * 10}'), // Reemplaza con el exp del usuario
          // );
        }
      },
    );
  }
}
