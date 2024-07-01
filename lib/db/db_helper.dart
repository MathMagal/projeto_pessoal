// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:projeto_pessoal/page/paciente/paciente.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'dados_exames.db');

    return await openDatabase(dbPath, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE paciente (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome varchar(200),
        local varchar(200),
        rg INTEGER,
        exame varchar(200),
        data varchar(50),
        impresso varchar(1)
      )
    ''');
  }

  Future<int> insertData(Paciente paciente) async {
    Database db = await database;
    return await db.insert('paciente', paciente.toMap());
  }

  Future<List<Paciente>> getData() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('paciente');
    return List.generate(maps.length, (i) {
      return Paciente(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        local: maps[i]['local'],
        rg: maps[i]['rg'],
        exame: maps[i]['exame'],
        data: maps[i]['data'],
      );
    });
  }

  Future<int> updateData(Paciente paciente) async {
    Database db = await database;
    return await db.update('paciente', paciente.toMap(),
        where: 'id = ?', whereArgs: [paciente.id]);
  }

  Future<int> deleteData(int id) async {
    Database db = await database;
    return await db.delete('paciente', where: 'id = ?', whereArgs: [id]);
  }
}
