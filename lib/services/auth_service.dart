import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get usuario {
    return _auth.authStateChanges();
  }

  Future<String?> cadastrar(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return null; 
    } on FirebaseAuthException catch (e) {
      return e.message; 
    }
  }

  Future<String?> logar(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> sair() async {
    await _auth.signOut();
  }
}