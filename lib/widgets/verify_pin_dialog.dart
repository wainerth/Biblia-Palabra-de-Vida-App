import 'dart:async';

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyPinDialog extends StatefulWidget {
  final String email;
  final Function(String) onPinVerified;
  final Function() onResendCode;

  const VerifyPinDialog({
    super.key,
    required this.email,
    required this.onPinVerified,
    required this.onResendCode,
  });

  @override
  _VerifyPinDialogState createState() => _VerifyPinDialogState();
}

class _VerifyPinDialogState extends State<VerifyPinDialog> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _pin = '';
  bool _isLoading = false;
  bool _isError = false;

  late Timer _timer;
  int _secondsRemaining = 300; // 5 minutos en segundos
  bool _canResend = false;

  final GlobalKey _pasteButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startTimer();
    // Auto-focus en el primer campo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  void _handlePaste(String pastedText) {
    final digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isNotEmpty) {
      for (int i = 0; i < 6; i++) {
        if (i < digits.length) {
          _controllers[i].text = digits[i];
        } else {
          _controllers[i].clear();
        }
      }

      // Mover focus al último campo lleno
      final lastFilledIndex = digits.length >= 6 ? 5 : digits.length - 1;
      if (lastFilledIndex >= 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(_focusNodes[lastFilledIndex]);
          }
        });
      }
    }

    _updatePin();
  }

  void _updatePin() {
    final pin = _controllers.map((c) => c.text).join();
    setState(() {
      _pin = pin;
      _isError = false;
    });

    // Auto-verificar cuando se complete el PIN
    if (pin.length == 6) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          _verifyPin();
        }
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final pastedText = clipboardData?.text ?? '';

      if (pastedText.isNotEmpty) {
        if (pastedText.length > 6) {
          showSnackBar('Error al pegar el código', type: SnackBarType.error);
        } else {
          _handlePaste(pastedText);

          // Mostrar mensaje de éxito
          showSnackBar('Código pegado correctamente',
              type: SnackBarType.success);
        }
      } else {
        showSnackBar('No hay texto en el portapapeles',
            type: SnackBarType.info);
      }
    } catch (e) {
      showSnackBar('Error al pegar el código', type: SnackBarType.error);
    }
  }

  void _verifyPin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Simular verificación (reemplazar con tu lógica real)
    await Future.delayed(Duration(milliseconds: 800));

    setState(() => _isLoading = false);

    if (_pin.isNotEmpty) {
      // Ejemplo, cambiar por tu validación
      widget.onPinVerified(_pin);
      Navigator.of(context).pop();
    } else {
      setState(() => _isError = true);
      _clearAllFields();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FocusScope.of(context).requestFocus(_focusNodes[0]);
        }
      });
    }
  }

  void _clearAllFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() => _pin = '');
  }

  void _resendCode() {
    widget.onResendCode();
    showSnackBar('Código reenviado a ${widget.email}',
        type: SnackBarType.success);
    setState(() {
      _secondsRemaining = 300; // 5 minutos
      _canResend = false;
    });
    _clearAllFields();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      }
    });
  }

  Widget _buildInputCode(int index) {
    return Container(
      width: 45,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isError
              ? Colors.red
              : _focusNodes[index].hasFocus
                  ? StyleColor.blueHigh
                  : Colors.grey[300]!,
          width: _focusNodes[index].hasFocus ? 2 : 1.5,
        ),
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: StylesApp(context).textStyleBody16.copyWith(
              color: StyleColor.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (value.length > 1) {
              // Si se pega más de un carácter
              _handlePaste(value);
            } else {
              // Mover al siguiente campo automáticamente
              if (index < 5) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                  }
                });
              } else {
                // Último campo - quitar focus
                FocusScope.of(context).unfocus();
              }
            }
          } else {
            // Si se borró, mover al campo anterior
            if (index > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                }
              });
            }
          }

          // Actualizar el PIN inmediatamente
          _updatePin();
        },
        onTap: () {
          // Seleccionar todo el texto cuando se toca el campo
          _controllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[index].text.length,
          );
        },
      ),
    );
  }

  Widget _buildPasteButton() {
    return Container(
      key: _pasteButtonKey,
      margin: EdgeInsets.only(left: 16),
      child: IconButton(
        onPressed: _isLoading ? null : _pasteFromClipboard,
        icon: Icon(Icons.paste, size: 16),
        // label: Text(
        //   'PEGAR',
        //   style: StylesApp(context).textStyleBody12.copyWith(
        //         fontWeight: FontWeight.bold,
        //       ),
        // ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: StyleColor.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 1,
        ),
      ),
    );
  }

  Widget _buildTimerWidget() {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Text(
        'Puedes reenviar en: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: StylesApp(context).textStyleBody14.copyWith(
              color: _canResend ? StyleColor.greenDark : StyleColor.redLight,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: StyleColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono
                Icon(
                  Icons.verified_user_outlined,
                  size: 64,
                  color: StyleColor.greenDark,
                ),
                SizedBox(height: 16),

                // Título
                Text(
                  'Verificación de Seguridad',
                  style: StylesApp(context).textStyleBody20.copyWith(
                        color: StyleColor.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 12),

                // Mensaje
                Text(
                  'Hemos enviado un código de 6 dígitos a:',
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: StyleColor.grayDark,
                      ),
                ),
                SizedBox(height: 4),

                // Email
                Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleBody16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: StyleColor.blueHigh,
                      ),
                ),
                SizedBox(height: 24),

                // Fila con campos del PIN y botón de pegar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Campos del PIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(6, (index) => _buildInputCode(index)),
                    ),

                    // Botón de pegar
                    _buildPasteButton(),
                  ],
                ),
                SizedBox(height: 8),

                // Mensaje de ayuda para pegar
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Puedes pegar el código completo del correo',
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: StyleColor.grayMedium,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),

                // Mensaje de error
                if (_isError)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Código incorrecto. Intente nuevamente.',
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),

                SizedBox(height: 24),

                // Botón de verificación
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _pin.length == 6 && !_isLoading ? _verifyPin : null,
                    style: StylesApp(context).btnSecondary.copyWith(
                          padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 16)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.disabled)) {
                              return StyleColor.grayDark;
                            }
                            return StyleColor.orange;
                          }),
                          foregroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.disabled)) {
                              return StyleColor.grayMedium;
                            }
                            return Colors.white;
                          }),
                          overlayColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.disabled)) {
                              return Colors.transparent;
                            }
                            return Colors.white.withOpacity(0.1);
                          }),
                          elevation: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.disabled)) {
                              return 0;
                            }
                            return 2;
                          }),
                          maximumSize:
                              WidgetStatePropertyAll(Size(200.0, 60.0)),
                          minimumSize: WidgetStatePropertyAll(Size(0, 0)),
                        ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            'VERIFICAR CÓDIGO',
                            style: StylesApp(context)
                                .textStyleBody16
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                SizedBox(height: 16),

                // Enlace para reenviar código
                TextButton(
                  onPressed: _canResend && !_isLoading ? _resendCode : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 18,
                        color: _canResend ? StyleColor.blueDark : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Reenviar código',
                        style: StylesApp(context).textStyleBody16.copyWith(
                              color: _canResend
                                  ? StyleColor.blueDark
                                  : Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),

// Contador
                _buildTimerWidget(),

                // Enlace de ayuda
                TextButton(
                  onPressed: () {
                    // Mostrar ayuda
                    _showHelpDialog();
                  },
                  child: Text(
                    '¿No recibiste el código?',
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: StyleColor.blueDark,
                          decoration: TextDecoration.underline,
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Ayuda',
          style: StylesApp(context).textStyleBody18.copyWith(
            color: StyleColor.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Si no recibiste el código:',
              style: StylesApp(context).textStyleBody16.copyWith(
                color: StyleColor.black
              ),
            ),
            SizedBox(height: 8),
            Text(
              '1. Revisa tu carpeta de spam o correo no deseado',
              style: StylesApp(context).textStyleBody14.copyWith(
                color: StyleColor.black
              ),
            ),
            Text(
              '2. Verifica que el correo electrónico sea correcto',
              style: StylesApp(context).textStyleBody14.copyWith(
                color: StyleColor.black
              ),
            ),
            Text(
              '3. Espera unos minutos y haz clic en "Reenviar código"',
              style: StylesApp(context).textStyleBody14.copyWith(
                color: StyleColor.black
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer.cancel();
      }
    });
  }
}

// Función para mostrar el diálogo
void showVerifyPinDialog({
  required BuildContext context,
  required String email,
  required Function(String) onPinVerified,
  required Function() onResendCode,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => VerifyPinDialog(
      email: email,
      onPinVerified: onPinVerified,
      onResendCode: onResendCode,
    ),
  );
}
