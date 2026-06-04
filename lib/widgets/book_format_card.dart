import 'package:biblia_palabra_de_vida_app/screens/library/book_detail_screen.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';

class BookFormatCard extends StatelessWidget {
  final String formatType;
  final String sampleText;
  final String price;
  final bool? disabledBtn;
  final bool hasShippingCosts;
  final Color bookmarkColor;
  final bool isSelected;
  final VoidCallback onAddToCart;
  final VoidCallback onBuy;
  final VoidCallback? onShowSample;

  const BookFormatCard({
    super.key,
    required this.formatType,
    required this.sampleText,
    this.disabledBtn = false,
    required this.bookmarkColor,
    required this.price,
    this.hasShippingCosts = false,
    this.isSelected = false,
    required this.onAddToCart,
    required this.onBuy,
    this.onShowSample,
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
        color: Colors.white,
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
                      maxHeight: 45,
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
                            width: double
                                .infinity, // Ocupa todo el ancho disponible
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
                          left: 5,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text(formatType,
                                softWrap: true,
                                maxLines: 2,
                                style: StylesApp(context).textStyleBody10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Muestra

                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () {
                      // Lógica para mostrar la muestra del formato
                     onShowSample?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (formatType.toLowerCase() != "físico")
                            ? StyleColor.galaxyPurple
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (formatType.toLowerCase() != "físico") ...{
                            Text(
                              sampleText,
                              style: StylesApp(context).textStyleBody10,
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.visibility,
                                size: 16, color: StyleColor.white),
                          }
                        ],
                      ),
                    ),
                  ),
                ),

                // Precio
                Expanded(
                  flex: 4,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: StyleColor.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        getFormattedPrice(price),
                        style: StylesApp(context).textStyleBody10,
                      )),
                ),
                // Botones
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 100, // Mismo ancho que el botón Agregar
                          height: 30,
                          child: IconTextButton(
                            icon: Icons.shopping_cart,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            text: 'Agregar',
                            iconPosition: 'right',
                            onPressed: () =>
                                disabledBtn == false ? onAddToCart() : null,
                            iconSize: 15,
                            style: StylesApp(context).textStyleBody10.copyWith(
                                  color: StyleColor.white,
                                ),
                            backgroundColor: disabledBtn == true
                                ? StyleColor.grayMedium
                                : StyleColor.turquoise,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 100, // Mismo ancho que el botón Agregar
                          height: 30,
                          child: IconTextButton(
                            noIcon: false,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            text: 'Comprar',
                            onPressed: () =>
                                disabledBtn == false ? onBuy() : null,
                            style: StylesApp(context).textStyleBody10.copyWith(
                                  color: StyleColor.white,
                                ),
                            backgroundColor: disabledBtn == true
                                ? StyleColor.grayMedium
                                : StyleColor.yellowLight,
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
