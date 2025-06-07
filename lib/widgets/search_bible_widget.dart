import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBibleWidget extends StatefulWidget {
  const SearchBibleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBibleWidget> createState() => _SearchBibleWidgetState();
}

class _SearchBibleWidgetState extends State<SearchBibleWidget> {
  var _selectedIndex = 0;
  List tabs = [
    {
      "title": 'Libro',
      "placeholder": 'Mensaje a buscar',
    },
    {
      "title": 'Texto',
      "placeholder": 'Nombre del predicador a buscar',
    },
    {
      "title": 'Tema',
      "placeholder": 'Favorito a buscar',
    },
    {
      "title": 'Personajes',
      "placeholder": 'Favorito a buscar',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppBarHeaderWidget(
                backColor: StyleColor.turquoise,
                buttonColor: StyleColor.orange,
                textButtonColor: Colors.white,
                title: 'Búsqueda',
                styleText: StylesApp(context).textStyleBody7,
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(right: 65),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  )
                ]),
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  labelStyle: StylesApp(context).textStyleBody12,
                  indicatorSize: TabBarIndicatorSize.tab,
                  automaticIndicatorColorAdjustment: true,
                  indicatorWeight: 0,
                  indicatorPadding: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  dividerColor: Color(0XFFFFFDFD),
                  dividerHeight: 0,
                  labelPadding: EdgeInsets.symmetric(horizontal: 2),
                  indicator: BoxDecoration(
                    color: Colors.orange, // Color de la pestaña seleccionada
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ), // Bordes redondeados
                  ),
                  tabs: tabs.asMap().entries.map((entry) {
                    int index = entry.key;
                    var tab = entry.value;
                    return Tab(
                      height: 32.sp,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.orange
                              : Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Center(child: Text(tab["title"])),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Lista de mensajes
              Expanded(
                child: TabBarView(
                  children: [
                    Container(),
                    Container(),
                    Container(),
                    Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}