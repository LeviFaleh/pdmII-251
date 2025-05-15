import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  // 1. Criar vários objetos Dependentes
  var dependente1 = Dependente('Carlos');
  var dependente2 = Dependente('Ana');
  var dependente3 = Dependente('Pedro');
  var dependente4 = Dependente('Julia');

  // 2. Criar vários objetos Funcionário
  var funcionario1 = Funcionario('João', [dependente1, dependente2]);
  var funcionario2 = Funcionario('Maria', [dependente3]);
  var funcionario3 = Funcionario('José', [dependente4]);

  // 4. Criar uma lista de Funcionários
  var listaFuncionarios = [funcionario1, funcionario2, funcionario3];

  // 5. Criar um objeto EquipeProjeto
  var equipeProjeto = EquipeProjeto('Projeto Dart Avançado', listaFuncionarios);

  // 6. Printar no formato JSON o objeto EquipeProjeto
  String jsonEquipe = jsonEncode(equipeProjeto.toJson());
  print(jsonEquipe);
}
