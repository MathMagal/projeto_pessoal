import 'package:flutter/material.dart';

class Dialogos {
  BuildContext context;
  String titulo;
  String texto;
  TextButton? botaoOk;
  TextButton? botaoSim;
  TextButton? botaoNao;
  bool? barrierDismissible;
  TextStyle? tituloStyle;
  Icon? icone;
  Widget? widget;
  bool inverterBotaoSimNao;
  Color? tituloColor;
  TextAlign? textAlign;
  MainAxisAlignment? actionsAlignment;

  Dialogos(
    this.context,
    this.titulo,
    this.texto, {
    this.botaoOk,
    this.botaoSim,
    this.botaoNao,
    this.barrierDismissible,
    this.tituloStyle,
    this.icone,
    this.widget,
    this.inverterBotaoSimNao = false,
    this.tituloColor,
    this.textAlign,
    this.actionsAlignment,
  });

  static TextButton criarBotaoVazio(
    BuildContext context, {
    String texto = 'OK',
    TextStyle? textoStyle,
    Function()? onPresss,
  }) {
    return TextButton(
      onPressed: onPresss ?? () => Navigator.of(context).pop(),
      child: Text(texto, style: textoStyle ?? const TextStyle()),
    );
  }

  static TextButton criarBotaoSim(
    BuildContext context, {
    String texto = 'Sim',
    TextStyle? textoStyle,
    Color? corBotaoSim,
    Function()? onPresss,
  }) {
    return TextButton(
      onPressed: onPresss ?? () => Navigator.of(context).pop(),
      child: Text(
        texto,
        style: textoStyle ?? TextStyle(color: corBotaoSim ?? Colors.blue),
      ),
    );
  }

  static TextButton criarBotaoNao(
    BuildContext context, {
    String texto = 'Não',
    TextStyle? textoStyle,
    Color? corBotaoNao,
    Function()? onPresss,
  }) {
    return TextButton(
      onPressed: onPresss ?? () => Navigator.of(context).pop(),
      child: Text(
        texto,
        style: textoStyle ?? TextStyle(color: corBotaoNao ?? Colors.red),
      ),
    );
  }

  show({TextStyle? styleTitle}) {
    List<Widget> actions = [];

    if (botaoOk != null) {
      actions.add(botaoOk!);
    }
    if (botaoSim != null) {
      actions.add(botaoSim!);
    }
    if (botaoNao != null) {
      actions.add(botaoNao!);
    }
    if (botaoSim != null && actions.length == 1) {
      botaoNao = criarBotaoNao(context);
      actions.add(botaoNao!);
    }

    if (inverterBotaoSimNao &&
        botaoSim != null &&
        botaoNao != null &&
        actions.length == 2) {
      actions.clear();
      actions
        ..add(botaoNao!)
        ..add(botaoSim!);
    }

    if (actions.isEmpty) {
      actions.add(criarBotaoVazio(context));
    }

    FocusScope.of(context).requestFocus(FocusNode());

    AlertDialog alert = AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0), //antes 20
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: tituloStyle ?? const TextStyle(),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: icone!,
          // ),
        ],
      ),
      content: widget ??
          Text(
            texto,
            textAlign: textAlign ?? TextAlign.center,
          ),
      actions: actions,
      actionsAlignment: actionsAlignment ??
          (actions.length == 1
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly),
    );

    showAdaptiveDialog(
      context: context,
      barrierDismissible: barrierDismissible!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void info(
    BuildContext context,
    String titulo,
    String texto, {
    TextButton? botaoOk,
    TextButton? botaoSim,
    TextButton? botaoNao,
    bool barrierDismissible = true,
    Widget? widget,
    bool inverterBotaoSimNao = false,
    Color? tituloColor,
    TextAlign? textAlign,
    MainAxisAlignment? actionsAlignment,
  }) {
    Dialogos(
      context,
      titulo,
      texto,
      botaoOk: botaoOk,
      botaoSim: botaoSim,
      botaoNao: botaoNao,
      barrierDismissible: barrierDismissible,
      tituloStyle: TextStyle(
        color: tituloColor ?? Colors.lightBlue[400],
      ),
      icone: Icon(
        Icons.info_outline,
        color: Colors.lightBlue[400],
      ),
      widget: widget,
      inverterBotaoSimNao: inverterBotaoSimNao,
      tituloColor: tituloColor,
      textAlign: textAlign,
      actionsAlignment: actionsAlignment,
    ).show();
  }

  static void pergunta(
    BuildContext context,
    String titulo,
    String texto, {
    TextButton? botaoOk,
    TextButton? botaoSim,
    TextButton? botaoNao,
    bool barrierDismissible = true,
    Widget? widget,
    bool inverterBotaoSimNao = false,
    Color? tituloColor,
    Color? corBotaoSim,
    Color? corBotaoNao,
    TextAlign? textAlign,
    MainAxisAlignment? actionsAlignment,
  }) {
    Dialogos(
      context,
      titulo,
      texto,
      botaoOk: botaoOk,
      botaoSim: botaoSim,
      botaoNao: botaoNao,
      barrierDismissible: barrierDismissible,
      tituloStyle: TextStyle(
        color: tituloColor ?? Colors.blue,
      ),
      icone: const Icon(
        Icons.help_outline,
        color: Colors.blue,
      ),
      widget: widget,
      inverterBotaoSimNao: inverterBotaoSimNao,
      tituloColor: tituloColor,
      textAlign: textAlign,
      actionsAlignment: actionsAlignment,
    ).show();
  }

  static void alerta(
    BuildContext context,
    String titulo,
    String texto, {
    TextButton? botaoOk,
    TextButton? botaoSim,
    TextButton? botaoNao,
    bool barrierDismissible = true,
    Widget? widget,
    bool inverterBotaoSimNao = false,
    Color? tituloColor,
    TextAlign? textAlign,
    MainAxisAlignment? actionsAlignment,
  }) {
    Dialogos(
      context,
      titulo,
      texto,
      botaoOk: botaoOk,
      botaoSim: botaoSim,
      botaoNao: botaoNao,
      barrierDismissible: barrierDismissible,
      tituloStyle: TextStyle(color: tituloColor ?? Colors.amber),
      icone: const Icon(
        Icons.warning_amber_outlined,
        color: Colors.amber,
      ),
      widget: widget,
      inverterBotaoSimNao: inverterBotaoSimNao,
      tituloColor: tituloColor,
      textAlign: textAlign,
      actionsAlignment: actionsAlignment,
    ).show();
  }

  static void erro(
    BuildContext context,
    String titulo,
    String texto, {
    TextButton? botaoOk,
    TextButton? botaoSim,
    TextButton? botaoNao,
    bool barrierDismissible = true,
    Widget? widget,
    bool inverterBotaoSimNao = false,
    Color? tituloColor,
    TextAlign? textAlign,
    MainAxisAlignment? actionsAlignment,
  }) {
    Dialogos(
      context,
      titulo,
      texto,
      botaoOk: botaoOk,
      botaoSim: botaoSim,
      botaoNao: botaoNao,
      barrierDismissible: barrierDismissible,
      tituloStyle: TextStyle(color: tituloColor ?? Colors.red),
      icone: const Icon(
        Icons.cancel_outlined,
        color: Colors.red,
      ),
      widget: widget,
      inverterBotaoSimNao: inverterBotaoSimNao,
      tituloColor: tituloColor,
      textAlign: textAlign,
      actionsAlignment: actionsAlignment,
    ).show();
  }

  static void sucesso(
    BuildContext context,
    String titulo,
    String texto, {
    TextButton? botaoOk,
    TextButton? botaoSim,
    TextButton? botaoNao,
    bool barrierDismissible = true,
    Widget? widget,
    bool inverterBotaoSimNao = false,
    Color? tituloColor,
    TextAlign? textAlign,
    MainAxisAlignment? actionsAlignment,
  }) {
    Dialogos(
      context,
      titulo,
      texto,
      botaoOk: botaoOk,
      botaoSim: botaoSim,
      botaoNao: botaoNao,
      barrierDismissible: barrierDismissible,
      tituloStyle: TextStyle(color: tituloColor ?? Colors.green),
      icone: const Icon(
        Icons.check_circle_outline,
        color: Colors.green,
      ),
      widget: widget,
      inverterBotaoSimNao: inverterBotaoSimNao,
      tituloColor: tituloColor,
      textAlign: textAlign,
      actionsAlignment: actionsAlignment,
    ).show();
  }

  static void excluir(
    BuildContext context,
    TextButton? botaoSim, {
    String titulo = 'Exclusão',
    String texto = 'Deseja realmente excluir?',
    TextButton? botaoNao,
    bool barrierDismissible = true,
    Widget? widget,
    bool inverterBotaoSimNao = false,
    Color? tituloColor,
    TextAlign? textAlign,
    MainAxisAlignment? actionsAlignment,
  }) {
    Dialogos(
      context,
      titulo,
      texto,
      botaoSim: botaoSim,
      botaoNao: botaoNao ?? criarBotaoNao(context),
      barrierDismissible: barrierDismissible,
      tituloStyle: TextStyle(color: tituloColor ?? Colors.red),
      icone: const Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
      widget: widget,
      inverterBotaoSimNao: inverterBotaoSimNao,
      tituloColor: tituloColor,
      textAlign: textAlign,
      actionsAlignment: actionsAlignment,
    ).show();
  }

  static void aguarde(
    BuildContext context,
    GlobalKey key,
    String texto, {
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) async => false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      texto,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
