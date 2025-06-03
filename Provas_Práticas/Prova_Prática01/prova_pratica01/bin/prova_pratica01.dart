import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Professor {
  int id;
  String codigo;
  String nome;
  List<Disciplina> disciplinas = [];

  Professor({required this.id, required this.codigo, required this.nome});

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'nome': nome,
        'disciplinas': disciplinas.map((d) => d.toJson()).toList()
      };
}

class Aluno {
  int id;
  String nome;
  String matricula;

  Aluno({required this.id, required this.nome, required this.matricula});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'matricula': matricula,
      };
}

class Disciplina {
  int id;
  String descricao;
  int qtdAulas;

  Disciplina(
      {required this.id, required this.descricao, required this.qtdAulas});

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'qtdAulas': qtdAulas,
      };
}

class Curso {
  int id;
  String descricao;
  List<Professor> professores = [];
  List<Disciplina> disciplinas = [];
  List<Aluno> alunos = [];

  Curso({required this.id, required this.descricao});

  void adicionarProfessor(Professor professor) {
    professores.add(professor);
  }

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  void adicionarAluno(Aluno aluno) {
    alunos.add(aluno);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'professores': professores.map((p) => p.toJson()).toList(),
        'disciplinas': disciplinas.map((d) => d.toJson()).toList(),
        'alunos': alunos.map((a) => a.toJson()).toList()
      };
}

Future<void> main() async {

  var professor1 = Professor(id: 1, codigo: "P001", nome: "João Silva");
  var professor2 = Professor(id: 2, codigo: "P002", nome: "Maria Oliveira");

  var disciplina1 =
      Disciplina(id: 1, descricao: "Matemática", qtdAulas: 60);
  var disciplina2 = Disciplina(id: 2, descricao: "História", qtdAulas: 40);

  professor1.adicionarDisciplina(disciplina1);
  professor2.adicionarDisciplina(disciplina2);

  var aluno1 = Aluno(id: 1, nome: "Carlos Souza", matricula: "2023001");
  var aluno2 = Aluno(id: 2, nome: "Ana Lima", matricula: "2023002");

  var curso = Curso(id: 101, descricao: "Curso de Ciências");
  curso.adicionarProfessor(professor1);
  curso.adicionarProfessor(professor2);
  curso.adicionarDisciplina(disciplina1);
  curso.adicionarDisciplina(disciplina2);
  curso.adicionarAluno(aluno1);
  curso.adicionarAluno(aluno2);

  final jsonString = jsonEncode(curso.toJson());
  final file = File('curso.json');
  await file.writeAsString(jsonString);

  await enviarEmailComAnexo('curso.json');
}

Future<void> enviarEmailComAnexo(String caminhoArquivo) async {
  String username = 'levi.faleh61@aluno.ifce.edu.br';
  String password = 'zaqe todj evta xocu';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Levi Faleh')
    ..recipients.add('levifaleh626@gmail.com')
    ..subject = 'JSON do Projeto Curso'
    ..text = 'Segue anexo o JSON do projeto baseado no diagrama UML.'
    ..attachments = [
      FileAttachment(File(caminhoArquivo))
        ..location = Location.attachment
    ];

  try {
    final sendReport = await send(message, smtpServer);
    print('Email enviado com sucesso: ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('Erro ao enviar email: $e');
    for (var p in e.problems) {
      print('Problema: ${p.code}: ${p.msg}');
    }
  }
}
