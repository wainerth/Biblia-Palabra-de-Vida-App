import 'package:biblia_palabra_de_vida_app/screens/library/delivery_coordination_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/screens/library/book_detail_screen.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  var _selectedIndex = 0;
  late TabController _tabController;

  bool loading = false;
  ModelData? selectedCountry;
  ModelData? selectedAreaCode;
  ModelData? selectedCity;
  ModelData? selectedCurrency;
  String recipientName = '';
  String phoneNumber = '';
  List<ModelData> _listCountries = [];
  List<ModelData> _listAreasCode = [];
  final List<ModelData> _lisCities = [];

  final List<ModelData> _lisCurrencies = [
    ModelData(label: "USD", value: "1"),
    ModelData(label: "UYU", value: "2"),
    ModelData(label: "COP", value: "3"),
    ModelData(label: "BS", value: "1"),
  ];
  List tabs = [
    {
      "title": 'Tipo',
      "placeholder": 'Tipo a buscar',
    },
    {
      "title": 'Tema',
      "placeholder": 'Tema a del Libro a buscar',
    },
    {
      "title": 'Autor',
      "placeholder": 'Autor del Libro a buscar',
    },
    {
      "title": 'Favoritos',
      "placeholder": 'Favorito a buscar',
    },
    {
      "title": 'Carrito',
      "placeholder": 'Libro a buscar',
    }
  ];
  Map<String, List<Map<String, dynamic>>> booksForCategory = {};
  Map<String, List<Map<String, dynamic>>> booksForType = {};
  List<Map<String, dynamic>> booksInCart = [
    {
      "id": 1,
      "name": "Flutter en Acción",
      "title": "Guía completa de desarrollo Flutter",
      "author": "John Doe",
      "date_published": "2023-01-01",
      "price": 29.99,
      "original_price": 39.99,
      "isbn": "978-3-16-148410-0",
      "stock": 10,
      "rating": 4.5,
      "reviews_count": 128,
      "language": "Español",
      "type": "Ebook",
      "formats": ["PDF", "ePub", "Kindle"],
      "pages": 350,
      "publisher": "Editorial Tech",
      "description":
          "Aprende desarrollo móvil con Flutter desde cero. Incluye proyectos prácticos y ejemplos reales.",
      "category": "Programación",
      "subcategory": "Desarrollo Móvil",
      "tags": ["flutter", "dart", "mobile", "android", "ios"],
      "image": "https://i.ibb.co/ynyK9dxc/flutter-accion.jpg",
      "extra_images": [
        "https://i.ibb.co/abc123/preview1.jpg",
        "https://i.ibb.co/def456/preview2.jpg"
      ],
      "weight": 0.5,
      "dimensions": "15x21 cm",
      "on_sale": true,
      "discount": 25,
      "featured": true,
      "new": true,
      "date_added": "2023-10-15",
      "selected": false,
    },
    {
      "id": 2,
      "name": "Dart: Desde Cero",
      "title": "Domina el lenguaje de Flutter",
      "author": "María Rodríguez",
      "date_published": "2022-08-15",
      "price": 24.99,
      "original_price": 29.99,
      "isbn": "978-3-16-148411-7",
      "stock": 15,
      "rating": 4.3,
      "reviews_count": 89,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 280,
      "publisher": "Editorial Code",
      "description":
          "Domina el lenguaje Dart para desarrollo Flutter. Desde fundamentos hasta conceptos avanzados.",
      "category": "Programación",
      "subcategory": "Lenguajes de Programación",
      "tags": ["dart", "flutter", "programación"],
      "image": "https://i.ibb.co/zWWs2R4y/dart-desde-cero.jpg",
      "weight": 0.4,
      "dimensions": "14x20 cm",
      "on_sale": true,
      "discount": 17,
      "featured": false,
      "new": false,
      "date_added": "2022-09-10",
      "selected": false,
    },
    {
      "id": 12,
      "name": "La creación de Dios tan Colorida",
      "title": "Reflexiones espirituales en mensaje poético",
      "author": "Blanca P. Hernández",
      "date_published": "2022-01-15",
      "price": 16.99,
      "original_price": 19.99,
      "isbn": "N.D.LDO21555",
      "stock": 35,
      "rating": 4.7,
      "reviews_count": 94,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 180,
      "publisher": "Editorial Mundo Hispano",
      "description":
          "Obra que explora reflexiones espirituales y filosóficas en un mensaje poético sobre la vida, el amor y la naturaleza.",
      "category": "Espiritualidad",
      "subcategory": "Poesía Espiritual",
      "tags": ["espiritualidad", "poesía", "naturaleza", "reflexión"],
      "image": "https://i.ibb.co/abc123/creacion-dios-colorida.jpg",
      "weight": 0.35,
      "dimensions": "13x19 cm",
      "on_sale": true,
      "discount": 15,
      "featured": true,
      "new": true,
      "date_added": "2023-02-28",
      "selected": false,
    }
  ];
  List<Map<String, dynamic>> books = [
    {
      "id": 1,
      "name": "Flutter en Acción",
      "title": "Guía completa de desarrollo Flutter",
      "author": "John Doe",
      "date_published": "2023-01-01",
      "price": 29.99,
      "original_price": 39.99,
      "isbn": "978-3-16-148410-0",
      "stock": 10,
      "rating": 4.5,
      "reviews_count": 128,
      "language": "Español",
      "type": "Ebook",
      "formats": ["PDF", "ePub", "Kindle"],
      "pages": 350,
      "publisher": "Editorial Tech",
      "description":
          "Aprende desarrollo móvil con Flutter desde cero. Incluye proyectos prácticos y ejemplos reales.",
      "category": "Programación",
      "subcategory": "Desarrollo Móvil",
      "tags": ["flutter", "dart", "mobile", "android", "ios"],
      "image": "https://i.ibb.co/ynyK9dxc/flutter-accion.jpg",
      "extra_images": [
        "https://i.ibb.co/abc123/preview1.jpg",
        "https://i.ibb.co/def456/preview2.jpg"
      ],
      "weight": 0.5,
      "dimensions": "15x21 cm",
      "on_sale": true,
      "discount": 25,
      "featured": true,
      "new": true,
      "date_added": "2023-10-15"
    },
    {
      "id": 2,
      "name": "Dart: Desde Cero",
      "title": "Domina el lenguaje de Flutter",
      "author": "María Rodríguez",
      "date_published": "2022-08-15",
      "price": 24.99,
      "original_price": 29.99,
      "isbn": "978-3-16-148411-7",
      "stock": 15,
      "rating": 4.3,
      "reviews_count": 89,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 280,
      "publisher": "Editorial Code",
      "description":
          "Domina el lenguaje Dart para desarrollo Flutter. Desde fundamentos hasta conceptos avanzados.",
      "category": "Programación",
      "subcategory": "Lenguajes de Programación",
      "tags": ["dart", "flutter", "programación"],
      "image": "https://i.ibb.co/zWWs2R4y/dart-desde-cero.jpg",
      "weight": 0.4,
      "dimensions": "14x20 cm",
      "on_sale": true,
      "discount": 17,
      "featured": false,
      "new": false,
      "date_added": "2022-09-10"
    },
    {
      "id": 3,
      "name": "El Principito",
      "title": "Clásico de la literatura universal",
      "author": "Antoine de Saint-Exupéry",
      "date_published": "1943-04-06",
      "price": 15.50,
      "original_price": 18.99,
      "isbn": "978-3-16-148412-4",
      "stock": 25,
      "rating": 4.8,
      "reviews_count": 356,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa dura", "Tapa blanda"],
      "pages": 96,
      "publisher": "Editorial Salamandra",
      "description":
          "Clásico de la literatura francesa con profundas reflexiones sobre la vida y la amistad.",
      "category": "Literatura",
      "subcategory": "Clásicos",
      "tags": ["clásico", "literatura", "filosofía"],
      "image": "https://i.ibb.co/BVRZ2QLS/principito.jpg",
      "weight": 0.3,
      "dimensions": "12x18 cm",
      "on_sale": false,
      "discount": 0,
      "featured": true,
      "new": false,
      "date_added": "2021-05-20"
    },
    {
      "id": 4,
      "name": "Cien Años de Soledad",
      "title": "Obra maestra de García Márquez",
      "author": "Gabriel García Márquez",
      "date_published": "1967-05-30",
      "price": 22.99,
      "original_price": 27.50,
      "isbn": "978-3-16-148413-1",
      "stock": 18,
      "rating": 4.7,
      "reviews_count": 421,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 432,
      "publisher": "Editorial Sudamericana",
      "description":
          "Obra maestra del realismo mágico de Gabriel García Márquez que narra la historia de la familia Buendía.",
      "category": "Literatura",
      "subcategory": "Realismo Mágico",
      "tags": ["realismo mágico", "clásico", "nobel"],
      "image": "https://i.ibb.co/399vxphj/cien-anos-soledad.jpg",
      "weight": 0.6,
      "dimensions": "13x20 cm",
      "on_sale": true,
      "discount": 16,
      "featured": true,
      "new": false,
      "date_added": "2021-07-12"
    },
    {
      "id": 5,
      "name": "El Arte de la Guerra",
      "title": "Estrategias milenarias",
      "author": "Sun Tzu",
      "date_published": "2018-03-10",
      "price": 12.99,
      "original_price": 15.99,
      "isbn": "978-3-16-148414-8",
      "stock": 30,
      "rating": 4.4,
      "reviews_count": 215,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 128,
      "publisher": "Editorial Estrategia",
      "description":
          "Tratado militar clásico con aplicaciones modernas en negocios y estrategia personal.",
      "category": "Estrategia",
      "subcategory": "Negocios",
      "tags": ["estrategia", "negocios", "filosofía"],
      "image": "https://i.ibb.co/vCvM34TF/arte-guerra.jpg",
      "weight": 0.2,
      "dimensions": "11x17 cm",
      "on_sale": true,
      "discount": 19,
      "featured": false,
      "new": false,
      "date_added": "2022-02-18"
    },
    {
      "id": 6,
      "name": "Padre Rico, Padre Pobre",
      "title": "Educación financiera esencial",
      "author": "Robert Kiyosaki",
      "date_published": "1997-04-01",
      "price": 19.99,
      "original_price": 24.99,
      "isbn": "978-3-16-148415-5",
      "stock": 22,
      "rating": 4.6,
      "reviews_count": 389,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 336,
      "publisher": "Editorial Finanzas",
      "description":
          "Clásico de educación financiera personal que desafía conceptos tradicionales sobre el dinero.",
      "category": "Finanzas",
      "subcategory": "Educación Financiera",
      "tags": ["finanzas", "inversión", "educación financiera"],
      "image": "https://i.ibb.co/nq7nhgqP/padre-rico.jpg",
      "weight": 0.5,
      "dimensions": "14x21 cm",
      "on_sale": true,
      "discount": 20,
      "featured": true,
      "new": false,
      "date_added": "2022-01-05"
    },
    {
      "id": 7,
      "name": "Atomic Habits",
      "title": "Hábitos para el éxito",
      "author": "James Clear",
      "date_published": "2018-10-16",
      "price": 21.50,
      "original_price": 25.99,
      "isbn": "978-3-16-148416-2",
      "stock": 17,
      "rating": 4.7,
      "reviews_count": 512,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa dura", "Tapa blanda"],
      "pages": 320,
      "publisher": "Editorial Hábitos",
      "description":
          "Cómo construir buenos hábitos y romper malos. Métodos comprobados para transformar tu vida.",
      "category": "Desarrollo Personal",
      "subcategory": "Hábitos",
      "tags": ["hábitos", "productividad", "desarrollo personal"],
      "image": "https://i.ibb.co/v4mmCttZ/atomic-habits.jpg",
      "weight": 0.55,
      "dimensions": "14x21 cm",
      "on_sale": false,
      "discount": 0,
      "featured": true,
      "new": true,
      "date_added": "2023-03-22"
    },
    {
      "id": 8,
      "name": "El Poder del Ahora",
      "title": "Vive en el presente",
      "author": "Eckhart Tolle",
      "date_published": "1997-01-01",
      "price": 18.75,
      "original_price": 22.50,
      "isbn": "978-3-16-148417-9",
      "stock": 14,
      "rating": 4.5,
      "reviews_count": 287,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 256,
      "publisher": "Editorial Conciencia",
      "description":
          "Guía para la iluminación espiritual que enseña a vivir en el momento presente.",
      "category": "Espiritualidad",
      "subcategory": "Mindfulness",
      "tags": ["espiritualidad", "mindfulness", "meditación"],
      "image": "https://i.ibb.co/XZxym9FM/poder-ahora.jpg",
      "weight": 0.4,
      "dimensions": "13x20 cm",
      "on_sale": true,
      "discount": 17,
      "featured": false,
      "new": false,
      "date_added": "2022-11-08"
    },
    {
      "id": 9,
      "name": "Sapiens",
      "title": "Historia de la humanidad",
      "author": "Yuval Noah Harari",
      "date_published": "2014-02-10",
      "price": 26.99,
      "original_price": 32.00,
      "isbn": "978-3-16-148418-6",
      "stock": 20,
      "rating": 4.8,
      "reviews_count": 643,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 496,
      "publisher": "Editorial Historia",
      "description":
          "Breve historia de la humanidad que explora cómo los humanos llegaron a dominar el mundo.",
      "category": "Historia",
      "subcategory": "Historia Universal",
      "tags": ["historia", "evolución", "humanidad"],
      "image": "https://i.ibb.co/pvcvYJ2j/sapiens.jpg",
      "weight": 0.7,
      "dimensions": "15x23 cm",
      "on_sale": true,
      "discount": 16,
      "featured": true,
      "new": false,
      "date_added": "2022-06-14"
    },
    {
      "id": 10,
      "name": "El Universo en una Cáscara de Nuez",
      "title": "Los secretos del cosmos",
      "author": "Stephen Hawking",
      "date_published": "2001-11-06",
      "price": 23.50,
      "original_price": 28.75,
      "isbn": "978-3-16-148419-3",
      "stock": 12,
      "rating": 4.6,
      "reviews_count": 198,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa dura"],
      "pages": 224,
      "publisher": "Editorial Ciencia",
      "description":
          "Exploración de los misterios del cosmos y las teorías más avanzadas de la física moderna.",
      "category": "Ciencia",
      "subcategory": "Física",
      "tags": ["ciencia", "física", "cosmos", "hawking"],
      "image": "https://i.ibb.co/chvzphwG/universo-cascara.jpg",
      "weight": 0.65,
      "dimensions": "16x24 cm",
      "on_sale": false,
      "discount": 0,
      "featured": false,
      "new": false,
      "date_added": "2021-09-30"
    },
    {
      "id": 11,
      "name": "Clean Code",
      "title": "Código limpio, desarrollo eficiente",
      "author": "Robert C. Martin",
      "date_published": "2008-08-01",
      "price": 34.99,
      "original_price": 42.50,
      "isbn": "978-3-16-148420-9",
      "stock": 8,
      "rating": 4.9,
      "reviews_count": 325,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 464,
      "publisher": "Editorial Programación",
      "description":
          "Principios para escribir código limpio y mantenible. Esencial para todo desarrollador profesional.",
      "category": "Programación",
      "subcategory": "Buenas Prácticas",
      "tags": ["programación", "código limpio", "desarrollo", "best practices"],
      "image": "https://i.ibb.co/1thDR0B8/clean-code.jpg",
      "weight": 0.8,
      "dimensions": "17x24 cm",
      "on_sale": true,
      "discount": 18,
      "featured": true,
      "new": false,
      "date_added": "2022-04-17"
    },
    {
      "id": 12,
      "name": "La creación de Dios tan Colorida",
      "title": "Reflexiones espirituales en mensaje poético",
      "author": "Blanca P. Hernández",
      "date_published": "2022-01-15",
      "price": 16.99,
      "original_price": 19.99,
      "isbn": "N.D.LDO21555",
      "stock": 35,
      "rating": 4.7,
      "reviews_count": 94,
      "language": "Español",
      "type": "Libro Físico",
      "formats": ["Tapa blanda"],
      "pages": 180,
      "publisher": "Editorial Mundo Hispano",
      "description":
          "Obra que explora reflexiones espirituales y filosóficas en un mensaje poético sobre la vida, el amor y la naturaleza.",
      "category": "Espiritualidad",
      "subcategory": "Poesía Espiritual",
      "tags": ["espiritualidad", "poesía", "naturaleza", "reflexión"],
      "image": "https://i.ibb.co/abc123/creacion-dios-colorida.jpg",
      "weight": 0.35,
      "dimensions": "13x19 cm",
      "on_sale": true,
      "discount": 15,
      "featured": true,
      "new": true,
      "date_added": "2023-02-28"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 0, // ← Fuerza el tab inicial
    );
    _selectedIndex = 0; // ← Inicia en el tab "Tipo"
    _tabController.addListener(() {
      if (_tabController.index < tabs.length) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadStatus();
    });
  }

  Future<void> loadStatus() async {
    setState(() => loading = true);
    try {
      await _initData(); // Carga datos generales (categorías)
      await _initTipoData(); // Carga datos específicos de "Tipo"
    } catch (e) {
      setState(() => loading = false);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration(milliseconds: 150),
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton.filled(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
                foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.pop(context);
            },
            splashColor: StyleColor.orange,
            color: StyleColor.white,
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
          title: Text("Librería Cristiana"),
          titleTextStyle: StylesApp(context)
              .textStyleBody20
              .copyWith(color: StyleColor.white),
          backgroundColor: StyleColor.turquoise,
        ),
        body: SafeArea(
          child: loading
              ? LoadingIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        decoration: BoxDecoration(
                            // border: Border.all(color: StyleColor.black),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              )
                            ]),
                        child: _buildTabBar()),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: CustomTabBarViewScrollPhysics(),
                        children: [
                          CustomHeaderBodyWidget(
                            header: SearchInputWidget(
                              placeholder:
                                  'Buscar ${tabs[_selectedIndex]["title"]}...',
                              getSuggestions: (query) => _getSuggestions(
                                  query, tabs[_selectedIndex]["title"]),
                              onSelected: _onSuggestionSelected,
                            ),
                            body: _buildSectionTab(booksForType),
                            padding: EdgeInsets.all(8.0),
                          ),
                          CustomHeaderBodyWidget(
                            header: SearchInputWidget(
                              placeholder:
                                  'Buscar ${tabs[_selectedIndex]["title"]}...',
                              getSuggestions: (query) => _getSuggestions(
                                  query, tabs[_selectedIndex]["title"]),
                              onSelected: _onSuggestionSelected,
                            ),
                            body: _buildSectionGrid(books),
                            padding: EdgeInsets.all(8.0),
                          ),
                          CustomHeaderBodyWidget(
                            header: SearchInputWidget(
                              placeholder:
                                  'Buscar ${tabs[_selectedIndex]["title"]}...',
                              getSuggestions: (query) => _getSuggestions(
                                  query, tabs[_selectedIndex]["title"]),
                              onSelected: _onSuggestionSelected,
                            ),
                            body: _buildSectionGrid(books),
                            padding: EdgeInsets.all(8.0),
                          ),
                          CustomHeaderBodyWidget(
                            header: SearchInputWidget(
                              placeholder:
                                  'Buscar ${tabs[_selectedIndex]["title"]}...',
                              getSuggestions: (query) => _getSuggestions(
                                  query, tabs[_selectedIndex]["title"]),
                              onSelected: _onSuggestionSelected,
                            ),
                            body: _buildSectionGrid(books),
                            padding: EdgeInsets.all(8.0),
                          ),
                          CustomHeaderBodyWidget(
                            header: GenericCoordinationWidget<ModelData>(
                              countryDropdown:
                                  CustomDropdownBottomWidget<ModelData>(
                                hintText: "Seleccione un país",
                                items: _listCountries,
                                onChanged: (newValue) =>
                                    setState(() => selectedCountry = newValue),
                                selectedItem: selectedCountry,
                              ),
                              currencyDropdown:
                                  CustomDropdownBottomWidget<ModelData>(
                                hintText: "Seleccione una moneda",
                                items: _lisCurrencies,
                                onChanged: (newValue) =>
                                    setState(() => selectedCurrency = newValue),
                                selectedItem: selectedCurrency,
                              ),
                              cityDropdown:
                                  CustomDropdownBottomWidget<ModelData>(
                                hintText: "Seleccione una ciudad",
                                items: _lisCities,
                                onChanged: (newValue) =>
                                    setState(() => selectedCity = newValue),
                                selectedItem: selectedCity,
                              ),
                              areaDropdown:
                                  CustomDropdownBottomWidget<ModelData>(
                                hintText: "Código",
                                items: _listAreasCode,
                                onChanged: (newValue) =>
                                    setState(() => selectedAreaCode = newValue),
                                selectedItem: selectedAreaCode,
                              ),
                              onRecipientNameChanged: (name) =>
                                  setState(() => recipientName = name),
                              onPhoneNumberChanged: (phone) =>
                                  setState(() => phoneNumber = phone),
                              padding: EdgeInsets.all(20),
                              // Personalización opcional:
                              // recipientNameLabel: "Nombre del receptor",
                              // phoneNumberLabel: "Teléfono de contacto",
                              // iconColor: Colors.blue,
                            ),
                            body: _buildTabCart(booksInCart),
                            padding: EdgeInsets.all(8.0),
                          ),
                        ],
                      ),
                    ),

                    // Center(
                    //   child: Text("Librería"),
                    // ),
                  ],
                ),
        ),
      ),
    );
  }

  _getSuggestions(value, String filter) {
    // switch (filter) {
    //   case "Mensaje":
    //     return books
    //         .where((element) =>
    //             element.title!.toLowerCase().contains(value.toLowerCase()))
    //         .map((e) => e.title);
    //   case "Predicador":
    //     return books
    //         .where((element) =>
    //             element.!.toLowerCase().contains(value.toLowerCase()))
    //         .map((e) => e.preachers);
    //   case "Favoritas":
    //     return books
    //         .where((element) =>
    //             element.preachers!
    //                 .toLowerCase()
    //                 .contains(value.toLowerCase()) ||
    //             element.title!.toLowerCase().contains(value.toLowerCase()))
    //         .map((e) => e.preachers!.toLowerCase().contains(value.toLowerCase())
    //             ? e.preachers
    //             : e.title);
    // }
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      isScrollable: true,
      physics: ClampingScrollPhysics(),
      unselectedLabelColor: Colors.white,
      labelColor: Colors.white,
      labelStyle: StylesApp(context).textStyleBody12,
      indicatorSize: TabBarIndicatorSize.label,
      automaticIndicatorColorAdjustment: true,
      indicatorWeight: 0,
      indicatorPadding: EdgeInsets.zero,
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.zero, // ← Clave para eliminar espacio inicial
      dividerColor: Color(0XFFFFFDFD),
      dividerHeight: 0,
      labelPadding: EdgeInsets.only(
        right: 8, // Espacio entre tabs
        left: 0, // Elimina espacio inicial
      ),
      indicator: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      tabs: tabs.asMap().entries.map((entry) {
        int index = entry.key;
        var tab = entry.value;
        return IntrinsicWidth(
          child: Tab(
            height: 35.sp,
            child: Container(
              margin: EdgeInsets.zero, // ← Asegúrate que no haya margen
              decoration: BoxDecoration(
                color: _selectedIndex == index ? Colors.orange : Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                    "${tab["title"]} ${tab["title"] == 'Carrito' ? '(${booksInCart.length})' : ''}"),
              ),
            ),
          ),
        );
      }).toList(),
    );
    //
  }

  Future<void> _initData() async {
    // for (var libro in books) {
    //   booksForCategory.putIfAbsent(libro['category'], () => []);
    //   booksForCategory[libro['category']]!.add(libro);
    // }

    // cargamos países
    _listCountries = Provider.of<CatalogueProvider>(context, listen: false)
        .allCountries
        .map<ModelData>((country) => ModelData(
            label: country.name, value: country.id, originalData: country))
        .toList();

    _listAreasCode = Provider.of<CatalogueProvider>(context, listen: false)
        .allAreasCode
        .map((area) => ModelData(label: area.code, value: area.id))
        .toList();
  }

  Future<void> _initTipoData() async {
    // Ejemplo: Los primeros 3 libros son "Novedades"
    booksForType["Novedades"] =
        books.where((book) => book['new'] == true).toList();

    // Ejemplo: Los siguientes 4 son "Más vendidos"
    booksForType["Más vendidos"] =
        books.where((book) => book['featured'] == true).toList();

    // El resto son "Más"
    booksForType["Más"] = books.skip(7).toList();
  }

  Future<void> getAllItemCart() async {}

  Widget _buildSectionTab(dataBooks) {
    final ScrollController scrollController = ScrollController();

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      thickness: 5.0,
      radius: Radius.circular(3.0),
      child: ListView.builder(
        controller: scrollController,
        itemCount: dataBooks.length,
        itemBuilder: (context, index) {
          String category = dataBooks.keys.elementAt(index);
          List<Map<String, dynamic>> booksCategories = dataBooks[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de categoría con fondo naranja
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                color: StyleColor.orange,
                child: Text(category,
                    style: StylesApp(context).textStyleBody14.copyWith(
                        color: StyleColor.white, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8),
              // Carrusel horizontal de libros
              SizedBox(
                height: 180, // Altura fija para el carrusel
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 10.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: booksCategories.length,
                    itemBuilder: (context, indexLibro) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailScreen(
                                  book: booksCategories[indexLibro]),
                            ),
                          );
                        },
                        child: Hero(
                          tag:
                              "book-image-$category-${booksCategories[indexLibro]['id'].toString()}",
                          child: Container(
                            width:
                                100, // Ancho fijo para cada item del carrusel
                            height: 110,
                            clipBehavior: Clip.antiAlias,
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              // border: Border.all(color: StyleColor.black),
                              borderRadius: BorderRadius.circular(8.0),
                              color: StyleColor.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 4.0,
                                  color:
                                      StyleColor.black.withValues(alpha: 0.25),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(
                                  booksCategories[indexLibro]['image'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -10,
                                  right: -6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: StyleColor.black
                                          .withValues(alpha: 0.25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      iconSize: 16,
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.info_outline,
                                          color: StyleColor.white, size: 18),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              DetailBookWidget(
                                                  bookCategory: booksCategories[
                                                      indexLibro]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionGrid(List<Map<String, dynamic>> books) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: kBottomNavigationBarHeight,
      ),
      scrollDirection: Axis.vertical,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 4.0,
          runSpacing: 10.0,
          children: [
            ...books.map(
              (book) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(book: book),
                      ),
                    );
                  },
                  child: Hero(
                    tag:
                        'book-image-${book['id']}', // Tag único para cada libro
                    child: Container(
                      width: 100, // Ancho fijo para cada item del carrusel
                      height: 130,
                      clipBehavior: Clip.antiAlias,
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        // border: Border.all(color: StyleColor.black),
                        borderRadius: BorderRadius.circular(8.0),
                        color: StyleColor.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 4.0,
                            color: StyleColor.black.withValues(alpha: 0.25),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            book['image'] ?? 'https://via.placeholder.com/150',
                          ),
                          onError: (exception, stackTrace) {
                            // Handle the error, e.g., log it or show a placeholder
                            debugPrint('Image load error: $exception');
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -10,
                            right: -6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: StyleColor.black.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: 16,
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.info_outline,
                                    color: StyleColor.white, size: 18),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        DetailBookWidget(bookCategory: book),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabCart(dataBooks) {
    return StatefulBuilder(builder: (context, setState) {
      void updateSelectedCount() {
        setState(() {});
      }

      int selectedCount =
          dataBooks.where((book) => book['selected'] == true).length;
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dataBooks.length,
              itemBuilder: (context, index) {
                TextEditingController quantityNumber =
                    TextEditingController(text: "1");

                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 115),
                    decoration:
                        BoxDecoration(color: StyleColor.white, boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 4),
                          color: StyleColor.black.withValues(alpha: 0.25),
                          blurRadius: 4)
                    ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alinea todos los elementos al inicio
                      children: [
                        // Imagen
                        SizedBox(
                          width: 80,
                          child: Image.network(
                            dataBooks[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Contenido principal
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Primera fila: Títulos y badges
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Título
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        dataBooks[index]['title'],
                                        style: StylesApp(context)
                                            .textStyleBody16
                                            .copyWith(
                                              color: StyleColor.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    SizedBox(width: 8),

                                    // Badges
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 5.0),
                                            decoration: BoxDecoration(
                                                color: Color(0XFF217FEA),
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            child: Text(
                                              dataBooks[index]['type'] ?? '',
                                              style: StylesApp(context)
                                                  .textStyleBody12,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 5.0),
                                            decoration: BoxDecoration(
                                                color: StyleColor.orange,
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            child: Text(
                                              '${dataBooks[index]['price']} USD',
                                              style: StylesApp(context)
                                                  .textStyleBody12,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: // Botón more_vert en la parte superior
                                          IconButton(
                                        icon: Icon(Icons.more_vert,
                                            color: StyleColor.grayMedium,
                                            size: 24),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: Icon(
                                                        Icons.info_outline),
                                                    title: Text('Ver detalle'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            DetailBookWidget(
                                                          bookCategory:
                                                              dataBooks[index],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: Icon(Icons.delete),
                                                    title: Text(
                                                        'Borrar del carrito'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        dataBooks
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(height: 16),

                                // Segunda fila: Precio Original y controles de cantidad
                                Row(
                                  children: [
                                    // Precio Original
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 5.0),
                                      decoration: BoxDecoration(
                                          color: StyleColor.grayMedium,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Text(
                                        '${dataBooks[index]['original_price']} USD',
                                        style:
                                            StylesApp(context).textStyleBody12,
                                      ),
                                    ),

                                    Spacer(),

                                    // Controles de cantidad
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove, size: 20),
                                            onPressed: () {
                                              int currentValue = int.tryParse(
                                                      quantityNumber.text) ??
                                                  1;
                                              if (currentValue > 1) {
                                                quantityNumber.text =
                                                    (currentValue - 1)
                                                        .toString();
                                              }
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                          ),
                                          SizedBox(
                                            width: 25,
                                            child: TextField(
                                              controller: quantityNumber,
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add, size: 20),
                                            onPressed: () {
                                              int currentValue = int.tryParse(
                                                      quantityNumber.text) ??
                                                  1;
                                              quantityNumber.text =
                                                  (currentValue + 1).toString();
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                      activeColor: StyleColor.turquoise,
                                      value:
                                          dataBooks[index]['selected'] ?? false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          dataBooks[index]['selected'] =
                                              value ?? false;
                                        });
                                        updateSelectedCount();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ButtonThemeWidget(
              text:
                  "Proceder al pago ${selectedCount > 0 ? '($selectedCount)' : ''}",
              buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                    backgroundColor:
                        WidgetStatePropertyAll(StyleColor.yellowLight),
                    textStyle: WidgetStatePropertyAll(StylesApp(context)
                        .textStyleBody14
                        .copyWith(color: StyleColor.white)),
                  ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryCoordinationScreen(),
                  ),
                );
              },
            ),
          )
        ],
      );
    });
  }

  void _onSuggestionSelected(String p1) {}
}

class DetailBookWidget extends StatelessWidget {
  const DetailBookWidget({
    super.key,
    required this.bookCategory,
  });

  final Map<String, dynamic> bookCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            "Descripción del libro",
            style: StylesApp(context)
                .textStyleBody18
                .copyWith(color: StyleColor.black),
          ),
          SizedBox(height: 25),
          Text(
            bookCategory['description'] ?? "Sin descripción disponible",
            style: StylesApp(context)
                .textStyleBody14
                .copyWith(color: StyleColor.grayMedium),
          ),
        ],
      ),
    );
  }
}
