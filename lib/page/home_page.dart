import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:projeto_pessoal/db/db_helper.dart';
import 'package:projeto_pessoal/page/paciente/paciente.dart';
import 'package:projeto_pessoal/widgets/dialogos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:text_mask/text_mask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formkey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  TextEditingController nomeController = TextEditingController();
  TextEditingController rgController = TextEditingController();
  TextEditingController setorController = TextEditingController();
  TextEditingController examesController = TextEditingController();
  TextEditingController dataExame = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  Paciente paciente = Paciente();

  List<Paciente> listPaciente = [];
  List<Paciente> listOfChecked = [];

  bool isLoading = false;

  @override
  void initState() {
    carregarItens();
    super.initState();
  }

  carregarItens() async {
    setState(() {
      isLoading = true;
    });

    listPaciente = await databaseHelper.getData();
    listOfChecked.clear();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Paciente',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: body(),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          insertPaciente(),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: listOfChecked.isEmpty
                                  ? null
                                  : () async {
                                      generatePDF();
                                      setState(() {
                                        listOfChecked.clear();
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Gerar Etiqueta(s)',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: listOfChecked.isEmpty
                                  ? null
                                  : () async {
                                      for (Paciente paciente in listOfChecked) {
                                        await databaseHelper
                                            .deleteData(paciente.id!);
                                      }
                                      carregarItens();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Excluir Pacientes',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  if (listOfChecked.length <
                                      listPaciente.length) {
                                    for (Paciente paciente in listPaciente) {
                                      if (!listOfChecked.contains(paciente)) {
                                        listOfChecked.add(paciente);
                                      }
                                    }
                                  } else {
                                    listOfChecked.clear();
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                listOfChecked.length < listPaciente.length
                                    ? 'Selecionar Todos'
                                    : 'Desmarcar Todos',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Pacientes Selecionados: ${listOfChecked.length}/${listPaciente.length}',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: consultaPaciente(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget insertPaciente() {
    return Expanded(
      child: Form(
        key: formkey,
        child: Column(
          children: [
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome Paciente',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: rgController,
                    decoration: const InputDecoration(
                      labelText: 'RG',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: TextFormField(
                  controller: dataExame,
                  decoration: const InputDecoration(
                    labelText: 'Data/Hora',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    TextMask(pallet: '##/##/#### ##:##'),
                    LengthLimitingTextInputFormatter(16),
                  ],
                )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: setorController,
              decoration: const InputDecoration(
                labelText: 'Setor',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: examesController,
              decoration: const InputDecoration(
                labelText: 'Exames',
              ),
              maxLines: null,
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  paciente.nome = nomeController.text;
                  paciente.local = setorController.text;
                  paciente.rg = int.parse(rgController.text);
                  paciente.exame = examesController.text;
                  paciente.data = dataExame.text;

                  int id = await databaseHelper.insertData(paciente);

                  if (id > 0 && mounted) {
                    Dialogos(context, 'Sucesso', 'Sucesso ao inserir registro');
                  } else {
                    if (mounted) {
                      Dialogos.erro(context, 'Erro', 'Erro ao inserir');
                    }
                  }

                  carregarItens();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget consultaPaciente(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : listPaciente.isEmpty
            ? Container()
            : Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: listPaciente.length,
                  itemBuilder: (context, index) {
                    return itensPaciente(listPaciente[index]);
                  },
                ),
              );
  }

  Widget itensPaciente(Paciente paciente) {
    List<Widget> botoes = [];

    bool isChecked = listOfChecked.contains(paciente);

    botoes.add(
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.delete),
        color: Colors.red,
      ),
    );

    return Card(
      elevation: 10,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 5.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 90,
                child: CheckboxListTile(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        listOfChecked.add(paciente);
                      } else {
                        listOfChecked.remove(paciente);
                      }
                    });
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Sequencia: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            paciente.id.toString(),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Nome: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            paciente.nome,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'RG: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            paciente.rg.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generatePDF() async {
    final pdf = pw.Document();

    List<pw.Widget> listEtiquetas = [];

    const double etiquetaWidth = PdfPageFormat.cm * 5;
    const double etiquetaHeight = PdfPageFormat.cm * 2.5;

    final int colunasPorPagina =
        (PdfPageFormat.a4.width / etiquetaWidth).floor();

    for (Paciente paciente in listOfChecked) {
      listEtiquetas.add(
        pw.Container(
          width: etiquetaWidth,
          height: etiquetaHeight,
          color: const PdfColor.fromInt(0xFFFFFFFF),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'P:${paciente.id.toString()}',
                      style: const pw.TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(paciente.data,
                        style: const pw.TextStyle(fontSize: 8)),
                  ),
                ],
              ),
              pw.Text(
                '${paciente.rg}${paciente.nome}',
                style: const pw.TextStyle(
                  fontSize: 8,
                ),
              ),
              pw.Text(
                paciente.local.isEmpty ? '-' : paciente.local,
                style: const pw.TextStyle(
                  fontSize: 8,
                ),
              ),
              pw.Text(
                paciente.exame,
                style: const pw.TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.GridView(
            crossAxisCount: colunasPorPagina,
            children: listEtiquetas,
            crossAxisSpacing: 5, // Espaçamento entre as colunas
            mainAxisSpacing: 5, // Espaçamento entre as linhas
          );
        },
      ),
    );

    final output = await getDatabasesPath();
    final file = File('$output/example.pdf');
    await file.writeAsBytes(await pdf.save());

    Printing.sharePdf(bytes: await pdf.save(), filename: 'example.pdf');
  }
}
