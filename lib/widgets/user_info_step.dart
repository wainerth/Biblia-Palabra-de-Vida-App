import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: TextFormField(
            controller: widget.userIdController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Permite solo números
            ],
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  hintText: "Identificador de usuario",
                ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "El identificador es obligatorio";
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 23.0,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  hintText: "Correo electrónico",
                ),
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
         const SizedBox(
          height: 23.0,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: TextFormField(
            controller: widget.userNameController,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  hintText: "Nombre de Usuario",
                ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "El Nombre de Usuario es obligatorio";
              }
              if(value.contains(' ')){
                return "El Nombre de Usuario no puede contener espacios";
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 23.0,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: TextFormField(
            controller: widget.passwordController,
            obscureText: widget.obscureTextPass,
            textAlignVertical: TextAlignVertical.center,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  hintText: "Contraseña",
                  suffixIcon: IconButton(
                    iconSize: 20,
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      widget.obscureTextPass
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => widget
                        .onObscureTextPassChanged(!widget.obscureTextPass),
                  ),
                ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "La contraseña es obligatoria";
              }
              if (value.length <6){
                return "la contraseña debe contener al menos 6 caracteres";
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 23.0,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: widget.obscureTextRepeat,
            textAlignVertical: TextAlignVertical.center,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  hintText: "Confirmar Contraseña",
                  suffixIcon: IconButton(
                    alignment: Alignment.center,
                    iconSize: 20,
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      widget.obscureTextRepeat
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => widget
                        .onObscureTextRepeatChanged(!widget.obscureTextRepeat),
                  ),
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
    );
  }
}
