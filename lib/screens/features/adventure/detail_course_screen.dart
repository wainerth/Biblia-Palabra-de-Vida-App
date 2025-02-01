import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailCourseScreen extends StatefulWidget {
  const DetailCourseScreen({super.key});

  @override
  State<DetailCourseScreen> createState() => _DetailCorseScreenState();
}

class _DetailCorseScreenState extends State<DetailCourseScreen> {
  final course = CourseModel(
      color: "3ae4e4",
      id: "1",
      title: "Antiguo Testamento",
      status: 1,
      img: Img(urlImg: "assets/newTestament.png"),
      introduction:
          "¿Alguna vez te has preguntado sobre los inicios del mundo y las historias épicas de héroes antiguos? El Antiguo Testamento es como una caja del tesoro llena de relatos asombrosos y enseñanzas que han impactado a millones de personas a lo largo de los siglos. Desde la creación del universo hasta las aventuras de personajes como Moisés, David y Salomón, estos \nlibros te llevan en un viaje fascinante a través de la historia, la fe y la moral. Encontrarás milagros impresionantes, batallas épicas y sabiduría atemporal. Es un lugar donde los sueños, las promesas y las luchas de la humanidad cobran vida, ofreciendo valiosas lecciones que resuenan incluso en el mundo moderno.\n",
      sectionCount: 27,
      sectionCompleted: 27);

  List<Stage> stages = List<Stage>.from([
    {
      "id": "1",
      "sectionName": "Genesis",
      "introduction":
          "¿Te gustaría conocer el origen de todo lo que existe, desde el universo hasta la humanidad? En Génesis encontrarás relatos fascinantes sobre la creación, el diluvio, la torre de Babel, la llamada de Abraham, el sacrificio de Isaac, la traición de Jacob, el sueño de José, y mucho más. También se demuestra el carácter de Dios, su amor, su justicia, su fidelidad y su poder. Este es solo el comienzo de grandes historias que continúan en el resto de la Biblia y que te motiva a ser parte de ella. Te invito a leerlo y a descubrir cómo Dios te habla a través de su palabra, ¿Estás listo?",
      "unLockSection": true,
      "countCards": 61,
      "orderCard": 1,
      "color": "3ae4e4",
      "img": {"urlImg": "images/sections/sect1.png"},
      "churchId": "2",
      "status": 1,
      "levelCount": 12,
      "levelCompleted": 12
    },
    {
      "id": "2",
      "sectionName": "Éxodo",
      "introduction":
          "¿Y si un día, Dios te hablara y te pidiera que liberaras a tu pueblo de la opresión? ¿Qué harías? Éxodo narra la historia de cómo Dios escogió a Moisés, un humilde\npastor, para ser el líder de su pueblo, Israel, y cómo lo sacó de Egipto con grandes señales y prodigios. Dios le dio a Israel los Diez Mandamientos y otras leyes para que vivieran como su pueblo santo. También les enseñó cómo construir el tabernáculo, un lugar de encuentro y adoración. Éxodo nos muestra como Dios cumple sus promesas y como nos \nllama a obedecerle y a seguirle. Además, nos invita a reflexionar sobre nuestra propia identidad, nuestro propósito y nuestro destino.  ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 2,
      "color": "2eade4",
      "img": {"urlImg": "images/sections/sect2.png"},
      "churchId": '',
      "status": 1,
      "levelCount": 12,
      "levelCompleted": 12
    },
    {
      "id": "3",
      "sectionName": "Levítico",
      "introduction":
          "¿Te gustaría saber cómo puedes adorar a Dios de una manera que le agrade y te bendiga? Levítico contiene las leyes y los rituales que Dios le dio a Moisés para que el pueblo de Israel le sirviera y le honrara. Aprenderás sobre los diferentes tipos de ofrendas y sacrificios que se ofrecían a Dios, sobre la importancia de la pureza y la santidad, \nsobre las fiestas y los tiempos especiales que Dios estableció para su pueblo, y sobre el significado del perdón y la restauración. También te revela su plan de salvación a través de símbolos y profecías que se cumplen en Jesucristo. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 3,
      "color": "2958e4",
      "img": {"urlImg": "images/sections/sect3.png"},
      "churchId": '',
      "status": 1,
      "levelCount": 12,
      "levelCompleted": 12
    },
    {
      "id": "4",
      "sectionName": "Números",
      "introduction":
          "¿Te gustaría conocer los desafíos, las pruebas y las victorias que vivió el pueblo de Dios en su camino hacia la tierra prometida? Números nos cuenta la peregrinación de los israelitas por el desierto durante cuarenta años, desde el monte Sinaí hasta las llanuras de Moab. Verás cómo Dios cuidó, protegió y proveyó para su pueblo, pero también cómo castigó su desobediencia, su rebeldía y su falta de fe. Esta fascinante historia nos incita a conocer más a Dios y a su propósito para tu vida. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 4,
      "color": "2225c2",
      "img": {"urlImg": "images/sections/sect4.png"},
      "churchId": '',
      "status": 1,
      "levelCount": 15,
      "levelCompleted": 5
    },
    {
      "id": "5",
      "sectionName": "Deuteronomio",
      "introduction":
          "¿Te agradaría escuchar las últimas palabras de un gran líder que cambió la historia de su pueblo? En Deuteronomio encontrarás los discursos finales de Moisés, el hombre que sacó a los israelitas de la esclavitud en Egipto, los guió por el desierto durante cuarenta años, y los preparó para entrar en la tierra prometida. En sus discursos, Moisés \nrepasa la historia, la ley y el pacto de Dios con su pueblo, y les exhorta a ser fieles, obedientes y agradecidos. ",
      "unLockSection": true,
      "countCards": 61,
      "orderCard": 1,
      "color": "3ae4e4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": "2",
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "2",
      "sectionName": "Éxodo",
      "introduction":
          "¿Y si un día, Dios te hablara y te pidiera que liberaras a tu pueblo de la opresión? ¿Qué harías? Éxodo narra la historia de cómo Dios escogió a Moisés, un humilde\npastor, para ser el líder de su pueblo, Israel, y cómo lo sacó de Egipto con grandes señales y prodigios. Dios le dio a Israel los Diez Mandamientos y otras leyes para que vivieran como su pueblo santo. También les enseñó cómo construir el tabernáculo, un lugar de encuentro y adoración. Éxodo nos muestra como Dios cumple sus promesas y como nos \nllama a obedecerle y a seguirle. Además, nos invita a reflexionar sobre nuestra propia identidad, nuestro propósito y nuestro destino.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 2,
      "color": "2eade4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "3",
      "sectionName": "Levítico",
      "introduction":
          "¿Te gustaría saber cómo puedes adorar a Dios de una manera que le agrade y te bendiga? Levítico contiene las leyes y los rituales que Dios le dio a Moisés para que el pueblo de Israel le sirviera y le honrara. Aprenderás sobre los diferentes tipos de ofrendas y sacrificios que se ofrecían a Dios, sobre la importancia de la pureza y la santidad, \nsobre las fiestas y los tiempos especiales que Dios estableció para su pueblo, y sobre el significado del perdón y la restauración. También te revela su plan de salvación a través de símbolos y profecías que se cumplen en Jesucristo. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 3,
      "color": "2958e4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "4",
      "sectionName": "Números",
      "introduction":
          "¿Te gustaría conocer los desafíos, las pruebas y las victorias que vivió el pueblo de Dios en su camino hacia la tierra prometida? Números nos cuenta la peregrinación de los israelitas por el desierto durante cuarenta años, desde el monte Sinaí hasta las llanuras de Moab. Verás cómo Dios cuidó, protegió y proveyó para su pueblo, pero también cómo castigó su desobediencia, su rebeldía y su falta de fe. Esta fascinante historia nos incita a conocer más a Dios y a su propósito para tu vida. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 4,
      "color": "2225c2",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "5",
      "sectionName": "Deuteronomio",
      "introduction":
          "¿Te agradaría escuchar las últimas palabras de un gran líder que cambió la historia de su pueblo? En Deuteronomio encontrarás los discursos finales de Moisés, el hombre que sacó a los israelitas de la esclavitud en Egipto, los guió por el desierto durante cuarenta años, y los preparó para entrar en la tierra prometida. En sus discursos, Moisés \nrepasa la historia, la ley y el pacto de Dios con su pueblo, y les exhorta a ser fieles, obedientes y agradecidos. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 5,
      "color": "7142e9",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "6",
      "sectionName": "Josué",
      "introduction":
          "¿Te gustaría conocer cómo Dios cumplió su promesa de darle a su pueblo una tierra donde vivir? La historia nos cuenta cómo Josué, el sucesor de Moisés, guió al pueblo de Israel a conquistar la tierra de Canaán, que Dios les había prometido a sus antepasados Abraham, Isaac y Jacob. También muestra cómo Josué repartió la tierra entre las doce tribus de Israel, y cómo les recordó la importancia de servir a Dios y guardar su ley. Josué es un testimonio de la fidelidad y el poder de Dios, que cumple sus promesas y ayuda a su pueblo a vencer a sus enemigos. Además, es una invitación a confiar en Dios y a seguir sus caminos, porque él tiene un plan para tu vida y quiere bendecirte. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 6,
      "color": "8c31d6",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "7",
      "sectionName": "Jueces",
      "introduction":
          "¿Qué pasaría si vivieras en un tiempo donde no hay rey ni ley, y cada uno hace lo que le da la gana? Jueces nos cuenta la historia de Israel en un tiempo de crisis y caos, donde el pueblo de Dios se alejó de él y se contaminó con la idolatría y la inmoralidad de los pueblos vecinos. Por eso, Dios permitió que fueran oprimidos y atacados por sus enemigos. Pero cada vez que los israelitas se arrepentían y clamaban a él, les enviaba un juez para que los librara. Todos ellos tuvieron sus virtudes y sus defectos, pero lo más importante es que cumplieron el propósito de Dios para su tiempo. Jueces nos enseña que sin Dios, el ser humano cae en la anarquía y la destrucción. Pero también nos enseña que con Dios, el ser humano puede vencer al mal y alcanzar la bendición.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 7,
      "color": "8a12a8",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "8",
      "sectionName": "Rut",
      "introduction":
          " ¿Quieres saber cómo una mujer extranjera se convirtió en parte del pueblo de Dios y de la familia del rey David? La historia nos cuenta sobre Rut, una moabita que se casó con un israelita y que, al quedar viuda, decidió acompañar a su suegra Noemí a Belén de Judá. Allí conoció a Booz, un pariente de su difunto esposo, que se enamoró de ella y la tomó por esposa. De esta unión nació Obed, el abuelo de David, el gran rey de Israel. La historia tan hermosa de Rut es una joya que brilla con luz propia en medio de la Biblia. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 8,
      "color": "d835d8",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "9",
      "sectionName": "1 Samuel",
      "introduction":
          "¿Te gustaría conocer la historia de tres personajes clave en la formación de Israel como nación? 1 Samuel nos narra los acontecimientos desde el nacimiento de Samuel hasta la muerte de Saúl, pasando por la transición del gobierno de los jueces al de los reyes. Durante el relato se muestra como Dios llama y prepara a Samuel para ser el último y más grande de los jueces, y el primero de los grandes profetas de Israel. Además, Dios unge a Saúl como el primer rey de Israel, pero lo rechaza por su desobediencia y rebeldía. También elige y bendice a David como el segundo rey de Israel, pero igualmente lo pone prueba y lo persigue a través de Saúl y de otros enemigos. 1 Samuel es un testimonio de la gracia y el poder de Dios, que cumple sus promesas y cuida de su pueblo.\n",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 9,
      "color": "fd30db",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "10",
      "sectionName": "2 Samuel",
      "introduction":
          "¿Te gustaría conocer la historia de David, el rey más famoso de Israel, y de sus triunfos y fracasos? 2 Samuel continúa el relato de la primera parte, y narra los acontecimientos desde la muerte de Saúl hasta el final del reinado de David. En esta historia te muestra cómo David se convirtió en el rey de todo Israel, y cómo conquistó Jerusalén y la hizo su capital. Además, Dios hizo un pacto con David, prometiéndole que su trono sería establecido para siempre. Durante el reinado de David, tuvo grandes victorias sobre sus enemigos, pero también cómo cometió graves pecados. Sin embargo, David se arrepintió de ellos, y Dios le perdonó y le restauró su favor.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 4,
      "color": "f72989",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "11",
      "sectionName": "1 Reyes",
      "introduction":
          "¿Quieres saber la historia de los reyes de Israel y ver cómo sus acciones afectaron al pueblo de Dios? 1 Reyes nos habla a cerca de los acontecimientos, desde el final del reinado de David hasta la división del reino de Israel. 1 Reyes te muestra cómo Salomón, el hijo de David, construyó el templo de Jerusalén, y como Dios hizo un pacto con él. Lamentablemente, Salomón se apartó de Dios por sus muchas mujeres y sus ídolos, y Dios le anunció que su reino se dividiría. Seguidamente, surgieron dos dinastías rivales entre Jeroboam, y Roboam. Estos reyes de ambos reinos hicieron lo malo ante los ojos de Dios, y Dios les envió profetas como Elías y Eliseo para confrontarlos y llamarlos al arrepentimiento. \n",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 11,
      "color": "f7295c",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "12",
      "sectionName": "2 Reyes",
      "introduction":
          "¿Te gustaría averiguar la historia de los reyes de Israel y de Judá, y cómo sus acciones afectaron al pueblo de Dios? 2 Reyes continúa el relato de la primera parte, y narra los acontecimientos desde la división del reino de Israel, hasta la destrucción de los reinos por los imperios asirio y babilónico. En 2 Reyes muestra cómo los reyes de Israel y de Judá hicieron lo malo ante los ojos de Dios, y les envió profetas para confrontarlos y hacerlos arrepentirse. Hubo milagros y prodigios a través de sus profetas, la sanidad de Naamán, la liberación de Eliseo, la derrota de Senaquerib, la prolongación de la vida de Ezequías, y otros. Debido a los grandes pecados cometidos por los reyes, Dios los castigó a ellos y al pueblo por su idolatría y su infidelidad, permitiendo que fueran invadidos y esclavizados por sus enemigos. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 12,
      "color": "e93131",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "13",
      "sectionName": "Esdras",
      "introduction":
          "¿Te gustaría saber cómo Dios restauró a su pueblo después del exilio en Babilonia? Esdras nos habla sobre los acontecimientos desde el primer año de Ciro, rey de Persia, hasta el séptimo año de Artajerjes. La primera parte de la historia, narra el primer retorno de los exiliados y la finalización del nuevo templo. La segunda parte narra la misión de Esdras en Jerusalén y su lucha por purificar al pueblo de los matrimonios con extranjeros. Por otro lado, Dios cumplió su palabra por boca de Jeremías, y despertó el espíritu de Ciro para que permitiera a los judíos volver a su tierra y edificar la casa de Dios. Además, llamó y preparó a Esdras para ser el líder espiritual de su pueblo, y cómo le dio sabiduría y favor para enseñar la ley de Dios y restaurar el culto. Dios hizo milagros y prodigios para ayudar a su pueblo a superar las dificultades y los enemigos que se oponían a su obra. \n",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 13,
      "color": "3ae4e4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "14",
      "sectionName": "Nehemías",
      "introduction":
          "¿Te imaginas cómo sería vivir en una ciudad sin muros ni defensas, rodeada de enemigos que quieren destruirte? Nehemías nos narra la misión que le fue encomendada por el rey persa Artajerjes: viajar a Jerusalén y encargarse de la restauración de sus murallas. Nehemías era un judío que vivía en el exilio, y que servía como copero al rey, es decir, como su catador de vinos y consejero de confianza. Cuando se enteró de la situación de ruina y desolación de Jerusalén, sintió una gran tristeza y un profundo deseo de ayudar a su pueblo. Así que oró a Dios, le pidió favor ante el rey, y obtuvo el permiso y los recursos para emprender su proyecto. Esta maravillosa historia nos enseña la importancia de la obediencia a la palabra de Dios, que fue leída públicamente por el sacerdote y escriba Esdras, y que produjo una solemne renovación de la alianza entre Dios y su pueblo.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 14,
      "color": "2eade4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "15",
      "sectionName": "Ester",
      "introduction":
          "¿Te podrías imaginar estar en el lugar de una joven judía que se convierte en reina de un poderoso imperio y tiene que arriesgar su vida para salvar a su pueblo de la aniquilación? Esa es la historia de Ester, una heroína que demostró su valor, su fe y su lealtad en medio de una trama llena de intrigas, conspiraciones y peligros. En este relato se observa como Dios puede actuar de manera sorprendente y providencial, incluso cuando parece ausente o silencioso. También te enseña la importancia de celebrar la victoria de Dios sobre los enemigos de su pueblo, como se hace en la fiesta de Purim. Ester es una historia apasionante, dramática e inspiradora, que te hará \nreflexionar sobre tu propia identidad, tu propósito y tu destino. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 15,
      "color": "2958e4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "16",
      "sectionName": "Job",
      "introduction":
          "¿Te gustaría conocer los desafíos, las pruebas y las victorias que vivió el pueblo de Dios en su camino hacia la tierra prometida? Números nos cuenta la peregrinación de los israelitas por el desierto durante cuarenta años, desde el monte Sinaí hasta las llanuras de Moab. Verás cómo Dios cuidó, protegió y proveyó para su pueblo, pero también cómo castigó su desobediencia, su rebeldía y su falta de fe. Esta fascinante historia nos incita a conocer más a Dios y a su propósito para tu vida. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 16,
      "color": "2225c2",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "17",
      "sectionName": "Isaías",
      "introduction":
          " ¿Te gustaría conocer el mensaje de un profeta que anunció la venida del Mesías, el Salvador del mundo, siglos antes de que naciera? Ese profeta es Isaías, el cual muestra como Dios es el Rey soberano de toda la historia, que tiene un plan perfecto para su creación y que cumple sus promesas a pesar de la infidelidad humana. También te revela el amor y la misericordia de Dios, que envió a su Hijo Jesús mucho tiempo después para rescatar a los pecadores y restaurar su relación con él. La historia de Isaías es una fuente de esperanza, consuelo y desafío, que te inspira a confiar en Dios y a obedecerle. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 17,
      "color": "7142e9",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "18",
      "sectionName": "Jeremías",
      "introduction":
          "¿Qué harías si tuvieras que anunciar un mensaje que nadie quiere escuchar? ¿Cómo te sentirías si fueras rechazado, perseguido y encarcelado por decir la verdad? Esa es la experiencia de Jeremías, un profeta que fue llamado por Dios para advertir a Judá del juicio que vendría si no se arrepentían de sus pecados. El relato de Jeremías nos muestra su corazón sincero, su dolor profundo y su fe firme. También nos revela el amor y la misericordia de Dios, que promete restaurar a su pueblo y hacer un nuevo pacto con él.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 18,
      "color": "8c31d6",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "19",
      "sectionName": "Lamentaciones",
      "introduction":
          "¿Has sentido alguna vez un dolor tan profundo que solo puedes expresarlo con lágrimas? ¿Has vivido alguna situación tan terrible que te hace preguntarte dónde está Dios y por qué permite tanto sufrimiento? Eso es lo que experimentaron los habitantes de Jerusalén cuando vieron su ciudad y su templo destruidos por los babilonios en el año. En Lamentaciones se expresa el luto, la angustia y la desesperación de ese pueblo que perdió todo lo que amaba. Pero también es un testimonio de fe, de esperanza y de confianza en Dios, que no abandona a su pueblo ni se olvida de su misericordia. Esta historia te invita a compartir el dolor de tus hermanos, a reconocer tus pecados y a clamar a Dios por su perdón y su restauración.  \n",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 4,
      "color": "8a12a8",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "20",
      "sectionName": "Ezequiel",
      "introduction":
          "¿Te gustaría conocer el mensaje de Dios para su pueblo en tiempos difíciles? La historia nos narra a Ezequiel, un profeta que vivió en una época difícil, cuando los judíos fueron llevados cautivos a Babilonia por el rey Nabucodonosor. Allí, en medio de la desesperanza y el pecado, recibió visiones de Dios que le revelaron su gloria, su juicio y su salvación. Ezequiel vio cosas increíbles, como una nube con fuego, un valle de huesos secos que cobraron vida, un templo nuevo y maravilloso, entre otros. Además, transmitió el mensaje de Dios a su pueblo, llamándolo al arrepentimiento y a la confianza en el futuro. También anunció que Dios restauraría a su pueblo, le daría un corazón\n nuevo y un espíritu nuevo, y haría un pacto de paz con él. \n ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 4,
      "color": "d835d8",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "21",
      "sectionName": "Daniel",
      "introduction":
          "¿Te atreverías a desafiar al poderoso rey de Babilonia y a mantenerse fiel a Dios en medio de un mundo hostil? Esa es la historia de Daniel, un joven israelita que fue llevado cautivo a Babilonia junto con sus amigos Ananías, Misael y Azarías. Allí, tuvieron que enfrentarse a diversas pruebas, como comer la comida del rey, interpretar los sueños del\nmonarca, resistir la adoración de una estatua de oro y sobrevivir al foso de los leones. A pesar de todo, Daniel y sus compañeros demostraron gran sabiduría y fidelidad a Dios, lo que los llevó a ser reconocidos como hombres importantes en la corte del rey Nabucodonosor. Además, en el relato se revela las profecías que Dios le dio a Daniel sobre el futuro de su pueblo y de las naciones.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 21,
      "color": "fd30db",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "22",
      "sectionName": "Oseas",
      "introduction":
          "¿Te has preguntado alguna vez cómo es el amor de Dios por su pueblo? En esta historia se narra la vida de Oseas, el cual fue un profeta que vivía en una época de crisis política, social y religiosa para el reino de Israel. Dios le pidió que se casara con una mujer llamada Gomer, que le fue infiel y tuvo hijos con otros hombres. A través de esta dolorosa experiencia personal, Oseas comprendió el amor de Dios por Israel, que también había sido infiel a Dios y había seguido a otros dioses. Pero Dios no se rindió con su pueblo, sino que buscó restaurar la alianza con él, ofreciéndole perdón y esperanza. Oseas es una poderosa expresión del amor de Dios, que es fiel, misericordioso y paciente. También es una invitación a volver a Dios, a arrepentirse de nuestros pecados y a confiar en su gracia. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 22,
      "color": "f72989",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "23",
      "sectionName": "Joel",
      "introduction":
          "¿Qué harías si una plaga de langostas invadiera tu país y destruyera toda la comida y las cosechas? Eso es lo que le pasó al pueblo de Judá en el relato de Joel, un profeta que les advirtió de la ira de Dios y buscaran el arrepentimiento. Pero también les dio una esperanza de restauración y bendición, si se volvían a Dios con todo su corazón.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 23,
      "color": "f7295c",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "24",
      "sectionName": "Amós",
      "introduction":
          "¿Te has preguntado alguna vez cómo sería vivir en una época de gran prosperidad, pero también de gran injusticia? En la historia, Amós se le menciona como un pastor y recolector de higos de Judá, que fue llamado por Dios para profetizar en el reino del norte de Israel, durante el reinado de Jeroboam. Su mensaje era duro y directo: Dios no toleraría la idolatría, la opresión, la corrupción y la hipocresía de su pueblo, y pronto lo castigaría con la invasión de los asirios. Sin embargo, también proclamaba la esperanza de un reino futuro para el pueblo de Dios, en el que se restauraría la dinastía de David y se bendeciría a todas las naciones. \n",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 24,
      "color": "e93131",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "25",
      "sectionName": "Abdías",
      "introduction":
          "¿Qué pasaría si un día te enteraras de que tu peor enemigo va a ser castigado por Dios por todo el mal que te ha hecho? ¿Te alegrarías o te compadecerías de él? Abdías contiene una profecía contra Edom, el pueblo descendiente de Esaú, el hermano de Jacob. Edom fue un rival constante de Israel, que se aprovechó de su debilidad y de su caída ante los babilonios. Durante el desarrollo de la historia te muestra como Dios juzga a las naciones por sus acciones y que defiende a su pueblo elegido. También te revela el amor y la misericordia de Dios, que promete restaurar a Israel. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 25,
      "color": "3ae4e4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "26",
      "sectionName": "Jonás",
      "introduction":
          "¿Te imaginas recibir una orden de Dios y desobedecerla? ¿Qué pasaría si intentaras escapar de su presencia? Estas situaciones las vivió\nJonás, el profeta, el cual Dios le encomendó la tarea de advertir a los habitantes de Nínive, una ciudad pagana que se caracterizaba por su maldad. Sin embargo, Jonás desobedece sus órdenes trayéndole consecuencias, Jonás es una historia narrativa que nos muestra la gracia de Dios y su amor por todas las personas, incluso las que consideramos malvadas o indignas. También nos enseña sobre la obediencia, el arrepentimiento y la compasión. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 26,
      "color": "2eade4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "27",
      "sectionName": "Miqueas",
      "introduction":
          "¿Te has preguntado alguna vez cómo sería vivir en un mundo donde reina la injusticia, la violencia y la corrupción? Pues ese era el mundo de Miqueas, un profeta que vivió hace en Israel. Fue testigo de cómo Israel, fue destruido por el imperio asirio, y cómo Judá, estuvo al borde del colapso por la misma amenaza. Miqueas no se quedó callado ante esta situación. Él denunció con valentía los pecados de su pueblo y de sus gobernantes, y anunció el juicio de Dios sobre ellos. Él proclamó que Dios tenía un plan para restaurar a su pueblo, y que enviaría un rey especial, nacido en Belén, que traería la paz y la justicia al mundo. El libro de Miqueas es un mensaje poderoso y relevante para nuestro \ntiempo. En él podemos aprender sobre el carácter de Dios, su amor por los oprimidos, su odio por el mal, y su promesa de salvación. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 27,
      "color": "2958e4",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "28",
      "sectionName": "Nahúm",
      "introduction":
          "¿Te imaginas vivir bajo el dominio de un imperio cruel y violento que te oprime y te esclaviza? Eso es lo que le pasó al pueblo de Judá, que durante más de un siglo sufrió la opresión de los asirios. El relato de Nahúm es un poema profético que anuncia la caída de Nínive, la capital de Asiria, y la venganza de Dios contra sus crímenes. Nahúm fue él\nmensajero de Dios que trajo una buena noticia a Judá: que Dios es justo y poderoso, que cuida de su pueblo y castiga a sus enemigos, y que pronto cambiará su suerte y le dará paz y restauración. Todos aquellos mensajes fueron un canto de esperanza y de fe en medio de la angustia y la opresión. \n",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 28,
      "color": "2225c2",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "29",
      "sectionName": "Habacuc",
      "introduction":
          "¿Alguna vez te has preguntado por qué hay tanto mal y sufrimiento en el mundo? ¿Por qué Dios parece no hacer nada al respecto? Estas son algunas de las preguntas que se hace el profeta Habacuc, que vivió en una época de violencia y opresión. La historia de Habacuc es un diálogo entre el profeta y Dios, en el que expresa sus dudas, sus quejas y sus esperanzas. Dios le responde con paciencia y le revela sus planes y propósitos. Habacuc aprende a aceptar los caminos misteriosos de Dios y a confiar en su justicia y su amor. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 29,
      "color": "7142e9",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "30",
      "sectionName": "Sofonías",
      "introduction":
          "¿Te imaginas cómo sería vivir en un mundo donde todo lo que conoces será destruido por el fuego de Dios? En Sofonías, Durante el reinado del rey Josías de Judá. Sofonías anunció el día del Señor, un día terrible y espantoso en el que Dios intervendría en la historia para juzgar a todas las naciones, empezando por su propio pueblo. Pero no solo\nse habla de juicio y destrucción. También habla de esperanza y restauración. Al final, el profeta revela que Dios tiene un plan para salvar a un remanente fiel de Judá, y para bendecir a todas las naciones que se humillen ante él. La historia termina con una hermosa visión de un futuro en el que Dios morará con su pueblo, lo protegerá, lo alegrará y lo renovará con su amor.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 30,
      "color": "8c31d6",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "31",
      "sectionName": "Hageo",
      "introduction":
          "¿Qué harías si Dios te pidiera que dejaras de preocuparte por tu propia comodidad y que te dedicaras a reconstruir su casa? En este relato se menciona Hageo, un profeta que vivió después del regreso de los judíos del exilio en Babilonia. Hageo transmitió cuatro mensajes de Dios al pueblo de Judá, especialmente al gobernador Zorobabel y al sumo sacerdote Josué. Su propósito fue motivarlos a reanudar la obra del templo, que había sido abandonada por falta de recursos, oposición y desánimo. Les mostró que Dios estaba descontento con su actitud egoísta y que les estaba castigando con escasez y pobreza. También les aseguró que Dios estaba con ellos y que les bendeciría si obedecían su mandato. Además, les anunció que Dios haría temblar el cielo y la tierra, y que establecería su reino de paz y justicia.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 31,
      "color": "8a12a8",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "32",
      "sectionName": "Zacarías",
      "introduction":
          "¿Qué harías si Dios te hablara a través de sueños y visiones? ¿Qué aprenderías si escucharas las profecías sobre el futuro de Israel y el mundo? Estas son algunas de las experiencias que vivió Zacarías. Fue uno de los profetas que vivió después del exilio de los judíos en Babilonia, cuando regresaron a su tierra para reconstruir el templo y\nla ciudad de Jerusalén. Escribió su historia para animar y fortalecer al pueblo de Dios, que estaba desanimado y desalentado por las dificultades y los enemigos que enfrentaban. Su mensaje era de esperanza y restauración, basado en las promesas y los planes de Dios para su pueblo. Zacarías les mostró que Dios no los había olvidado, sino que los amaba y los cuidaba. ",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 32,
      "color": "d835d8",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
    {
      "id": "33",
      "sectionName": "Malaquias",
      "introduction":
          "¿Te has preguntado alguna vez si Dios te ama de verdad? ¿O si le importa lo que haces con tu vida? Estas son algunas de las preguntas que se planteaban los judíos que vivían en Jerusalén después de regresar del exilio en Babilonia. Ellos esperaban que Dios les bendijera por haber reconstruido el templo y la ciudad, en cambio, se encontraron con dificultades, pobreza y opresión. Se sentían decepcionados, desanimados y desobedientes. Entonces Dios les envió un profeta llamado Malaquías. Él les recordó el amor de Dios \npor su pueblo, pero también les reprochó sus pecados y les advirtió de las consecuencias de alejarse de Él. Malaquías también les habló de la importancia de honrar a Dios con sus ofrendas, sus matrimonios, sus diezmos y su fidelidad para purificar y restaurar a su pueblo.",
      "unLockSection": false,
      "countCards": 0,
      "orderCard": 33,
      "color": "fd30db",
      "img": {"urlImg": "assets/level.png"},
      "churchId": '',
      "levelCount": 20,
      "levelCompleted": 0,
      "status": 1
    },
  ].map((stageJson) => Stage.fromJson(stageJson)).toList());
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 1;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          Navigator.pushNamed(context, '/layoutPage');
        } else {
          _selectedIndex = index;
          Navigator.pushNamed(
            context,
            '/layoutPage',
            arguments: {'selectedIndex': _selectedIndex},
          );
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return SingleChildScrollView(
              child: SizedBox(
                height: orientation == Orientation.portrait
                    ? MediaQuery.sizeOf(context).height -60
                    : MediaQuery.sizeOf(context).width -
                        (MediaQuery.sizeOf(context).height/2),
                child: Column(
                  children: [
                    HeadScoreWidget(
                      onRoute: () {
                        Navigator.popAndPushNamed(context, '/profilePage');
                      },
                    ),
                    Text(
                      "Sigue la ruta de la sabiduría",
                      style: StylesApp(context)
                          .textStyleBody20
                          .copyWith(color: StyleColor.vibrantPurple),
                    ),
                    CardAventureWidget(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return CustomModalWidget(
                              title: course.title,
                              content: course.introduction,
                              buttonText: 'Aceptar',
                              id: course.id,
                              showSubtitle: false,
                              itemCount: 0,
                              itemsCompleted: 0,
                            );
                          },
                        );
                      },
                      course: course,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      height: 6.0,
                      decoration: BoxDecoration(
                        color: Color(0XFFD9D9D9),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              offset: Offset(0.0, 4.0),
                              blurStyle: BlurStyle.outer),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    _listOfStages(context)
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBarWidget(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Color(0XFF7D7878),
        selectedItemColor: Color(0XFF12CBC4),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: StylesApp(context).textStyleBody10,
        unselectedLabelStyle: StylesApp(context).textStyleBody10,
        items: items
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(
                    item.icon,
                    size: StylesApp(context).sizeIconBottomBar,
                  ),
                  label: item.title,
                ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  _listOfStages(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: stages.length,
        itemBuilder: (context, index) {
          final stage = stages[index];
          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 9.0),
                padding: EdgeInsets.symmetric( vertical: 4.0),
                constraints: BoxConstraints(
                  minHeight: 65.0,
                ),
                decoration: BoxDecoration(
                    color: Color(
                      int.parse('0XFF${stage.color}'),
                    ),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 10.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 0,
                            child: Column(
                              spacing: 10.0,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0XFFF4C622),
                                      borderRadius: BorderRadius.circular(28.0)),
                                  height: 28.0,
                                  constraints: BoxConstraints(
                                      minHeight: 28.0, minWidth: 101.0),
                                  child: Center(
                                    child: Text(
                                      "Etapa ${stage.id}",
                                      style: StylesApp(context)
                                          .textStyleBody12
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF4C622),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.75),
                                        offset: Offset(4.0, 4.0),
                                        blurRadius: 4.0,
                                        spreadRadius: -4.0,
                                        blurStyle: BlurStyle.inner,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                  height: 20.0,
                                  constraints: BoxConstraints(minHeight: 22.0),
                                  child: Center(
                                    child: Text(
                                      "${stage.levelCompleted} / ${stage.levelCount}",
                                      style: StylesApp(context)
                                          .textStyleBody12
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              spacing: 10.0,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  stage.sectionName,
                                  style: StylesApp(context).textStyleBody12,
                                ),
                                Row(
                                  children: [
                                    ButtonThemeWidget(
                                      // height: 14.sp,
                                      onPressed: (getStatus(stage.levelCount,
                                                  stage.levelCompleted) ==
                                              "Pendiente")
                                          ? null
                                          : () {
                                              Navigator.popAndPushNamed(
                                                  context, '/mapPage');
                                            },
                                      textStyle: StylesApp(context).textStyleBody14,
                                      buttonStyle:
                                          StylesApp(context).btnWidgetSmall.copyWith(
                                        backgroundColor:
                                            WidgetStateProperty.resolveWith<Color?>(
                                          (Set<WidgetState> states) {
                                            if (states
                                                .contains(WidgetState.disabled)) {
                                              return Colors
                                                  .grey; // Color when the button is disabled
                                            }
                                            return (getStatus(stage.levelCount,
                                                        stage.levelCompleted) ==
                                                    "Completado")
                                                ? Color(0XFFC7AA34)
                                                : Color(
                                                    0XFF12CBC4); // Use the component's default.
                                          },
                                        ),
                                      ),
                                      text: getStatus(
                                          stage.levelCount, stage.levelCompleted),
                                    ),
                                    if (getStatus(
                                            stage.levelCount, stage.levelCompleted) !=
                                        "Pendiente") ...{
                                      SizedBox(width: 8.0),
                                      ButtonThemeWidget(
                                        onPressed: () {
                                          Navigator.popAndPushNamed(
                                              context, '/mapPage');
                                        },
                                        textStyle: StylesApp(context).textStyleBody14,
                                        width: 50.sp,
                                        text: "Ir",
                                        buttonStyle:
                                            StylesApp(context).btnWidgetSmall,
                                      )
                                    }
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                        width: 28.sp,
                        height: 28.sp,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.info_outline, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return CustomModalWidget(
                                  title: stage.sectionName,
                                  content: stage.introduction,
                                  buttonText: 'Aceptar',
                                  id: stage.id,
                                  itemCount: stage.levelCount,
                                  itemsCompleted: stage.levelCompleted,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    if (getStatus(stage.levelCount, stage.levelCompleted) ==
                        "En Proceso")
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image.asset(
                            "assets/kawaii_fire.png",
                            width: 28.0,
                          ))
                  ],
                ),
              ),
              if (index == stages.length - 1) ...{
                        SizedBox(
                        height: kBottomNavigationBarHeight -30,
                        )
                    }
            ],
          );
        },
      ),
    );
  }

  String getStatus(levelCount, levelsCompleted) {
    if (levelsCompleted > 0) {
      if (levelsCompleted.toString() == levelCount.toString()) {
        return "Completado";
      } else {
        return "En Proceso";
      }
    } else {
      return "Pendiente";
    }
  }

  IconData getEstadoIcon(String estado) {
    switch (estado) {
      case 'Completado':
        return Icons.chat_bubble_outline;
      case 'En Proceso':
        return Icons.whatshot;
      case 'Pendiente':
        return Icons.square;
      default:
        return Icons.error;
    }
  }
}
