import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN
  Future<String?> logar(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return "Preencha todos os campos.";
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sucesso
    } on FirebaseAuthException {
      return "Credenciais inválidas. Verifique e tente novamente.";
    } catch (e) {
      return "Ocorreu um erro inesperado.";
    }
  }

  // REGISTRO
  Future<String?> cadastrar(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return "Preencha todos os campos.";
    }
    if (password.length < 6) {
      return "A senha deve ter pelo menos 6 caracteres.";
    }

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return "Este e-mail já está em uso.";
        case 'invalid-email':
          return "E-mail inválido.";
        case 'weak-password':
          return "A senha escolhida é muito fraca.";
        default:
          return "Erro no cadastro.";
      }
    } catch (e) {
      return "Erro ao criar conta.";
    }
  }

  Future<void> sair() async {
    await _auth.signOut();
  }
}
