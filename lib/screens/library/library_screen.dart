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
  List books = [];

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
                    border: Border.all(color: StyleColor.black),
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
              child: TabBarView(
                controller: _tabController,
                children: [
                Text(tabs[_selectedIndex]['title']),
                Text(tabs[_selectedIndex]['title']),
                Text(tabs[_selectedIndex]['title']),
                Text(tabs[_selectedIndex]['title']),
                Text(tabs[_selectedIndex]['title']),
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
    switch (filter) {
      case "Mensaje":
        return books
            .where((element) =>
                element.title!.toLowerCase().contains(value.toLowerCase()))
            .map((e) => e.title);
      case "Predicador":
        return books
            .where((element) =>
                element.preachers!.toLowerCase().contains(value.toLowerCase()))
            .map((e) => e.preachers);
      case "Favoritas":
        return books
            .where((element) =>
                element.preachers!
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.title!.toLowerCase().contains(value.toLowerCase()))
            .map((e) => e.preachers!.toLowerCase().contains(value.toLowerCase())
                ? e.preachers
                : e.title);
    }
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
          // double tabWidth = double.parse(tab['title'].length.toString());
          return IntrinsicWidth(
            child: Tab(
              height: 32.sp,
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
}
