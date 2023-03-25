import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  dynamic error;

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

  //UPDATE PASSWORD
  Future<bool> updatePassword(
      String email, String currentPassword, String newPassword) async {
    final user = await _firebaseAuth.currentUser;
    bool result = false;
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: currentPassword);
    await user?.reauthenticateWithCredential(credential).then((value) {
      user.updatePassword(newPassword).then((_) {
        print("Contraseña cambiada");
        result = true;
        return result;
      }).catchError((error) {
        print(error);
        result = false;
        return result;
      });
    }).catchError((err) {
      print('catcherror');
      error = err;
      result = false;
      return result;
    });
    // Future.delayed(
    //   Duration(seconds: 2),
    // );
    print('WOWOWOWO ${result}');
    return result;
  }
}
