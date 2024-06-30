class Paciente {
  int? id;
  String nome;
  String local;
  int rg;
  String exame;
  String data;

  Paciente({
    this.id,
    this.nome = '',
    this.local = '',
    this.rg = 0,
    this.exame = '',
    this.data = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'local': local,
      'rg': rg,
      'exame': exame,
      'data': data,
    };
  }

  static Paciente fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: map['id'],
      nome: map['nome'] ?? '',
      local: map['local']?? '',
      rg: map['rg'] ?? 0,
      exame: map['exame'] ?? '',
      data: map['data'] ?? '',
    );
  }
}
