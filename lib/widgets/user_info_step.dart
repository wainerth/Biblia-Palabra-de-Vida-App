import 'dart:math' as math;

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserInfoStep extends StatefulWidget {
  final TextEditingController userIdController;
  final TextEditingController emailController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscureTextPass;
  final bool obscureTextRepeat;
  final ValueChanged<bool> onObscureTextPassChanged;
  final ValueChanged<bool> onObscureTextRepeatChanged;

  const UserInfoStep({
    super.key,
    required this.userIdController,
    required this.emailController,
    required this.userNameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscureTextPass,
    required this.obscureTextRepeat,
    required this.onObscureTextPassChanged,
    required this.onObscureTextRepeatChanged,
  });

  @override
  State<UserInfoStep> createState() => _UserInfoStepState();
}

class _UserInfoStepState extends State<UserInfoStep> {
  bool get _isTablet {
    final shortestSide = MediaQuery.sizeOf(context).width;
    return shortestSide > 600;
  }

  // Función para width responsive
  double get _formWidth {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (_isTablet) {
      // Para tablet: 100% del ancho disponible en la columna
      return screenWidth;
    } else {
      // Para mobile: usa tu valor actual o 90% del ancho
      return math.min(
        StylesApp(context).sizeTextFormField.width,
        screenWidth * 0.9,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isTablet ? _buildTabletLayout() : _buildMobileLayout();
  }

  // Layout para móvil (manteniendo el diseño actual)
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // IDENTIFICADOR DE USUARIO
          SizedBox(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.userIdController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
                        hintText: "Identificador de usuario",
                      ),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "El identificador es obligatorio";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // CORREO ELECTRÓNICO
          SizedBox(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
                        hintText: "Correo electrónico",
                      ),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "El correo es obligatorio";
                }
                final RegExp emailRegExp = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$");
                if (!emailRegExp.hasMatch(value)) {
                  return 'Ingrese un correo electrónico válido';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // NOMBRE DE USUARIO
          SizedBox(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.userNameController,
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
                        hintText: "Nombre de Usuario",
                      ),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "El Nombre de Usuario es obligatorio";
                }
                if (value.contains(' ')) {
                  return "El Nombre de Usuario no puede contener espacios";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // CONTRASEÑA
          SizedBox(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.passwordController,
              obscureText: widget.obscureTextPass,
              textAlignVertical: TextAlignVertical.center,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
                  .copyWith(
                    hintText: "Contraseña",
                    suffixIcon: IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        widget.obscureTextPass
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () => widget
                          .onObscureTextPassChanged(!widget.obscureTextPass),
                    ),
                  ),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "La contraseña es obligatoria";
                }
                if (value.length < 6) {
                  return "la contraseña debe contener al menos 6 caracteres";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // CONFIRMAR CONTRASEÑA
          SizedBox(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.confirmPasswordController,
              obscureText: widget.obscureTextRepeat,
              textAlignVertical: TextAlignVertical.center,
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
                        hintText: "Confirmar Contraseña",
                        suffixIcon: IconButton(
                          alignment: Alignment.center,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            widget.obscureTextRepeat
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                          onPressed: () => widget.onObscureTextRepeatChanged(
                              !widget.obscureTextRepeat),
                        ),
                      ),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value != widget.passwordController.text) {
                  return "Las contraseñas no coinciden";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  // Layout para tablet con 2 columnas
  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Fila 1: ID y Email (2 columnas)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: Número de documento
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Número de documento",
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: StyleColor.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height:
                              StylesApp(context).sizeTextFormField.height ,
                          child: TextFormField(
                            controller: widget.userIdController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  hintText: "Ej: 12345678",
                                  // errorStyle: TextStyle(fontSize: 12),
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: Colors.grey,
                                        size: 22,
                                      ),
                                      onPressed: () =>
                                          _showInfoDialogDocument()),
                                ),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontSize: 16,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Columna derecha: Nombre de usuario
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nombre de usuario",
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: StyleColor.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height:
                              StylesApp(context).sizeTextFormField.height,
                          child: TextFormField(
                            controller: widget.userNameController,
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  hintText: "Ej: usuario123",
                                  // errorStyle: TextStyle(fontSize: 12),
                                  suffixIcon: IconButton(
                                    onPressed: () => _showInfoDialogUserName(),
                                    icon: Icon(Icons.info_outline,
                                        color: Colors.grey, size: 22),
                                  ),
                                ),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontSize: 16,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Fila 2: Correo electrónico (columna completa)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Correo electrónico*",
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: StyleColor.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: StylesApp(context).sizeTextFormField.height + 10,
                  child: TextFormField(
                    controller: widget.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        StylesApp(context).inputDecorationOutlineStyle.copyWith(
                              hintText: "ejemplo@correo.com",
                              // errorStyle: TextStyle(fontSize: 12),
                            ),
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: StyleColor.black,
                          fontSize: 16,
                        ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obligatorio";
                      }
                      final RegExp emailRegExp = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$");
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Fila 3: Contraseña y Confirmar contraseña (2 columnas)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: Contraseña
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contraseña*",
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: StyleColor.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height:
                              StylesApp(context).sizeTextFormField.height + 10,
                          child: TextFormField(
                            controller: widget.passwordController,
                            obscureText: widget.obscureTextPass,
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  hintText: "Mínimo 6 caracteres",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      widget.obscureTextPass
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 22,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () =>
                                        widget.onObscureTextPassChanged(
                                            !widget.obscureTextPass),
                                  ),
                                  // errorStyle: TextStyle(fontSize: 12),
                                ),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontSize: 16,
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Campo obligatorio";
                              }
                              if (value.length < 6) {
                                return "Mínimo 6 caracteres";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Columna derecha: Confirmar contraseña
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Confirmar contraseña*",
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: StyleColor.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height:
                              StylesApp(context).sizeTextFormField.height + 10,
                          child: TextFormField(
                            controller: widget.confirmPasswordController,
                            obscureText: widget.obscureTextRepeat,
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  hintText: "Repite la contraseña",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      widget.obscureTextRepeat
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 22,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () =>
                                        widget.onObscureTextRepeatChanged(
                                            !widget.obscureTextRepeat),
                                  ),
                                  // errorStyle: TextStyle(fontSize: 12),
                                ),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontSize: 16,
                                ),
                            validator: (value) {
                              if (value != widget.passwordController.text) {
                                return "Las contraseñas no coinciden";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Información adicional para tablet
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0Xff12CBC4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0Xff12CBC4).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0Xff12CBC4),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Todos los campos marcados con * son obligatorios. Asegúrate de recordar tu contraseña.",
                      style: StylesApp(context).textStyleBody12.copyWith(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showInfoDialogUserName() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Alias (seudónimo)',
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: StyleColor.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                ),
                SizedBox(height: 16),
                Text(
                  'Este campo es un alias o diminutivo que se usará en la Biblia. '
                  'No es tu nombre real, es opcional y sirve solo para mostrarte en la app.',
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: StyleColor.black,
                        fontSize: 14,
                      ),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: StylesApp(context).btnWidgetSmall,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Entendido',
                      style: StylesApp(context).textStyleBody14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showInfoDialogDocument() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Documento de identidad',
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: StyleColor.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                ),
                SizedBox(height: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresa tu documento de identidad oficial: Ejemplos según tu país:',
                      style: StylesApp(context).textStyleBody12.copyWith(
                          color: StyleColor.grayDark,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 12),
                    _buildInfoItem('• Argentina: DNI'),
                    _buildInfoItem('• Uruguay: Cédula'),
                    _buildInfoItem('• Chile: RUN o RUT'),
                    _buildInfoItem('• Colombia: Cédula'),
                    _buildInfoItem('• México: INE o CURP'),
                    _buildInfoItem('• España: DNI o NIE'),
                    _buildInfoItem('• Estados Unidos: SSN'),
                    _buildInfoItem('• Brasil: RG o CPF'),
                    SizedBox(height: 12),
                    Text(
                      'Solo números, sin puntos ni guiones.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: StylesApp(context).btnWidgetSmall,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Entendido',
                      style: StylesApp(context).textStyleBody14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: StylesApp(context).textStyleBody12.copyWith(
              color: StyleColor.grayDark,
              fontSize: 14,
            ),
      ),
    );
  }
}
