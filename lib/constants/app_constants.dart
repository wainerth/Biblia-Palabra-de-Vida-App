import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class AppConstants {
  static final List<Map<String, dynamic>> homeCards = [
    {
      'label': 'workspace.cards.adventure',
      'subTitle':"workspace.cards.adventure_sub_title",
      'key':'Aventura',
      'img': 'assets/aventure-bolso.png',
      'route': '/introAventurePage',
    },
    {
      'label': 'workspace.cards.bible',
      'subTitle':"workspace.cards.bible_sub_title",
      'key':'Biblia',
      'img': 'assets/bible-icon.png',
      'route': '/bibliaPage',
    },
    {
      'label': 'workspace.cards.community',
      'subTitle':"workspace.cards.community_sub_title",
      'key':'Comunidad',
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
  {"title": 'search_bible_screen.tabs.book', "placeholder": 'search_bible_screen.search.placeholder_book'},
  {"title": 'search_bible_screen.tabs.text', "placeholder": 'search_bible_screen.search.placeholder_text'},
  {"title": 'search_bible_screen.tabs.theme', "placeholder": 'search_bible_screen.search.placeholder_theme'},
  {"title": 'search_bible_screen.tabs.character', "placeholder": 'search_bible_screen.search.placeholder_character'},

  ];
  static final List<Map<String, dynamic>> tabsPreach = [
     {
    "title": 'preach_screen.tabs.message',  // 👈 Usa la clave, no el texto fijo
    "placeholder": 'preach_screen.search.placeholder_message',
    "icon": Icons.message,
  },
  {
    "title": 'preach_screen.tabs.preacher',
    "placeholder": 'preach_screen.search.placeholder_preacher',
    "icon": Icons.person,
  },
  {
    "title": 'preach_screen.tabs.favorites',
    "placeholder": 'preach_screen.search.placeholder_favorites',
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


  static final List<String> imagesPromise = [
    "assets/promesa-1.png",
    "assets/promesa-2.png",
    "assets/promesa-3.png",
  ];
  // lista de colores para las card de las promesas canjeadas
  static final List<String> colorsCard = ["03C6DC", "9747FF", "E85151"];
}
