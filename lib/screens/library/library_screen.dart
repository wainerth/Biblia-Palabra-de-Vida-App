import 'package:biblia_palabra_de_vida_app/api_rest/endpoint/book_endpoints.dart';
import 'package:biblia_palabra_de_vida_app/api_rest/endpoint/cart_endpoints.dart';
import 'package:biblia_palabra_de_vida_app/models/library/index.dart';
import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/screens/library/delivery_coordination_screen.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  Map<String, List<BookModel>> booksForType = {};

  ShoppingCartModel? userCart;

  List<CartItemModel> booksInCart = [];
  List<BookModel> books = [];

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadStatus();
    });
  }

  Future<void> loadStatus() async {
    setState(() => loading = true);
    try {
      // cargamos todos los libros para luego filtrar
      await loadBooks();

      // Carga datos generales
      await _initData();

      loadCart();

      // Carga datos específicos de "Tipo"
      await _initTipoData();
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
          maintainBottomViewPadding: true,
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
                    "${tab["title"]} ${tab["title"] == 'Carrito' ? '(${userCart?.total_items ?? 0})' : ''}"),
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
        books.where((book) => book.isNewRelease == true).toList();

    // Ejemplo: Los siguientes 4 son "Más vendidos"
    booksForType["Más vendidos"] =
        books.where((book) => book.isBestseller == true).toList();

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
          List<BookModel> booksCategories = dataBooks[category]!;

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
                              "book-image-$category-${booksCategories[indexLibro].id.toString()}",
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
                                  booksCategories[indexLibro].coverImageUrl ??
                                      'https://via.placeholder.com/150',
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
              SizedBox(height: 25),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionGrid(List<BookModel> books) {
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
                    tag: 'book-image-${book.id}', // Tag único para cada libro
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
                            book.coverImageUrl ??
                                'https://via.placeholder.com/150',
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

  Widget _buildTabCart(List<CartItemModel> dataBooks) {
    return StatefulBuilder(builder: (context, setState) {
      void updateSelectedCount() {
        setState(() {});
      }

      int selectedCount =
          dataBooks.where((book) => book.selected == true).length;
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dataBooks.length,
              itemBuilder: (context, index) {
                TextEditingController quantityNumber = TextEditingController(
                    text: dataBooks[index].quantity.toString());

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
                            dataBooks[index].book?.coverImageUrl ??
                                'https://via.placeholder.com/150',
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
                                        dataBooks[index].book?.title ??
                                            'Título no disponible',
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
                                              displayName(dataBooks[index]
                                                      .format_type ??
                                                  ''),
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
                                              "${getFormattedPrice((dataBooks[index].unit_price! * dataBooks[index].quantity).toString() ?? 0.toString())} USD",
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
                                            useSafeArea: true,
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: Icon(
                                                        Icons.info_outline),
                                                    title: Text('Ver detalle'),
                                                    onTap: () async {
                                                      _showDetailBook(
                                                          context,
                                                          int.parse(
                                                              dataBooks[index]
                                                                  .book_id));
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
                                                  SizedBox(
                                                    height:
                                                        kBottomNavigationBarHeight +
                                                            20,
                                                  )
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
                                  spacing: 5.0,
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
                                        softWrap: true,
                                        maxLines: 2,
                                        getFormattedPrice(dataBooks[index]
                                            .unit_price
                                            .toString()),
                                        style:
                                            StylesApp(context).textStyleBody12,
                                      ),
                                    ),

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
                                    Expanded(
                                      child: Checkbox(
                                        activeColor: StyleColor.turquoise,
                                        value:
                                            dataBooks[index].selected ?? false,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            dataBooks[index] = dataBooks[index]
                                                .copyWith(
                                                    selected: value ?? false);
                                          });
                                          updateSelectedCount();
                                        },
                                      ),
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

  // Función para leer el carrito del usuario
  void loadCart() async {
    final cartEndpoints = CartEndpoints();
    final response = await cartEndpoints.getCart();
    if (response.error != null) {
      debugPrint('Error al cargar el carrito: ${response.error}');
      // Aquí podrías mostrar un mensaje de error al usuario usando un SnackBar, Dialog, etc.
      return;
    }

    userCart = ShoppingCartModel.fromJson(response.data);

    print(userCart);
    setState(() {
      booksInCart = userCart!.items;
    });
  }

  Future<void> loadBooks() async {
    final booksEndpoints = BookEndpoints();
    final result = await booksEndpoints.getBooks();
    if (result.error != null) {
      debugPrint('Error al cargar los libros: ${result.error}');
      // Aquí podrías mostrar un mensaje de error al usuario usando un SnackBar, Dialog, etc.
      return;
    }
    setState(() {
      books = result.data
          .map<BookModel>((book) => BookModel.fromJson(book))
          .toList();
    });
  }

  void _showDetailBook(BuildContext context, int bookId) async {
    final bookEndpoint = BookEndpoints();
    final responseBook = await bookEndpoint.getBookById(bookId);
    if (responseBook.error != null) {
      debugPrint('Error al cargar el libro: ${responseBook.error}');
      // Aquí podrías mostrar un mensaje de error al usuario usando un SnackBar, Dialog, etc.
      return;
    }
    final bookDetail = BookModel.fromJson(responseBook.data);

    Navigator.pop(context);
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) => DetailBookWidget(
        bookCategory: bookDetail,
      ),
    );
  }
}

class DetailBookWidget extends StatelessWidget {
  const DetailBookWidget({
    super.key,
    required this.bookCategory,
  });

  final BookModel bookCategory;

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
            bookCategory.description ?? "Sin descripción disponible",
            style: StylesApp(context)
                .textStyleBody14
                .copyWith(color: StyleColor.grayMedium),
          ),
        ],
      ),
    );
  }
}
