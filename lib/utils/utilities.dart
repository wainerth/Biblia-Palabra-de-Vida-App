import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

export 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
export 'package:biblia_palabra_de_vida_app/utils/bottom_navigation_items.dart';

Map<String, dynamic> removeTypename(values) {
  if (values is Map<String, dynamic>) {
    values.removeWhere((key, value) => key == '__typename');
    values.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        removeTypename(value);
      } else if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            removeTypename(item);
          }
        }
      }
    });
  }
  return values;
}

String getFormatedDate(int dateTimeMiliseconds) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateTimeMiliseconds);
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  // Formatear la fecha como dd/mm/aaaa
  return formattedDate;
}

var maskFormatterTel = MaskTextInputFormatter(
  mask: '### ###-##-##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);
var maskFormatterEmail = MaskTextInputFormatter(
  mask: '******@******.com',
  filter: {"*": RegExp(r'[a-zA-Z0-9]')},
  type: MaskAutoCompletionType.lazy,
);

getIsBaptized(value) {
  return value ? "Bautizado" : "No Bautizado";
}

UserChurch? getChurchActive(churches) {
  if (churches.isNotEmpty) {
    var church = churches.firstWhere((UserChurch element) => 
    element.status);
    if (church != null) {
      return church;
    } else {
      return null;
    }
  } else {
    return null;
  }
}
