import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Open a database connection (creates database file if it doesn't exist)
  final db = sqlite3.open('aluno.db');

  // Create the TB_ALUNO table if it doesn't exist
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL CHECK(length(nome) <= 50)
    );
  ''');

  print('Menu:');
  print('1 - Inserir aluno');
  print('2 - Listar alunos');
  print('0 - Sair');

  while (true) {
    stdout.write('\nEscolha uma opção: ');
    final input = stdin.readLineSync();
    if (input == null) continue;

    switch (input) {
      case '1':
        _insertAluno(db);
        break;
      case '2':
        _listAlunos(db);
        break;
      case '0':
        db.dispose();
        print('Encerrando o programa.');
        exit(0);
      default:
        print('Opção inválida!');
    }
  }
}

// Function to insert a student into the database
void _insertAluno(Database db) {
  stdout.write('Digite o nome do aluno (max 50 caracteres): ');
  String? nome = stdin.readLineSync();

  if (nome == null || nome.trim().isEmpty) {
    print('Nome inválido.');
    return;
  }

  if (nome.length > 50) {
    print('Nome excede 50 caracteres.');
    return;
  }

  final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
  stmt.execute([nome.trim()]);
  stmt.dispose();

  print('Aluno "$nome" inserido com sucesso.');
}

// Function to list all students
void _listAlunos(Database db) {
  final ResultSet result = db.select('SELECT id, nome FROM TB_ALUNO ORDER BY id;');
  if (result.isEmpty) {
    print('Nenhum aluno cadastrado.');
    return;
  }

  print('\nLista de alunos:');
  for (final row in result) {
    print('ID: ${row['id']}, Nome: ${row['nome']}');
  }
}