import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:biblia_palabra_de_vida_app/api_rest/endpoint/cart_endpoints.dart';

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';

import 'package:biblia_palabra_de_vida_app/models/library/index.dart';
import 'package:biblia_palabra_de_vida_app/models/model_data.dart';

import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';

import 'package:biblia_palabra_de_vida_app/widgets/book_format_card.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

// ============================================
// CONSTANTES
// ============================================
const _kBottomNavBarHeight = 20.0;
const _kBookImageWidth = 122.0;
const _kBookImageHeight = 200.0;
const _kStarSize = 29.0;
const _kShadowBlurRadius = 4.0;
const _kShadowOffset = Offset(0, 2);
const _kMinDescriptionHeight = 146.0;

const _monthNames = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre'
];

class BookDetailScreen extends StatefulWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  // controles
  final ScrollController _scrollController = ScrollController();

  // Estado
  List<ModelData> _listCountries = [];
  ModelData? selectedCountry;
  ModelData? selectedCurrency;

  // Constantes
  final List<ModelData> _lisCurrencies = [
    ModelData(label: "USD", value: "1"),
    ModelData(label: "UYU", value: "2"),
    ModelData(label: "COP", value: "3"),
    ModelData(label: "BS", value: "1"),
  ];

  final List<Color> booKmarkColor = [
    StyleColor.blueMedium,
    StyleColor.cyanMedium,
    StyleColor.greenLight,
  ];

// ============================================
// CICLO DE VIDA
// ============================================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initData());
  }

  // ============================================
  // MÉTODOS DE CÁLCULO Y FORMATO
  // ============================================
  double getAverageRating(List<ReviewModel>? reviews) {
    if (reviews == null || reviews.isEmpty) return 0;

    final sum =
        reviews.fold<int>(0, (total, review) => total + (review.rating ?? 0));
    return sum / reviews.length;
  }

  String _formatPublishedDate(String? publishedDate) {
    if (publishedDate == null || publishedDate.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(publishedDate);
      final month = _monthNames[date.month - 1];
      return '${date.day} $month  ${date.year}';
    } catch (_) {
      return publishedDate;
    }
  }

  String? _formatIsbn(String? isbn) {
    if (isbn == null || isbn.isEmpty) return null;

    final cleanIsbn = isbn.replaceAll('-', '').replaceAll(' ', '');

    if (cleanIsbn.length == 10) {
      return '${cleanIsbn.substring(0, 1)}-${cleanIsbn.substring(1, 4)}-'
          '${cleanIsbn.substring(4, 9)}-${cleanIsbn.substring(9)}';
    } else if (cleanIsbn.length == 13) {
      return '${cleanIsbn.substring(0, 3)}-${cleanIsbn.substring(3, 13)}';
    }

    return isbn;
  }

// ============================================
// MÉTODOS DE ACCIÓN
// ============================================
  Future<void> _initData() async {
    final catalogueProvider =
        Provider.of<CatalogueProvider>(context, listen: false);
    setState(() {
      _listCountries = catalogueProvider.allCountries
          .map((country) => ModelData(
                label: country.name,
                value: country.id,
                originalData: country,
              ))
          .toList();
    });
  }

  Future<void> _handleAddToCart(BookFormat form, int quantity) async {
    // try {
      // llamamos post para agregar al carrito
      final cartEndpoints = CartEndpoints();
      final response = await cartEndpoints.addToCart(
        form.bookId.toString(),
        form.id.toString(),
        quantity,
      );

      if (response.error != null) {
        await showCustomDialog(context,
            message: response.userFriendlyError!,
            dialogType: DialogType.error,
            showDetails: true,
            messageDetail: response.error!);
      }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print('Error al agregar al carrito: $e');
    //   }
    // }
  }

  void _showSample(BookFormat form) {
    // consultamos la preview de pdf o audio dependiendo del formato
    if (form.fileUrl != null) {
      // Lógica para mostrar la muestra del formato
      if (kDebugMode) {
        print('Mostrar muestra de ${form.formatType.displayName}');
      }
    } else {
      if (kDebugMode) {
        print('No hay muestra disponible para ${form.formatType.displayName}');
      }
    }
  }

// ============================================
  // MÉTODOS DE CONSTRUCCIÓN DE UI
  // ============================================

  Widget _buildRatingStars(double averageRating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < averageRating.floor()) {
          return const Icon(Icons.star,
              color: StyleColor.orange, size: _kStarSize);
        } else if (index < averageRating.ceil() && averageRating % 1 != 0) {
          return const Icon(Icons.star_half,
              color: StyleColor.orange, size: _kStarSize);
        } else {
          return const Icon(Icons.star_border,
              color: StyleColor.orange, size: _kStarSize);
        }
      }),
    );
  }

  Widget _buildBookHeader(double averageRating) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookImage(),
          const SizedBox(width: 8.0),
          Expanded(child: _buildBookInfo(averageRating)),
        ],
      ),
    );
  }

  Widget _buildBookImage() {
    return Hero(
      tag: 'book-image-${widget.book.id}',
      child: SizedBox(
        width: _kBookImageWidth,
        height: _kBookImageHeight,
        child: Image.network(
          widget.book.coverImageUrl ??
              'https://via.placeholder.com/122x134.png?text=No+Image',
          height: _kBookImageHeight,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _buildBookInfo(double averageRating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.book.title ?? 'Título no disponible',
          style: StylesApp(context).textStyleBody16.copyWith(
                color: StyleColor.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          widget.book.author ?? 'Autor no disponible',
          style: StylesApp(context).textStyleBody14.copyWith(
                color: StyleColor.greenDark,
                fontWeight: FontWeight.bold,
              ),
        ),
        _buildInfoRow('Publicado: ',
            _formatPublishedDate(widget.book.publishedDate.toString())),
        _buildInfoRow('Editorial: ', widget.book.publisher ?? 'N/A'),
        _buildInfoRow('ISBN: ', _formatIsbn(widget.book.isbn) ?? 'N/A'),
        _buildInfoRow(
          'Tipo: ',
          widget.book.formats!
              .map((form) => form.formatType.displayName)
              .join(" / "),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Text.rich(
      TextSpan(
        text: label,
        style: StylesApp(context).textStyleBody14.copyWith(
              color: StyleColor.grayDark,
              fontWeight: FontWeight.bold,
            ),
        children: [
          TextSpan(
            text: value,
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: StyleColor.grayDark,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(double averageRating) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Row(
        children: [
          Text(
            "Resumen",
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: StyleColor.turquoise,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8.0),
          _buildRatingStars(averageRating),
          const SizedBox(width: 8.0),
          if (averageRating > 0)
            Text(
              "(${averageRating.toStringAsFixed(1)})",
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: StyleColor.grayDark,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
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
                  blurRadius: _kShadowBlurRadius,
                  offset: _kShadowOffset,
                ),
              ],
            ),
            constraints:
                const BoxConstraints(minHeight: _kMinDescriptionHeight),
            child: Text(
              widget.book.description ??
                  'No hay descripción disponible para este libro.',
              style: StylesApp(context).textStyleBody12.copyWith(
                    color: StyleColor.black,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9.0),
      child: Column(
        children: widget.book.formats!.asMap().entries.map((entry) {
          final index = entry.key;
          final format = entry.value;

          return BookFormatCard(
            formatType: format.formatType.displayName,
            sampleText: "Muestra",
            disabledBtn: format.stock <= 0,
            bookmarkColor: booKmarkColor[index % booKmarkColor.length],
            price: format.price.toString(),
            onAddToCart: () => _handleAddToCart(format, 1),
            onBuy: () => _handleBuy(format),
            onShowSample: () => _showSample(format),
          );
        }).toList(),
      ),
    );
  }

  void _handleBuy(BookFormat format) {
    if (kDebugMode) {
      print('Comprar ${format.formatType.displayName}');
    }
  }

  // ============================================
  // BUILD PRINCIPAL
  // ============================================
  @override
  Widget build(BuildContext context) {
    final averageRating = getAverageRating(widget.book.reviews);

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + _kBottomNavBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 21,
            ),
            _buildBookHeader(averageRating),
            SizedBox(height: 18.0),
            _buildRatingSection(averageRating),
            _buildDescription(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Imagen con Hero animation
            //       Hero(
            //         tag:
            //             'book-image-${widget.book.id}', // Mismo tag que en la lista
            //         child: SizedBox(
            //           width: 122,
            //           height: 200,
            //           child: Image.network(
            //             widget.book.coverImageUrl ??
            //                 'https://via.placeholder.com/122x134.png?text=No+Image',
            //             height: 200,
            //             fit: BoxFit.fitHeight,
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 8.0),
            //       Expanded(
            //         child: SizedBox(
            //           // padding: EdgeInsets.all(16),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 widget.book.title ?? 'Título no disponible',
            //                 style: StylesApp(context).textStyleBody16.copyWith(
            //                     color: StyleColor.black,
            //                     fontWeight: FontWeight.bold),
            //                 textAlign: TextAlign.center,
            //               ),
            //               Text(
            //                 widget.book.author ?? 'Autor no disponible',
            //                 style: StylesApp(context).textStyleBody14.copyWith(
            //                     color: StyleColor.greenDark,
            //                     fontWeight: FontWeight.bold),
            //               ),
            //               Text.rich(TextSpan(
            //                 text: "Publicado: ",
            //                 style: StylesApp(context).textStyleBody14.copyWith(
            //                     color: StyleColor.grayDark,
            //                     fontWeight: FontWeight.bold),
            //                 children: [
            //                   TextSpan(
            //                     text: _formatPublishedDate(
            //                         widget.book.publishedDate.toString()),
            //                   ),
            //                 ],
            //               )),
            //               Text.rich(TextSpan(
            //                 text: "Editorial: ",
            //                 style: StylesApp(context).textStyleBody14.copyWith(
            //                     color: StyleColor.grayDark,
            //                     fontWeight: FontWeight.bold),
            //                 children: [
            //                   TextSpan(
            //                     text: "${widget.book.publisher ?? 'N/A'}",
            //                     style: StylesApp(context)
            //                         .textStyleBody14
            //                         .copyWith(
            //                             color: StyleColor.grayDark,
            //                             fontWeight: FontWeight.bold),
            //                   ),
            //                 ],
            //               )),
            //               Text.rich(TextSpan(
            //                 text: "ISBN: ",
            //                 style: StylesApp(context).textStyleBody14.copyWith(
            //                     color: StyleColor.grayDark,
            //                     fontWeight: FontWeight.bold),
            //                 children: [
            //                   TextSpan(
            //                     text:
            //                         "${_getFormatIsbn(widget.book.isbn) ?? 'N/A'}",
            //                     style: StylesApp(context)
            //                         .textStyleBody14
            //                         .copyWith(
            //                             color: StyleColor.grayDark,
            //                             fontWeight: FontWeight.bold),
            //                   ),
            //                 ],
            //               )),
            //               Text.rich(TextSpan(
            //                 text: "Tipo: ",
            //                 style: StylesApp(context).textStyleBody14.copyWith(
            //                     color: StyleColor.grayDark,
            //                     fontWeight: FontWeight.bold),
            //                 children: [
            //                   TextSpan(
            //                     text: widget.book.formats!
            //                         .map((form) => form.formatType.displayName)
            //                         .join(" / "),
            //                   ),
            //                 ],
            //               )),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(9.0),
            //   child: Row(
            //     children: [
            //       Text(
            //         "Resumen",
            //         style: StylesApp(context).textStyleBody14.copyWith(
            //             color: StyleColor.turquoise,
            //             fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(width: 8.0),
            //       Row(
            //         children: List.generate(5, (index) {
            //           final double size = 29;
            //           if (index < averageRating.floor()) {
            //             // Estrella llena
            //             return Icon(
            //               Icons.star,
            //               color: StyleColor.orange,
            //               size: size,
            //             );
            //           } else if (index < averageRating.ceil() &&
            //               averageRating % 1 != 0) {
            //             // Media estrella (si hay decimal)
            //             return Icon(
            //               Icons.star_half,
            //               color: StyleColor.orange,
            //               size: size,
            //             );
            //           } else {
            //             // Estrella vacía
            //             return Icon(
            //               Icons.star_border,
            //               color: StyleColor.orange,
            //               size: size,
            //             );
            //           }
            //         }),
            //       ),
            //       SizedBox(width: 8.0),
            //       if (averageRating > 0)
            //         Text(
            //           "(${averageRating.toStringAsFixed(1)})",
            //           style: StylesApp(context).textStyleBody14.copyWith(
            //                 color: StyleColor.grayDark,
            //               ),
            //         ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(9.0),
            //   child: Scrollbar(
            //     controller: _scrollController,
            //     thumbVisibility: true,
            //     trackVisibility: true,
            //     thickness: 4.0,
            //     child: SingleChildScrollView(
            //       controller: _scrollController,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: StyleColor.white,
            //           borderRadius: BorderRadius.circular(8.0),
            //           boxShadow: [
            //             BoxShadow(
            //               color: StyleColor.black.withValues(alpha: 0.2),
            //               blurRadius: 4.0,
            //               offset:
            //                   Offset(0, 2), // Cambia la dirección de la sombra
            //             ),
            //           ],
            //         ),
            //         constraints: BoxConstraints(
            //           minHeight: 146,
            //         ),
            //         child: Text(
            //           widget.book.description ??
            //               'No hay descripción disponible para este libro.',
            //           style: StylesApp(context)
            //               .textStyleBody12
            //               .copyWith(color: StyleColor.black),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // GenericCoordinationWidget<ModelData>(
            //   countryDropdown: CustomDropdownBottomWidget<ModelData>(
            //     hintText: "Seleccione un país",
            //     items: _listCountries,
            //     onChanged: (newValue) =>
            //         setState(() => selectedCountry = newValue),
            //     selectedItem: selectedCountry,
            //   ),
            //   currencyDropdown: CustomDropdownBottomWidget<ModelData>(
            //     hintText: "Seleccione una moneda",
            //     items: _lisCurrencies,
            //     onChanged: (newValue) =>
            //         setState(() => selectedCurrency = newValue),
            //     selectedItem: selectedCurrency,
            //   ),
            // ),
            _buildFormatsList(),
            const SizedBox(height: 12.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 9.0),
            //   child: Column(
            //     children: [
            //       // AudioLibro
            //       ...widget.book.formats!.map((form) {
            //         final index = widget.book.formats!.indexOf(form);

            //         return BookFormatCard(
            //           formatType: form.formatType.displayName,
            //           sampleText: "Muestra",
            //           disabledBtn: form.stock <= 0,
            //           bookmarkColor: booKmarkColor[index],
            //           price: form.price.toString(),
            //           onAddToCart: () {
            //             if (kDebugMode) {
            //               print(
            //                   'Agregar ${form.formatType.displayName} al carrito');
            //             }

            //             _handlerAddToCart(form, 1);
            //           },
            //           onBuy: () {
            //             // Lógica para comprar audiolibro
            //             if (kDebugMode) {
            //               print('Comprar audiolibro');
            //             }
            //           },
            //           onShowSample: () => _showSample(form),
            //         );
            //       }),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

 AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      leading: _buildBackButton(),
      title: const Text("Librería Cristiana"),
      titleTextStyle: StylesApp(context)
          .textStyleBody20
          .copyWith(color: StyleColor.white),
      backgroundColor: StyleColor.turquoise,
    );
  }

  Widget _buildBackButton() {
    return IconButton.filled(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
        foregroundColor: WidgetStatePropertyAll(StyleColor.white),
      ),
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.pop(context),
      splashColor: StyleColor.orange,
      color: StyleColor.white,
      icon: const Icon(Icons.arrow_back, size: 30),
    );
  }
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
