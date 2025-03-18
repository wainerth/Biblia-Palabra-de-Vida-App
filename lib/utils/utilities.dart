import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
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

getGender() {}

UserChurch? getChurchActive(churches) {
  if (churches.isNotEmpty) {
    var church = churches.firstWhere((UserChurch element) => element.status);
    if (church != null) {
      return church;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

UpdateDataProfile updateFromModelData(UpdateDataProfile dataToSend,
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
        nuevosDatos["phoneNumber"] = item.value as String?;
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
        nuevosDatos["gender"] = item.value as String?;
        break;
      case 'isBaptized':
        nuevosDatos["isBaptized"] = item.value == 'Bautizado' ? true : false;
        break;
      case 'church':
        var church = churches.firstWhere((church) => church.name == item.value);
        nuevosDatos["church"] =
            UserChurch(id: church.id, name: church.name, status: church.status);
        break;
    }

    datos = datos.copyWith(
      name: nuevosDatos["name"] ?? datos.name,
      lastname: nuevosDatos["lastname"] ?? datos.lastname,
      birthdate: nuevosDatos["birthdate"] ?? datos.birthdate,
      identifier: nuevosDatos["identifier"] ?? datos.identifier,
      phoneNumber: nuevosDatos["phoneNumber"] ?? datos.phoneNumber,
      country: nuevosDatos["country"] ?? datos.country,
      city: nuevosDatos["city"] ?? datos.city,
      gender: nuevosDatos["gender"] ?? datos.gender,
      isBaptized: nuevosDatos["isBaptized"] ?? datos.isBaptized,
      church: nuevosDatos["church"] ?? datos.church,
    );
  }
  print(datos);
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

  obtainedStar(int maxScore, int sectionCompleted, int sectionCount) {

    final score = maxScore / sectionCount;

    return (score * sectionCompleted).toInt();

  }