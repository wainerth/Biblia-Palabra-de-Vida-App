import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AventureScreen extends StatefulWidget {
  const AventureScreen({super.key});

  @override
  State<AventureScreen> createState() => _AventureScreenState();
}

class _AventureScreenState extends State<AventureScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;
  bool hasSeenIntro = true;
  List<CourseModel> courses = [];
  @override
  void initState() {
    _generateData();
    super.initState();
  }

  void _generateData() {
    courses = [
      CourseModel(
          color: "3ae4e4",
          id: "1",
          status: 1,
          title: "Antiguo Testamento",
          img: "/newTestament.png"),
      CourseModel(
          color: "2eade4",
          id: "2",
          status: 1,
          title: "Nuevo Testamento",
          img: "/newTestament.png"),
      CourseModel(
          color: "B184EA",
          id: "3",
          status: 1,
          title: "Discipulado caminando con Cristo",
          img: "/Aventura.png"),
      CourseModel(
          color: "9579B9",
          id: "4",
          status: 1,
          title: "Discipulado 2 Guiado por el Espiritu Santo",
          img: "/imagen2.png"),
      CourseModel(
          color: "64E8FC",
          id: "5",
          status: 1,
          title: "Armas de los Guerreros En Cristo",
          img: "/imagen3.png"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          if (hasSeenIntro) ...{
            _buildIntroSlide(context),
          } else ...{
            ListViewCardAventure(),
          }
        ],
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 90.0),
      decoration: BoxDecoration(
        color: Color(0XFFFD8C43),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(0.0),
      child: Row(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 61.0,
                    width: 61.0,
                    child: CircleAvatar(
                      radius: 61,
                      backgroundImage: AssetImage(
                        "/avatar.png",
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Robinson",
                    style: StylesApp(context).textStyleBody5,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  textAlign: TextAlign.left,
                  style: StylesApp(context).textStyleBody8,
                  TextSpan(
                    children: [TextSpan(text: "Exp:"), TextSpan(text: "571")],
                  ),
                ),
                Text.rich(
                  style: StylesApp(context).textStyleBody8,
                  TextSpan(
                    children: [
                      TextSpan(text: "Racha:"),
                      TextSpan(text: "0 días")
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              spacing: 0,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(
                      "3",
                      style: StylesApp(context).textStyleBody8,
                    ),
                    Icon(
                      size: 21.0,
                      Icons.star,
                      color: Colors.white,
                    )
                  ],
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'detailProfilePage');
                    },
                    padding: EdgeInsets.all(0),
                    iconSize: 20.0,
                    icon: Icon(
                      size: 30.0,
                      Icons.fast_forward_sharp,
                      color: Colors.white,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildIntroSlide(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 90.0,
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == 4;
                if (_controller.page! > 2.5) {
                  setState(() {
                    _isLastPage = true;
                  });
                } else {
                  setState(() {
                    _isLastPage = false;
                  });
                }
              });
            },
            children: [
              _buildPage(context, "/introAventureOne.png"),
              _buildPage(context, "/introAventureTwo.png"),
              _buildPage(context, "/introAventureThree.png"),
              _buildPage(context, "/introAventureFour.png"),
            ],
          ),
        ),
        if (!_isLastPage)
          Positioned(
            top: 0,
            right: 16,
            child: _buildSkipButton(context),
          ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: const WormEffect(
                activeDotColor: Colors.blue,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: _buildNextButton(context),
        ),
      ],
    );
  }

  _buildPage(BuildContext context, String imageUrl) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Image.asset(
        imageUrl,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          hasSeenIntro = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Omitir el Intro',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_isLastPage) {
          setState(() {
            hasSeenIntro = false;
          });
        } else {
          if (_controller.page! >= 2) {
            setState(() {
              _isLastPage = true;
            });
          } else {
            _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isLastPage ? Color(0XFF006AFF) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLastPage
          ? Text(
              "Iniciar Aventura",
              style: StylesApp(context).textStyleBody7,
            )
          : const Icon(Icons.arrow_forward, color: Colors.white),
    );
  }

  ListViewCardAventure() {
    return Container(
      height: MediaQuery.sizeOf(context).height - 90.0,
      child: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 6.0),
            margin: EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
            constraints: BoxConstraints(minHeight: 112.0),
            decoration: BoxDecoration(
                color: Color(int.parse('0XFF${courses[index].color}')),
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          constraints:
                              BoxConstraints(maxWidth: 79.0, minHeight: 112.0),
                          width: 79.0,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Center(
                                    child: _starStatus(
                                      context,
                                      60,
                                      79.0,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 27.0,
                                      ),
                                      Container(
                                        width: 60.0,
                                        height: 60.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          image: DecorationImage(
                                            image:
                                                AssetImage(courses[index]!.img),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(28.0),
                                              color: Color(0XFFFDE754)),
                                          child: Text(
                                            "27 / 27",
                                            textAlign: TextAlign.center,
                                            style:
                                                StylesApp(context).chipLevels,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            courses[index].title,
                            style: StylesApp(context).textStyleBody5,
                          ),
                        ),
                        SizedBox(
                          width: 37.0,
                        )
                      ],
                    ),
                    Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                        constraints: BoxConstraints(maxHeight: 50.0),
                        padding: EdgeInsets.all(0),
                        iconSize: 30.0,
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CustomModalWidget(
                                title: 'Conoce el nuevo testamento',
                                content:
                                    'Este sesión tiene como objetivo hacer una introducción del nuevo testamento, identificar los libros que lo componen y brindar información de entorno cronológico geopolítico de los hechos.',
                                buttonText: 'Aceptar',
                              );
                            },
                          );
                        },
                        icon: Icon(
                          size: 20.0,
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 0,
                      child: ButtonThemeWidget(
                        onPressed: () {
                          Navigator.pushNamed(context, '/mapPage');
                        },
                        textStyle: StylesApp(context)
                            .chipLevels
                            .copyWith(color: Colors.white),
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                        text: "Ir a aventura",
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _starStatus(BuildContext context, double unLockLevel, containerWidth) {
    final starSize = 30.0; // Adjust star size as needed
    final starSpacing = (containerWidth - (3 * starSize)) / 3;

    return Center(
      child: Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        height: 50.0,
        child: Stack(
          children: [
            if (unLockLevel > 99) ...[
              Positioned(
                top: 10,
                left: 0.0,
                child: Image.asset(
                  "/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: 0,
                left: starSpacing + starSize + starSpacing,
                child: Image.asset(
                  "/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: 10,
                left: starSpacing + (2 * starSize) + (2 * starSpacing),
                child: Image.asset(
                  "/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ] else if (unLockLevel > 50) ...[
              Positioned(
                top: 10,
                left: 0.0,
                child: Image.asset(
                  "/star_disabled.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: 0,
                left: starSpacing + starSize + starSpacing,
                child: Image.asset(
                  "/star_disabled.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ] else if (unLockLevel > 0) ...[
              Positioned(
                top: 10,
                left: 0.0,
                child: Image.asset(
                  "/star_incomplete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
