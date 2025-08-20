import 'dart:ui';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ModelData> _listCountries = [];
  List<ModelData> _lisCurrencies = [
    ModelData(label: "USD", value: "1"),
    ModelData(label: "UYU", value: "2"),
    ModelData(label: "COP", value: "3"),
    ModelData(label: "BS", value: "1"),
  ];
  ModelData? selectedCountry;
  ModelData? selectedCurrency;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 21,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con Hero animation
                Hero(
                  tag:
                      'book-image-${widget.book['id']}', // Mismo tag que en la lista
                  child: SizedBox(
                    width: 122,
                    height: 134,
                    child: Image.network(
                      widget.book['image'],
                      height: 134,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    // padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book['title'] ?? 'Título no disponible',
                          style: StylesApp(context).textStyleBody16.copyWith(
                              color: StyleColor.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.book['author'] ?? 'Autor no disponible',
                          style: StylesApp(context).textStyleBody16.copyWith(
                              color: StyleColor.greenDark,
                              fontWeight: FontWeight.bold),
                        ),
                        Text.rich(TextSpan(
                          text: "Publicado: ",
                          style: StylesApp(context).textStyleBody14.copyWith(
                              color: StyleColor.grayDark,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: "${widget.book['date_published'] ?? 'N/A'}",
                            ),
                          ],
                        )),
                        Text.rich(TextSpan(
                          text: "Editorial: ",
                          style: StylesApp(context).textStyleBody14.copyWith(
                              color: StyleColor.grayDark,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: "${widget.book['publisher'] ?? 'N/A'}",
                              style: StylesApp(context)
                                  .textStyleBody16
                                  .copyWith(
                                      color: StyleColor.grayDark,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        Text.rich(TextSpan(
                          text: "ISBN: ",
                          style: StylesApp(context).textStyleBody14.copyWith(
                              color: StyleColor.grayDark,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: "${widget.book['isbn'] ?? 'N/A'}",
                              style: StylesApp(context)
                                  .textStyleBody16
                                  .copyWith(
                                      color: StyleColor.grayDark,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        Text.rich(TextSpan(
                          text: "Tipo: ",
                          style: StylesApp(context).textStyleBody14.copyWith(
                              color: StyleColor.grayDark,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: "${widget.book['type'] ?? 'N/A'}",
                              style: StylesApp(context)
                                  .textStyleBody16
                                  .copyWith(
                                      color: StyleColor.grayDark,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Row(
                children: [
                  Text(
                    "Resumen",
                    style: StylesApp(context).textStyleBody14.copyWith(
                        color: StyleColor.turquoise,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.0),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < (widget.book['rating'] ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: StyleColor.orange,
                        size: 20,
                      );
                    }),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "(${widget.book['rating'] ?? 0})",
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: StyleColor.grayDark,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 4.0,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    decoration: BoxDecoration(
                      color: StyleColor.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: StyleColor.black.withValues(alpha: 0.2),
                          blurRadius: 4.0,
                          offset:
                              Offset(0, 2), // Cambia la dirección de la sombra
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minHeight: 146,
                    ),
                    child: Text(
                      widget.book['description'],
                      style: StylesApp(context)
                          .textStyleBody12
                          .copyWith(color: StyleColor.black),
                    ),
                  ),
                ),
              ),
            ),
            GenericCoordinationWidget<ModelData>(
              countryDropdown: CustomDropdownBottomWidget<ModelData>(
                hintText: "Seleccione un país",
                items: _listCountries,
                onChanged: (newValue) =>
                    setState(() => selectedCountry = newValue),
                selectedItem: selectedCountry,
              ),
              currencyDropdown: CustomDropdownBottomWidget<ModelData>(
                hintText: "Seleccione una moneda",
                items: _lisCurrencies,
                onChanged: (newValue) =>
                    setState(() => selectedCurrency = newValue),
                selectedItem: selectedCurrency,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.0),
              child: Column(
                children: [
                  // AudioLibro
                  BookFormatCard(
                    formatType: 'Audiolibro',
                    sampleText: 'Muestra',
                    bookmarkColor: StyleColor.blueMedium,
                    price: '2.04 USD',
                    onAddToCart: () {
                      // Lógica para agregar audiolibro al carrito
                      print('Agregar audiolibro al carrito');
                    },
                    onBuy: () {
                      // Lógica para comprar audiolibro
                      print('Comprar audiolibro');
                    },
                  ),
                  SizedBox(height: 9),
                  // Online (PDF)
                  BookFormatCard(
                    formatType: 'Online',
                    bookmarkColor: StyleColor.cyanMedium,
                    sampleText: 'Muestra',
                    price: '2.04 USD',
                    onAddToCart: () {
                      // Lógica para agregar versión online al carrito
                      print('Agregar versión online al carrito');
                    },
                    onBuy: () {
                      // Lógica para comprar versión online
                      print('Comprar versión online');
                    },
                  ),
                  SizedBox(height: 9),
                  // Libro físico
                  BookFormatCard(
                    formatType: 'Libro',
                    bookmarkColor: StyleColor.greenLight,
                    sampleText: 'Quedan',
                    price: '20,09 USD',
                    hasShippingCosts: true,
                    onAddToCart: () {
                      // Lógica para agregar libro físico al carrito
                      print('Agregar libro físico al carrito');
                    },
                    onBuy: () {
                      // Lógica para comprar libro físico
                      print('Comprar libro físico');
                    },
                  ),
                ],
              ),
            ),
              SizedBox(height: 12.0),

          ],
        ),
      ),
    );
  }

  Future<void> _initData() async {
    _listCountries = Provider.of<CatalogueProvider>(context, listen: false)
        .allCountries
        .map<ModelData>((country) => ModelData(
            label: country.country, value: country.id, originalData: country))
        .toList();
  }
}

class BookFormatCard extends StatelessWidget {
  final String formatType;
  final String sampleText;
  final String price;
  final bool hasShippingCosts;
  final Color bookmarkColor;
  final bool isSelected;
  final VoidCallback onAddToCart;
  final VoidCallback onBuy;

  const BookFormatCard({
    super.key,
    required this.formatType,
    required this.sampleText,
    required this.bookmarkColor,
    required this.price,
    this.hasShippingCosts = false,
    this.isSelected = false,
    required this.onAddToCart,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      // margin: EdgeInsets.symmetric(vertical: 8),
      constraints: BoxConstraints(
        minHeight: 80,
      ),
      decoration: BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              spacing: 2.0,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(
                      minHeight: 40,
                      maxHeight: 40,
                      minWidth: 30,
                      maxWidth: 90,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width:
                                double.infinity, // Ocupa todo el ancho disponible
                            height: double
                                .infinity, // Ocupa toda la altura disponible
                            child: SvgPicture.asset(
                              'assets/book_format.svg',
                              fit: BoxFit.cover,
                              color: bookmarkColor,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 1,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text(formatType,
                                style: StylesApp(context).textStyleBody10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Muestra
                Expanded(flex: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: StyleColor.galaxyPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          sampleText,
                          style: StylesApp(context).textStyleBody10,
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.visibility, size: 16, color: StyleColor.white),
                      ],
                    ),
                  ),
                ),

                // Precio
                Expanded(flex: 4,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: StyleColor.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        price,
                        style: StylesApp(context).textStyleBody10,
                      )),
                ),
                // Botones
                Expanded(flex: 4,
                  child: Container(
                   
                    child: Column(
                      children: [
                        SizedBox(
                          width: 100, // Mismo ancho que el botón Agregar
                          height: 30,
                          child: IconTextButton(
                            icon: Icons.shopping_cart,
                            padding:
                                EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            text: 'Agregar',
                            iconPosition: 'right',
                            onPressed: onAddToCart,
                            iconSize: 15,
                            style: StylesApp(context).textStyleBody10.copyWith(
                                  color: StyleColor.white,
                                ),
                            backgroundColor: StyleColor.turquoise,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width:100 , // Mismo ancho que el botón Agregar
                          height: 30,
                          child: IconTextButton(
                            noIcon: false,
                            padding:
                                EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            text: 'Comprar',
                            onPressed: () {},
                            style: StylesApp(context).textStyleBody10.copyWith(
                                  color: StyleColor.white,
                                ),
                            backgroundColor: StyleColor.yellowLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Costos de envío (solo para algunos formatos)
            if (hasShippingCosts) ...[
              SizedBox(height: 8),
              Text(
                'Puede aplicar costos adicionales de envío',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 47, 13, 196)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Sombra para la flecha
    final shadowPath = Path();
    shadowPath.moveTo(0, 0);
    shadowPath.lineTo(size.width / 2, size.height);
    shadowPath.lineTo(size.width, 0);

    canvas.drawShadow(shadowPath, Colors.black12, 2, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color.fromARGB(255, 112, 18, 18);
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class IconTextButton extends StatelessWidget {
  final IconData? icon;
  final bool noIcon;
  final String text;
  final VoidCallback onPressed;
  final TextStyle? style;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final String iconPosition; // 'left' or 'right'
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const IconTextButton({
    super.key,
    this.icon,
    this.noIcon = true,
    required this.text,
    required this.onPressed,
    this.style,
    this.backgroundColor,
    this.iconPosition = 'left',
    this.iconColor,
    this.iconSize = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPosition == 'left' && noIcon) ...[
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? style?.color ?? Colors.white,
            ),
            SizedBox(width: 8), // Espacio entre icono y texto
          ],
          Text(
            text,
            style: style ??
                TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
          if (iconPosition == 'right' && noIcon) ...[
            SizedBox(width: 8), // Espacio entre icono y texto
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? style?.color ?? Colors.white,
            ),
          ],
        ],
      ),
    );
  }
}
