import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException;

import 'package:biblia_palabra_de_vida_app/config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/main.dart';
import 'package:biblia_palabra_de_vida_app/models/library/book_format_model.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/services/country_search_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/simple_timezone.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:share_plus/share_plus.dart';

export 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
export 'package:biblia_palabra_de_vida_app/utils/bottom_navigation_items.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

final _translationProvider = AppTranslationProvider();

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

String getFormattedDate(int dateTimeMilliseconds) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateTimeMilliseconds);
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
  return value
      ? _translationProvider.tr("utils.baptized.yes")
      : _translationProvider.tr("utils.baptized.no");
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
  for (ModelData item in data) {
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
          code = item.originalData;
        }
        nuevosDatos['profileAreaCode'] =
            code != null ? AreaCode(id: code.id, code: code.code) : null;
        nuevosDatos["phoneNumber"] = item.value.split(' ')[1] as String?;
        break;
      case 'country':
        if (item.value.isNotEmpty) {
          Country? cont = item.originalData;
          nuevosDatos["country"] = cont;
        } else {
          nuevosDatos["country"] = null;
        }

        break;
      case 'state':
        if (item.value.isNotEmpty) {
          nuevosDatos["state"] = item.originalData;
        } else {
          nuevosDatos["state"] = null;
        }
        break;
      case 'city':
        if (item.value.isNotEmpty) {
          nuevosDatos["city"] = item.originalData;
        } else {
          nuevosDatos["city"] = null;
        }
        break;
      case 'gender':
        nuevosDatos["gender"] = item.value.isNotEmpty ? item.value[0] : null;
        break;
      case 'isBaptized':
        nuevosDatos["isBaptized"] = item.value == 'Bautizado' ? true : false;
        break;
      case 'church':
        var church =
            churches.where((church) => church.name == item.value).firstOrNull;
        if (church != null) {
          nuevosDatos["church"] = UserChurch(
              id: church.id, churchName: church.name, status: church.status);
        }
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
      state: nuevosDatos["state"] ?? datos.state,
      city: nuevosDatos["city"] ?? datos.city,
      gender: nuevosDatos["gender"] ?? datos.gender,
      isBaptized: nuevosDatos["isBaptized"] ?? datos.isBaptized,
      church: nuevosDatos["church"] ?? datos.church,
    );
  }
  // print(datos);
  return datos;
}

Future<void> showCustomDialog(
  BuildContext context, {
  required String message,
  String messageDetail = '',
  showDetails = false,
  required DialogType dialogType,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
          showDetails: showDetails,
          message: message,
          dialogType: dialogType,
          errorDetail: messageDetail);
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
    barrierDismissible: true,
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

Future<(String, String)> parsePhoneNumberSimple(
    BuildContext context, String value) async {
  if (value.isEmpty) return ('', '');
  String code = '';
  final parts = value.trim().split(RegExp(r'\s+'));

  if (parts.length == 2) {
    final codeArea = await AreaCodeSearchService().getCodeAreaById(parts[0]);
    if (codeArea != null) {
      code = codeArea.code;
    }
  }

  return (
    parts.length >= 2 ? code : '',
    parts.isNotEmpty
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

Future<String> copyChapter(VersionModel? currentVersion, BookModel? currentBook,
    ChapterModel? chapter) async {
  final baseUrl = "${GraphQLConfig.endpoint}OfficialBible";
  if (chapter == null) return '';
  StringBuffer buffer = StringBuffer();
  for (var verse in chapter.verses!) {
    buffer.write('${verse.verse} ${verse.text}\n');
  }
  return "${currentVersion?.version}\n ${currentBook?.modernName} Capitulo ${chapter.chapter} \n  ${buffer.toString()} \n$baseUrl";
}

Future<void> copyToClipboard(BuildContext context, dynamic data) async {
  final baseUrl = "${GraphQLConfig.endpoint}OfficialBible";
  final copyString =
      "${data.book.modernName}\n${data.chapter.chapter}:${data.verse.verse} \n${data.verse.text}\n$baseUrl";
  await Clipboard.setData(ClipboardData(text: copyString));

  // Mostrar diálogo de confirmación
  await showCustomDialog(
    showDetails: false,
    context,
    message: _translationProvider.trParams("utils.copy.verse_success", {
      "chapter": data.chapter.chapter.toString(),
      "verse": data.verse.verse.toString(),
      "book": data.book.modernName
    }),
    dialogType: DialogType.info,
  );
}

Future<void> shareVerse(BuildContext context, dynamic data) async {
  final baseUrl = "${GraphQLConfig.endpoint}OfficialBible";
  final shareText =
      "${data.book.modernName}\n${data.chapter.chapter}:${data.verse.verse} \n${data.verse.text}\n$baseUrl";
  await SharePlus.instance.share(ShareParams(
    text: shareText,
    subject: "${_translationProvider.trParams("utils.share.subject", {
          "chapter": data.chapter.chapter.toString(),
          "book": data.book.modernName
        })}\n ${_translationProvider.trParams("utils.share.see_in", {
          "baseUrl": baseUrl
        })}",
  ));
}

RouteInfo getRouterScreen(action, args) {
  switch (action) {
    case 'course':
      return RouteInfo(
        '/layoutPage1',
        arguments: {'selectedIndex': 1},
      );
    case 'section':
      return RouteInfo('/detailCoursePage', arguments: args);
    case 'level':
      return RouteInfo('/detailCoursePage', arguments: args);
    case 'Promise':
      return RouteInfo("/promisePage");
    case 'Preach':
      return RouteInfo('/preachPage');
    case 'Ranking':
      return RouteInfo(
        '/layoutPage1',
        arguments: {'selectedIndex': 2},
      );
    case 'title':
      return RouteInfo('/detailsProgressPage');
    case 'streak':
      return RouteInfo('/detailsProgressPage');
    case 'user':
      return RouteInfo('/detailsProgressPage');
  }
  return RouteInfo('/layoutPage');
}

ResponseData handleGenericError(dynamic e, String operationName) {
  if (e is TimeoutException) {
    return ResponseData(
      data: null,
      userFriendlyError: _translationProvider
          .trParams("utils.errors.timeout", {"operation": operationName}),
      error: _translationProvider
          .trParams("utils.errors.timeout", {"operation": operationName}),
    );
  } else if (e is SocketException) {
    return ResponseData(
      data: null,
      userFriendlyError: _translationProvider
          .trParams("utils.errors.no_internet", {"operation": operationName}),
      error: "$operationName: ${e.toString()}",
    );
  } else if (e is FormatException) {
    return ResponseData(
      data: null,
      userFriendlyError: _translationProvider.trParams(
          "utils.errors.invalid_format", {"operation": operationName}),
      error: "$operationName:  ${e.toString()}",
    );
  } else if (e is PlatformException) {
    // Manejo específico para errores de Google Sign-In
    if (e.code == 'network_error' ||
        e.message?.contains('ApiException: 7') == true ||
        e.message?.contains('NETWORK_ERROR') == true) {
      return ResponseData(
        data: null,
        userFriendlyError: _translationProvider.trParams(
            "utils.errors.network_error", {"operation": operationName}),
        error: "$operationName: Network error (Google Sign-In)",
      );
    }
    // Otros errores de PlatformException
    return ResponseData(
      data: null,
      userFriendlyError: _translationProvider
          .trParams("utils.errors.service_error", {"operation": operationName}),
      error: "$operationName: ${e.code} - ${e.message}",
    );
  } else {
    return ResponseData(
        data: null,
        userFriendlyError: _translationProvider
            .trParams("utils.errors.unexpected", {"operation": operationName}),
        error: "$operationName: ${e.toString()}");
  }
}

Size getDesignSize() {
  // Puedes usar MediaQuery para detectar el tamaño inicial
  final window = WidgetsBinding.instance.window;
  final physicalSize = window.physicalSize;
  final pixelRatio = window.devicePixelRatio;
  final logicalSize = physicalSize / pixelRatio;

  if (logicalSize.width > 600) {
    return const Size(768, 1024); // Tablet
  } else {
    return const Size(360, 690); // Móvil
  }
}

void showSnackBar(String message, {SnackBarType type = SnackBarType.info}) {
  Color backgroundColor;
  Duration duration;
  IconData? icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      duration = const Duration(seconds: 2);
      icon = Icons.check_circle;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      duration = const Duration(seconds: 4);
      icon = Icons.error;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange;
      duration = const Duration(seconds: 3);
      icon = Icons.warning;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.blue;
      duration = const Duration(seconds: 2);
      icon = Icons.info;
      break;
  }

  final snackBar = SnackBar(
    content: Row(
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        Expanded(
          child: Text(
            message,
            style: StylesApp(navigatorKey.currentContext!)
                .textStyleBody12
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  if (navigatorKey.currentState != null) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
  }
}

bool isTablet(BuildContext? context) {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return false;

    final view = views.first;
    final logicalSize = view.physicalSize / view.devicePixelRatio;

    // Lógica simple: si el lado más corto es > 600px, es tablet
    return logicalSize.shortestSide > 550.0;
  } catch (e) {
    return false;
  }
}

// Función para obtener el timezone del dispositivo
Future<String> getDeviceTimeZone() async {
  try {
    // Obtener el nombre del timezone (ej: "America/New_York")
    final userTimezone = SimpleTimeZone.currentIANA;
    return userTimezone;
  } catch (e) {
    // Fallback si hay error
    return 'UTC';
  }
}

// Agrega esta función para prevenir reconstrucciones
class KeyboardUtils {
  static void safeFocusChange(
      BuildContext context, FocusNode focusNode, bool hasFocus) {
    if (hasFocus) {
      // Cuando el teclado se abre, hacer un pequeño delay para evitar jank
      Future.delayed(Duration(milliseconds: 100), () {
        // Scroll suave para mostrar el campo
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }
}

String getCapitalizedFirstName(String? fullName) {
  if (fullName == null || fullName.isEmpty) return '';
  final firstName = fullName.split(' ').first;
  if (firstName.isEmpty) return '';
  return firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
}

String getFormattedPrice(String price) {
  try {
    // Convierte a número si es String
    final priceValue = double.parse(price);

    // Formato con separadores de miles (ej: $29,900.00)
    final formatter = NumberFormat.currency(
      locale:
          'es_CO', // 'es_CO' para Colombia, 'es_MX' para México, 'en_US' para USA
      symbol: '\$',
      decimalDigits: 0, // 0 si no quieres decimales, 2 si quieres .00
    );

    return formatter.format(priceValue);
  } catch (e) {
    return '\$$price';
  }
}

String displayName(String type) {
  final formatType = FormatType.fromString(type);
  return formatType.displayName;
}
