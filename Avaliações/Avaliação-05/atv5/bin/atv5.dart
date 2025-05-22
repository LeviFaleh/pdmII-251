import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

main() async {
  // Configura as credenciais SMTP do Gmail
  final smtpServer = gmail('levi.faleh61@aluno.ifce.edu.br', 'kqgp kjcw tbsg gcsw');

  // Cria uma mensagem de e-mail
  final message = Message()
    ..from = Address('levi.faleh61@aluno.ifce.edu.br', 'Seu Nome')
    ..recipients.add('levifaleh626@gmail.com')
    ..subject = 'Assunto do e-mail'
    ..text = 'Corpo do e-mail';

  try {
    // Envia o e-mail usando o servidor SMTP do Gmail
    final sendReport = await send(message, smtpServer);

    // Exibe o resultado do envio do e-mail
    print('E-mail enviado: ${sendReport}');
  } on MailerException catch (e) {
    // Exibe informações sobre erros de envio de e-mail
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
}