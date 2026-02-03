import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class AppConstants {
  static final List<Map<String, dynamic>> homeCards = [
    {
      'label': 'Aventura',
      'img': 'assets/aventure.gif',
      'route': '/introAventurePage',
    },
    {
      'label': 'La Biblia',
      'img': 'assets/biblia.png',
      'route': '/bibliaPage',
    },
    {
      'label': 'Comunidad',
      'img': 'assets/comunidad.png',
      'route': '/communityPage',
    },
  ];

  static final List<Map<String, String>> listOption = [
    {"option": "A", "color": "A8A1E7"},
    {"option": "B", "color": "C3F0F9"},
    {"option": "C", "color": "E1D8D8"},
    {"option": "D", "color": "A8B9F1"}
  ];

  static final List<String> categories = [
    'Todos',
    'Diarios',
    'Semanal',
    'Grupales',
    'Individuales'
  ];

  static final List<Map<String, String>> tabsSearchBible = [
    {"title": 'Libro', "placeholder": 'Buscar por libro'},
    {"title": 'Texto', "placeholder": 'Buscar por texto'},
    {"title": 'Tema', "placeholder": 'Buscar por tema'},
    {"title": 'Personajes', "placeholder": 'Buscar personajes'},
  ];
  static final List<Map<String, dynamic>> tabsPreach = [
    {
      "title": 'Mensaje',
      "placeholder": 'Mensaje a buscar',
      "icon": Icons.message,
    },
    {
      "title": 'Predicador',
      "placeholder": 'Nombre del predicador a buscar',
      "icon": Icons.person,
    },
    {
      "title": 'Favoritas',
      "placeholder": 'Favorito a buscar',
      "icon": Icons.favorite,
    }
  ];

  static final List<String> spanishKeywords = [
    'el',
    'la',
    'los',
    'las',
    'un',
    'una',
    'unos',
    'unas',
    'y',
    'o',
    'pero',
    'porque',
    'cuando',
    'donde',
    'como',
    'qué',
    'quién',
    'cuál',
    'cuánto',
    'cuánta',
    'cuántos',
    'cuántas',
    'dios',
    'jesús',
    'cristo',
    'biblia',
    'palabra',
    'vida'
  ];

  static final List<String> englishKeywords = [
    'the',
    'and',
    'but',
    'because',
    'when',
    'where',
    'how',
    'what',
    'who',
    'which',
    'god',
    'jesus',
    'christ',
    'bible'
  ];

  static final List<String> textPromise = [
    "¿Qué secreto esconde este versículo que puede cambiar tu vida?",
    "Descubre la fuerza que transforma vidas y embárcate en un viaje espiritual",
    "Permite que la sabiduría te inspire a vivir una vida auténtica y compasiva",
    "Embárcate en un viaje que te llevará a descubrir las profundidades de tu alma",
    "Encontrarás la fuerza interior necesaria para hallar consuelo en tu vida",
    "Cada verso es una semilla que puede florecer en tu corazón",
    "Conecta con la fuente de toda sabiduría y encuentra la paz que tanto anhelas",
    "Descubre el tesoro oculto que se encuentra en cada palabra",
    "Permite que la sabiduría de los antiguos maestros te guíe",
    "Abre tu mente y tu corazón a las infinitas posibilidades que la palabra te ofrece",
    "Descubre la belleza de la simplicidad y la profundidad de la fe",
    "Las palabras tienen el poder de sanar, inspirar y transformar",
    "Permite que estas verdades eternas transforme enormemente tu corazón",
    "Cada verso es un regalo que te invita a crecer como persona",
    "Conecta con la fuente de toda sabiduría y encuentra la paz que tanto anhelas",
    "Cada palabra es una pieza que te ayudará a comprender tu lugar en el mundo."
  ];

  static final List<String> imagesPromise = [
    "assets/promesa-1.png",
    "assets/promesa-2.png",
    "assets/promesa-3.png",
  ];
  // lista de colores para las card de las promesas canjeadas
  static final List<String> colorsCard = ["03C6DC", "9747FF", "E85151"];
}
