import 'dart:math' as math;

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
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
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    return shortestSide > 600;
  }

  // Función para width responsive
  double get _formWidth {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (_isTablet) {
      // Para tablet: máximo 500px o 60% del ancho
      return math.min(500, screenWidth * 0.6);
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
    final double formWidth = _formWidth;
    return SingleChildScrollView(
      child: Column(
        children: [
          // IDENTIFICADOR DE USUARIO
          Container(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.userIdController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Permite solo números
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
          SizedBox(height: _isTablet ? 28.0 : 23.0),

          // CORREO ELECTRÓNICO
          Container(
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
          SizedBox(height: _isTablet ? 28.0 : 23.0),

          // NOMBRE DE USUARIO
          Container(
            width: formWidth,
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
          SizedBox(height: _isTablet ? 28.0 : 23.0),

          // CONTRASEÑA
          Container(
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
                      iconSize: _isTablet ? 24 : 20,
                      padding: _isTablet ? EdgeInsets.all(4) : EdgeInsets.zero,
                      icon: Icon(
                        widget.obscureTextPass
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: _isTablet ? 24 : 20,
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
          SizedBox(height: _isTablet ? 28.0 : 23.0),

          // CONFIRMAR CONTRASEÑA
          Container(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.confirmPasswordController,
              obscureText: widget.obscureTextRepeat,
              textAlignVertical: TextAlignVertical.center,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
                  .copyWith(
                    hintText: "Confirmar Contraseña",
                    suffixIcon: IconButton(
                      alignment: Alignment.center,
                      iconSize: _isTablet ? 24 : 20,
                      padding: _isTablet ? EdgeInsets.all(4) : EdgeInsets.zero,
                      icon: Icon(
                        widget.obscureTextRepeat
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: _isTablet ? 24 : 20,
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
          SizedBox(height: _isTablet ? 40 : 30),
        ],
      ),
    );
  }
}
