import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class AventureScreen extends StatefulWidget {
  const AventureScreen({super.key});

  @override
  State<AventureScreen> createState() => _AventureScreenState();
}

class _AventureScreenState extends State<AventureScreen> {
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
        img: Img(urlImg: "assets/newTestament.png"),
        introduction:
            "¿Alguna vez te has preguntado sobre los inicios del mundo y las historias épicas de héroes antiguos? El Antiguo Testamento es como una caja del tesoro llena de relatos asombrosos y enseñanzas que han impactado a millones de personas a lo largo de los siglos. Desde la creación del universo hasta las aventuras de personajes como Moisés, David y Salomón, estos \nlibros te llevan en un viaje fascinante a través de la historia, la fe y la moral. Encontrarás milagros impresionantes, batallas épicas y sabiduría atemporal. Es un lugar donde los sueños, las promesas y las luchas de la humanidad cobran vida, ofreciendo valiosas lecciones que resuenan incluso en el mundo moderno.\n",
        sectionCount: 27,
        sectionCompleted: 27,
      ),
      CourseModel(
        color: "2eade4",
        id: "2",
        status: 1,
        title: "Nuevo Testamento",
        img: Img(urlImg: "assets/newTestament.png"),
        introduction:
            "¿Alguna vez te has preguntado sobre los inicios del mundo y las historias épicas de héroes antiguos? El Antiguo Testamento es como una caja del tesoro llena de relatos asombrosos y enseñanzas que han impactado a millones de personas a lo largo de los siglos. Desde la creación del universo hasta las aventuras de personajes como Moisés, David y Salomón, estos \nlibros te llevan en un viaje fascinante a través de la historia, la fe y la moral. Encontrarás milagros impresionantes, batallas épicas y sabiduría atemporal. Es un lugar donde los sueños, las promesas y las luchas de la humanidad cobran vida, ofreciendo valiosas lecciones que resuenan incluso en el mundo moderno.\n",
        sectionCount: 27,
        sectionCompleted: 5,
      ),
      CourseModel(
        color: "B184EA",
        id: "3",
        status: 1,
        title: "Discipulado caminando con Cristo",
        img: Img(urlImg: "assets/aventura.png"),
        introduction:
            "¿Alguna vez te has preguntado sobre los inicios del mundo y las historias épicas de héroes antiguos? El Antiguo Testamento es como una caja del tesoro llena de relatos asombrosos y enseñanzas que han impactado a millones de personas a lo largo de los siglos. Desde la creación del universo hasta las aventuras de personajes como Moisés, David y Salomón, estos \nlibros te llevan en un viaje fascinante a través de la historia, la fe y la moral. Encontrarás milagros impresionantes, batallas épicas y sabiduría atemporal. Es un lugar donde los sueños, las promesas y las luchas de la humanidad cobran vida, ofreciendo valiosas lecciones que resuenan incluso en el mundo moderno.\n",
        sectionCount: 27,
        sectionCompleted: 0,
      ),
      CourseModel(
        color: "9579B9",
        id: "4",
        status: 1,
        title: "Discipulado 2 Guiado por el Espíritu Santo",
        img: Img(urlImg: "assets/imagen2.png"),
        introduction:
            "¿Alguna vez te has preguntado sobre los inicios del mundo y las historias épicas de héroes antiguos? El Antiguo Testamento es como una caja del tesoro llena de relatos asombrosos y enseñanzas que han impactado a millones de personas a lo largo de los siglos. Desde la creación del universo hasta las aventuras de personajes como Moisés, David y Salomón, estos \nlibros te llevan en un viaje fascinante a través de la historia, la fe y la moral. Encontrarás milagros impresionantes, batallas épicas y sabiduría atemporal. Es un lugar donde los sueños, las promesas y las luchas de la humanidad cobran vida, ofreciendo valiosas lecciones que resuenan incluso en el mundo moderno.\n",
        sectionCount: 27,
        sectionCompleted: 0,
      ),
      CourseModel(
        color: "64E8FC",
        id: "5",
        status: 1,
        title: "Armas de los Guerreros En Cristo",
        img: Img(urlImg: "assets/imagen3.png"),
        introduction:
            "¿Alguna vez te has preguntado sobre los inicios del mundo y las historias épicas de héroes antiguos? El Antiguo Testamento es como una caja del tesoro llena de relatos asombrosos y enseñanzas que han impactado a millones de personas a lo largo de los siglos. Desde la creación del universo hasta las aventuras de personajes como Moisés, David y Salomón, estos \nlibros te llevan en un viaje fascinante a través de la historia, la fe y la moral. Encontrarás milagros impresionantes, batallas épicas y sabiduría atemporal. Es un lugar donde los sueños, las promesas y las luchas de la humanidad cobran vida, ofreciendo valiosas lecciones que resuenan incluso en el mundo moderno.\n",
        sectionCount: 27,
        sectionCompleted: 0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(),
              listViewCardAventure(),
            ],
          ),
        ),
      ),
    );
  }

  listViewCardAventure() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height - 30,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 40.0),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CardAventureWidget(
                      course: courses[index],
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/detailCoursePage');
                      },
                    ),
                    if (index == courses.length - 1) ...{
                      SizedBox(
                        height: kBottomNavigationBarHeight +30 ,
                      )
                    }
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
