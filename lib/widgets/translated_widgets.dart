import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============ WIDGETS DE TEXTO TRADUCIDO ============

/// Texto traducido simple con rutas
class TranslatedText extends StatelessWidget {
  final String path; // Cambiado de textKey a path
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? defaultValue;

  const TranslatedText({
    super.key,
    required this.path,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTranslationProvider>(
      builder: (context, provider, child) {
        return Text(
          provider.tr(path, defaultValue: defaultValue),
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

/// Texto traducido con parámetros
class TranslatedTextParams extends StatelessWidget {
  final String path;
  final Map<String, String> params;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String? defaultValue;

  const TranslatedTextParams({
    super.key,
    required this.path,
    required this.params,
    this.style,
    this.textAlign,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTranslationProvider>(
      builder: (context, provider, child) {
        return Text(
          provider.trParams(path, params, defaultValue: defaultValue),
          style: style,
          textAlign: textAlign,
        );
      },
    );
  }
}

/// Botón con texto traducido
class TranslatedButton extends StatelessWidget {
  final String path;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final String? defaultValue;

  const TranslatedButton({
    super.key,
    required this.path,
    this.onPressed,
    this.style,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTranslationProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: Text(provider.tr(path, defaultValue: defaultValue)),
        );
      },
    );
  }
}

/// AppBar con título traducido
class TranslatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String path;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final String? defaultValue;

  const TranslatedAppBar({
    super.key,
    required this.path,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.defaultValue,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTranslationProvider>(
      builder: (context, provider, child) {
        return AppBar(
          title: Text(provider.tr(path, defaultValue: defaultValue)),
          actions: actions,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
        );
      },
    );
  }
}

/// TextFormField con label traducido
class TranslatedTextFormField extends StatelessWidget {
  final String labelPath;
  final String? hintPath;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? defaultValue;

  const TranslatedTextFormField({
    super.key,
    required this.labelPath,
    this.hintPath,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTranslationProvider>(
      builder: (context, provider, child) {
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: provider.tr(labelPath, defaultValue: defaultValue),
            hintText: hintPath != null
                ? provider.tr(hintPath!, defaultValue: defaultValue)
                : null,
          ),
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
        );
      },
    );
  }
}
