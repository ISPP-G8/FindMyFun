import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential;
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    return credential;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
