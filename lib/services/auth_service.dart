import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  dynamic error;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  UserCredential? credential;

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return credential!;
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential!;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> deleteAccount() async {
    // await _firebaseAuth.signOut();
    try {
      await currentUser!.delete();
    } catch (e) {
      await currentUser!.reauthenticateWithCredential(credential!.credential!);
      await currentUser!.delete();
      await signOut();
    }
  }

  //UPDATE PASSWORD
  Future<bool> updatePassword(
      String email, String currentPassword, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    bool result = false;
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword);
      result = true;
    } catch (error) {
      // ignore: avoid_print
      print(error);
      result = false;
    }
    return result;
  }
}
