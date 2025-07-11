import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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

getGender() {}

UserChurch? getChurchActive(churches) {
  if (churches.isNotEmpty) {
    UserChurch? church;
    try {
      church = (churches as List<UserChurch>)
          .firstWhere((UserChurch element) => element.status);
    } on StateError {
      church = null;
    }
    if (church != null) {
      return church;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

UpdateDataProfile updateFromModelData(context, UpdateDataProfile dataToSend,
    List<ModelData> data, List<Country> countries, List<Church> churches) {
  var datos = dataToSend;

  var nuevosDatos = {};
  for (var item in data) {
    switch (item.clave) {
      case 'lastname':
        nuevosDatos["lastname"] = item.value as String?;
        break;
      case 'name':
        nuevosDatos["name"] = item.value as String?;
        break;
      case 'birthdate':
        nuevosDatos["birthdate"] = item.value as String?;
        break;
      case 'identifier':
        nuevosDatos["identifier"] = item.value as String?;
        break;
      case 'phoneNumber':
        final parts = item.value.split(' ');
        AreaCode? code;
        if (parts.length == 2) {
          code = Provider.of<CatalogueProvider>(context, listen: false)
              .allAreasCode
              .firstWhere(
                  (areaCode) => areaCode.id == item.value.split(' ')[0]);
        }
        nuevosDatos['profileAreaCode'] =
            code != null ? AreaCode(id: code.id, code: code.code) : null;
        nuevosDatos["phoneNumber"] = item.value.split(' ')[1] as String?;
        break;
      case 'country':
        if (item.value.isNotEmpty) {
          Country? cont =
              countries.firstWhere((country) => country.country == item.value);
          nuevosDatos["country"] = cont;
        } else {
          nuevosDatos["country"] = null;
        }

        break;
      case 'city':
        nuevosDatos["city"] = item.value as String?;
        break;
      case 'gender':
        nuevosDatos["gender"] = item.value.isNotEmpty ? item.value[0] : null;
        break;
      case 'isBaptized':
        nuevosDatos["isBaptized"] = item.value == 'Bautizado' ? true : false;
        break;
      case 'church':
        var church = churches.firstWhere((church) => church.name == item.value);
        nuevosDatos["church"] = UserChurch(
            id: church.id, churchName: church.name, status: church.status);
        break;
    }

    datos = datos.copyWith(
      name: nuevosDatos["name"] ?? datos.name,
      lastname: nuevosDatos["lastname"] ?? datos.lastname,
      birthdate: nuevosDatos["birthdate"] ?? datos.birthdate,
      identifier: nuevosDatos["identifier"] ?? datos.identifier,
      profileAreaCode: nuevosDatos["profileAreaCode"] ?? datos.profileAreaCode,
      phoneNumber: nuevosDatos["phoneNumber"] ?? datos.phoneNumber,
      country: nuevosDatos["country"] ?? datos.country,
      city: nuevosDatos["city"] ?? datos.city,
      gender: nuevosDatos["gender"] ?? datos.gender,
      isBaptized: nuevosDatos["isBaptized"] ?? datos.isBaptized,
      church: nuevosDatos["church"] ?? datos.church,
    );
  }
  // print(datos);
  return datos;
}

Future<void> showCustomDialog(BuildContext context,
    {required String message, required DialogType dialogType}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(message: message, dialogType: dialogType);
    },
  );
}

Future<void> showCustomDialogWithAction(BuildContext context,
    {required String message,
    required DialogTypeAction dialogType,
    required String buttonOk,
    String textButton = '',
    bool showAction = false,
    void Function()? actionCallbackOk,
    void Function()? actionCallback}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialogWithAction(
        message: message,
        dialogType: dialogType,
        buttonOk: buttonOk,
        callbackActionOk: actionCallbackOk,
        showAction: showAction,
        actionCallback: actionCallback,
        textButtonAction: textButton,
      );
    },
  );
}

obtainedStar(int maxScore, int sectionCompleted, int sectionCount) {
  if (sectionCount > 0) {
    final score = maxScore / sectionCount;
    return (score * sectionCompleted).toInt();
  }
  return 0;
}

(String, String) parsePhoneNumberSimple(BuildContext context, String value) {
  if (value.isEmpty) return ('', '');
  String code = '';
  String phone = '';
  final parts = value.trim().split(RegExp(r'\s+'));
  if (parts.length == 2) {
    code = Provider.of<CatalogueProvider>(context, listen: false)
        .allAreasCode
        .firstWhere((areaCode) => areaCode.id == parts[0])
        .code;
    phone = parts[1];
  } else {
    phone = parts[0];
  }

  return (
    parts.length >= 2 ? code : '',
    parts.length >= 1
        ? parts
            .sublist(parts.length >= 2 ? 1 : 0)
            .join('')
            .replaceAll(RegExp(r'[^0-9]'), '')
        : ''
  );
}
formatColor(String? color) {
  if (color!.contains('#')) {
    return color.split('#')[1];
  }
  return color;
}


Future<String> copyChapter(ChapterModel? chapter) async {
    final baseUrl = "${GraphQLConfig.urlServidor}OfficialBible";
  if (chapter == null) return '';
  StringBuffer buffer = StringBuffer();
  for (var verse in chapter.verses) {
    buffer.write('${verse.verse} ${verse.text}\n');
  }
  return "${buffer.toString()} \n$baseUrl";
}

Future<void> copyToClipboard(BuildContext context, dynamic data) async {
  final baseUrl = "${GraphQLConfig.urlServidor}OfficialBible";
  final copyString =
      "${data.chapter.chapter}:${data.verse.verse} \n${data.verse.text}\n$baseUrl";
  await Clipboard.setData(ClipboardData(text: copyString));

  // Mostrar diálogo de confirmación
  await showCustomDialog(
    context,
    message:
        "El capítulo ${data.chapter.chapter} del libro ${data.book.modernName}\nse ha copiado con éxito al portapapeles",
    dialogType: DialogType.info,
  );
}

Future<void> shareVerse(BuildContext context, dynamic data) async {
  final baseUrl = "${GraphQLConfig.urlServidor}OfficialBible";
  final shareText =
      "${data.chapter.chapter}:${data.verse.verse} \n${data.verse.text}\n$baseUrl";
  await Share.share(
    shareText,
    subject:
        "Palabra de Vida - ${data.chapter.chapter} ${data.book.modernName}\nVer en: $baseUrl",
  );
}
