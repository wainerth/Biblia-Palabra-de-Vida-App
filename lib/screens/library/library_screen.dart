import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  var _selectedIndex = 0;
  late TabController _tabController;
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
  Map<String, List<Map<String, dynamic>>> librosPorCategoria = {};
  List<Map<String, dynamic>> books = [
    {
      "id": 1,
      "nombre": "Flutter en Acción",
      "title": "Guía completa de desarrollo Flutter",
      "descripcion": "Aprende desarrollo móvil con Flutter desde cero.",
      "categoria": "Programación",
      "imagen": "https://i.ibb.co/ynyK9dxc/flutter-accion.jpg"
    },
    {
      "id": 2,
      "nombre": "Dart: Desde Cero",
      "title": "Domina el lenguaje de Flutter",
      "descripcion": "Domina el lenguaje Dart para desarrollo Flutter.",
      "categoria": "Programación",
      "imagen": "https://i.ibb.co/zWWs2R4y/dart-desde-cero.jpg"
    },
    {
      "id": 3,
      "nombre": "El Principito",
      "title": "Clásico de la literatura universal",
      "descripcion":
          "Clásico de la literatura francesa con profundas reflexiones.",
      "categoria": "Literatura",
      "imagen": "https://i.ibb.co/BVRZ2QLS/principito.jpg"
    },
    {
      "id": 4,
      "nombre": "Cien Años de Soledad",
      "title": "Obra maestra de García Márquez",
      "descripcion":
          "Obra maestra del realismo mágico de Gabriel García Márquez.",
      "categoria": "Literatura",
      "imagen": "https://i.ibb.co/399vxphj/cien-anos-soledad.jpg"
    },
    {
      "id": 5,
      "nombre": "El Arte de la Guerra",
      "title": "Estrategias milenarias",
      "descripcion": "Tratado militar clásico con aplicaciones modernas.",
      "categoria": "Estrategia",
      "imagen": "https://i.ibb.co/vCvM34TF/arte-guerra.jpg"
    },
    {
      "id": 6,
      "nombre": "Padre Rico, Padre Pobre",
      "title": "Educación financiera esencial",
      "descripcion": "Clásico de educación financiera personal.",
      "categoria": "Finanzas",
      "imagen": "https://i.ibb.co/nq7nhgqP/padre-rico.jpg"
    },
    {
      "id": 7,
      "nombre": "Atomic Habits",
      "title": "Hábitos para el éxito",
      "descripcion": "Cómo construir buenos hábitos y romper malos.",
      "categoria": "Desarrollo Personal",
      "imagen": "https://i.ibb.co/v4mmCttZ/atomic-habits.jpg"
    },
    {
      "id": 8,
      "nombre": "El Poder del Ahora",
      "title": "Vive en el presente",
      "descripcion": "Guía para la iluminación espiritual.",
      "categoria": "Espiritualidad",
      "imagen": "https://i.ibb.co/XZxym9FM/poder-ahora.jpg"
    },
    {
      "id": 9,
      "nombre": "Sapiens",
      "title": "Historia de la humanidad",
      "descripcion": "Breve historia de la humanidad.",
      "categoria": "Historia",
      "imagen": "https://i.ibb.co/pvcvYJ2j/sapiens.jpg"
    },
    {
      "id": 10,
      "nombre": "El Universo en una Cáscara de Nuez",
      "title": "Los secretos del cosmos",
      "descripcion": "Exploración de los misterios del cosmos.",
      "categoria": "Ciencia",
      "imagen": "https://i.ibb.co/chvzphwG/universo-cascara.jpg"
    },
    {
      "id": 11,
      "nombre": "Clean Code",
      "title": "Código limpio, desarrollo eficiente",
      "descripcion": "Principios para escribir código limpio y mantenible.",
      "categoria": "Programación",
      "imagen": "https://i.ibb.co/1thDR0B8/clean-code.jpg"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.offset != 0) {
        _tabController.animateTo(0);
      }
      _initData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.all(0.0),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return _getSuggestions(
                      textEditingValue.text, tabs[_selectedIndex]["title"]);
                },
                onSelected: (String selection) {
                  if (kDebugMode) {
                    print('You just selected $selection');
                  }
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: tabs[_selectedIndex]["placeholder"],
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                _buildSectionTab(),
                _buildSectionTab(),
                _buildSectionTab(),
                _buildSectionTab(),
                _buildSectionTab(),
              ]),
            ),
            // Center(
            //   child: Text("Librería"),
            // ),
          ],
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
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Detecta cambios de scroll
        return false;
      },
      child: TabBar(
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
                      "${tab["title"]} ${tab["title"] == 'Carrito' ? '(${5})' : ''}"),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
    //
  }

  void _initData() {
    for (var libro in books) {
      librosPorCategoria.putIfAbsent(libro['categoria'], () => []);
      librosPorCategoria[libro['categoria']]!.add(libro);
    }
  }

  Widget _buildSectionTab() {
    return ListView.builder(
      itemCount: librosPorCategoria.length,
      itemBuilder: (context, index) {
        String categoria = librosPorCategoria.keys.elementAt(index);
        List<Map<String, dynamic>> librosCategoria =
            librosPorCategoria[categoria]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de categoría con fondo naranja
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: Colors.orange,
              child: Text(
                categoria,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            // Carrusel horizontal de libros
            Container(
              height: 180, // Altura fija para el carrusel
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: librosCategoria.length,
                itemBuilder: (context, indexLibro) {
                  return Container(
                    width: 160, // Ancho fijo para cada item del carrusel
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: Image.network(
                                  librosCategoria.isNotEmpty
                                      ? librosCategoria[indexLibro]['imagen']
                                      : '',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.book,
                                        size: 50, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Text(
                                librosCategoria[indexLibro]['nombre'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                librosCategoria[indexLibro]['descripcion'],
                                style: TextStyle(fontSize: 12),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
