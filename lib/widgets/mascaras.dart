import 'package:flutter/services.dart';

class MaskTextInputFormatter extends TextInputFormatter {
  late String _mascara;
  late bool _validarTipo;

  ///O padrão para escrever a mascara é `X` Ex: `XX/XX/XXXX` sendo então aceito qualquer tipo de caracter nesse espaço<br>
  ///Pontuações adicionadas à mascaara serão adicionadas de acordo com o preencimento do campo<br>
  ///A função tambem limitará a escrita ao tamanho da mascara
  ///
  /// ```dart
  ///inputFormatters: [
  ///   MaskTextInputFormatter(
  ///     mascara: 'XX:XX'),
  ///],
  ///```
  ///Possivel resultado `a0:b1`<br>
  ///
  ///Caso queira validar o tipo da entrada use:
  ///```dart
  /// validarTipo = true
  ///```
  ///Assim no lugar da mascara que se encontrar X será apenas permitido caracteres alfabeticos e 0 numéricos
  ///```dart
  ///inputFormatters: [
  ///   MaskTextInputFormatter(
  ///     mascara: 'XX:00',validarTipo: true),
  ///],
  ///```
  ///Possivel resultado `ab:01`

  MaskTextInputFormatter({
    required String mascara,
    bool validarTipo = false,
  }) {
    _mascara = mascara;
    _validarTipo = validarTipo;
  }

  RegExp regExpAlfabetico = RegExp(
    r"[a-zA-Z]",
    caseSensitive: false,
    multiLine: false,
  );

  RegExp regExpNumerico = RegExp(
    r"[0-9]",
    caseSensitive: false,
    multiLine: false,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > _mascara.length) {
          return oldValue;
        }
        if (_validarTipo) {
          if (_mascara[newValue.text.length - 1] == 'X') {
            if (regExpAlfabetico
                .hasMatch(newValue.text.substring(newValue.text.length - 1))) {
              return newValue;
            } else {
              return oldValue;
            }
          }
          if (_mascara[newValue.text.length - 1] == '0') {
            if (regExpNumerico
                .hasMatch(newValue.text.substring(newValue.text.length - 1))) {
              return newValue;
            } else {
              return oldValue;
            }
          }
        }
        if (newValue.text.substring(newValue.text.length - 1) !=
            _mascara[newValue.text.length - 1]) {
          if (_validarTipo) {
            if (_mascara[newValue.text.length] == 'X') {
              if (regExpAlfabetico.hasMatch(
                  newValue.text.substring(newValue.text.length - 1))) {
                return TextEditingValue(
                  text:
                      '${oldValue.text}${_mascara[newValue.text.length - 1]}${newValue.text.substring(newValue.text.length - 1)}',
                  selection: TextSelection.collapsed(
                    offset: newValue.selection.end + 1,
                  ),
                );
              } else {
                return oldValue;
              }
            }
            if (_mascara[newValue.text.length] == '0') {
              if (regExpNumerico.hasMatch(
                  newValue.text.substring(newValue.text.length - 1))) {
                return TextEditingValue(
                  text:
                      '${oldValue.text}${_mascara[newValue.text.length - 1]}${newValue.text.substring(newValue.text.length - 1)}',
                  selection: TextSelection.collapsed(
                    offset: newValue.selection.end + 1,
                  ),
                );
              } else {
                return oldValue;
              }
            }
          } else {
            return TextEditingValue(
              text:
                  '${oldValue.text}${_mascara[newValue.text.length - 1]}${newValue.text.substring(newValue.text.length - 1)}',
              selection: TextSelection.collapsed(
                offset: newValue.selection.end + 1,
              ),
            );
          }
        }
      }
    }
    return newValue;
  }
}
