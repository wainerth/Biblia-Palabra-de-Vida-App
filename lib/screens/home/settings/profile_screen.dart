import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/audio_player_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final cardList = [
      // Replace with your actual asset paths and route names
      {
        'label': 'Aventura',
        'img': '/aventura.png',
        'route': '/introAventurePage',
      },
      {
        'label': 'La Biblia',
        'img': '/biblia.png',
        'route': '/bibliaPage',
      },
      {
        'label': 'Comunidad',
        'img': '/comunidad.png',
        'route': '/communityPage',
      },
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 26.0),
            _buildListCardSection(context, cardList),
            SizedBox(
              height: 12.0,
            ),
            _buildPositionSection(context),
            SizedBox(
              height: 12.0,
            ),
            _buildProverbsSection(context),
            SizedBox(
              height: 12.0,
            ),
            _buildStoriesSection(context),
            SizedBox(
              height: 12.0,
            ),
            _buildGridViewSection(context),
             SizedBox(
              height: 22.0,
            ),
            Container(
              constraints: BoxConstraints(minHeight: 60.0),
               margin: const EdgeInsets.symmetric(horizontal: 10.0),
               padding: EdgeInsets.symmetric(horizontal: 26.0),
              decoration: BoxDecoration(
                color: Color(0XFF5C9EDB),
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Libreria Cristiana",style: StylesApp(context).textStyleBody7,),
                  Image.asset('books.png',width: 72.0,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListCardSection(
      BuildContext context, List<Map<String, String>> cards) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards.map((card) => _buildCard(context, card)).toList(),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, String> card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context , card['route']!),
        child: Column(
          children: [
            Container(
              width: 90.0,
              height: 90.0,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                image: DecorationImage(
                  image: AssetImage(card['img']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              card['label']!,
              textAlign: TextAlign.center,
              style: StylesApp(context).textStyleBody4.copyWith(
                    color: const Color(0xFFFD8C43),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  _buildStoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Cuentos para reflexionar",
          style: StylesApp(context)
              .textStyleBody5
              .copyWith(color: Color(0xFFFE8D43)),
        ),
        AudioPlayerWidget(pathUrl: "reflexion2.mp3")
      ],
    );
  }

  _buildGridViewSection(BuildContext context) {
    return Wrap(
      spacing: 0.0,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 15.0),
          child: CardOptionsWidget(
            imageBackground: "/promesas.png",
            labelCard: "Promesas",
            gradientColors:[Color(0XFFA731EC), Color(0XFF620188)]
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 15.0),
          child: CardOptionsWidget(
            imageBackground: "/predicas.png",
            labelCard: "Prédicas",
gradientColors:[Color(0XFF1FEFEC), Color(0XFF0159A7)]
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 15.0),
          child: CardOptionsWidget(
            imageBackground: "/games.png",
            labelCard: "Juegos",
            gradientColors:[Color(0XFF3531F3), Color(0XFF040681)]
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 15.0),
          child: CardOptionsWidget(
            imageBackground: "/ranking.png",
            labelCard: "Ranking",
            gradientColors:[Color(0XFF58AC5F).withValues(alpha: 65), Color(0XFF2F6624).withValues(alpha: 63)]
          ),
        )
      ],
    );
  }
}

class CardOptionsWidget extends StatelessWidget {
  final String imageBackground;
  final String labelCard;
  final List<Color> gradientColors;
  const CardOptionsWidget({
    super.key,
    required this.imageBackground,
    required this.labelCard, required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 70.0, maxWidth: 170.0),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                imageBackground,
                fit: BoxFit.cover,
                height: 69,
              ),
            ),
            Positioned.fill(
              // Center the text horizontally and vertically within the Stack
              // top: 0,
              // left: 0,
              // right: 0,
              // bottom: 0,
              child: Center(
                child: Text(
                  labelCard,
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleBody7,
                ),
              ),
            ),
          ],
        ));
  }
}

_buildProverbsSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF12CBC4),
      borderRadius: BorderRadius.circular(8.0),
    ),
    // constraints: BoxConstraints( minHeight: 130.0),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
    width: MediaQuery.of(context).size.width,
    padding:
        const EdgeInsets.only(left: 7.0, right: 7.0, top: 6.0, bottom: 6.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: Text(
                "Proverbios 3:4",
                style: StylesApp(context).textStyleBody7.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                spacing: 10.0,
                children: [
                  Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(minHeight: 96.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Y hallarás gracia y buena opinión En los ojos de Dios y de los hombres.",
                    style: StylesApp(context)
                        .textStyleBody5
                        .copyWith(color: Colors.black, fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

_buildPositionSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF12CBC4),
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(left: 20.0, top: 6.0, bottom: 6.0),
    child: Column(
      children: [
        Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 59.0,
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: const AssetImage('/avatar.png'),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 153, minHeight: 20),
                      width: 153,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC7AA34),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Soldado de Cristo",
                          style: StylesApp(context)
                              .textStyleBody6
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Image.asset('/kawaii_fire.png'),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        "Robinson",
                        style: StylesApp(context)
                            .textStyleBody6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Const: 300 dias",
                        style: StylesApp(context)
                            .textStyleBody6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        " 9999 Lms.",
                        style: StylesApp(context)
                            .textStyleBody6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                )
              ],
            ),
            Positioned(
              right: 0,
              top: -8,
              child: Container(
                width: 40.0,
                height: 30.0,
                child: IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context,'/detailProfilePage');
                  },
                  icon: Icon(
                    Icons.fast_forward_outlined,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
