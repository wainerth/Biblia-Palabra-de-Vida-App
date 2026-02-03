import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class ReferenceCardTablet extends StatelessWidget {
  final ReferenceModel reference;
  final VoidCallback onTap;

  const ReferenceCardTablet({
    super.key,
    required this.reference,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono de libro
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: StyleColor.turquoise.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: StyleColor.turquoise,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.book,
                  color: StyleColor.turquoise,
                  size: 20,
                ),
              ),
            ),

            SizedBox(width: 16),

            // Información de la referencia
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reference.book!.modernName,
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Capítulo ${reference.chapter!.chapter}:${reference.verse!.verse}",
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: StyleColor.orange,
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Botón para ver detalles
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: StyleColor.turquoise,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
