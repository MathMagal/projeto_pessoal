import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_pessoal/db/db_helper.dart';
import 'package:projeto_pessoal/page/paciente/paciente.dart';
import 'package:projeto_pessoal/widgets/dialogos.dart';
import 'package:text_mask/text_mask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formkey = GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController rgController = TextEditingController();
  TextEditingController setorController = TextEditingController();
  TextEditingController examesController = TextEditingController();
  TextEditingController dataExame = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  Paciente paciente = Paciente();
  List<Paciente> listPaciente = [];

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
          consultaPaciente(context),
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
    return Expanded(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : listPaciente.isEmpty
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listPaciente.length,
                      itemBuilder: (context, index) {
                        return itensPaciente(listPaciente[index]);
                      },
                    ),
                  ],
                ),
    );
  }

  Widget itensPaciente(Paciente paciente) {
    List<Widget> botoes = [];

    botoes.add(
      IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.print,
            color: Colors.green,
          )),
    );

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
                child: ListTile(
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
                  trailing: Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    children: botoes,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
