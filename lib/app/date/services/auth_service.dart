import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthServices extends GetxService {
  final FirebaseAuth firebaseAuth;
  final RxnString uid = RxnString();

  AuthServices(this.firebaseAuth);

  @override
  Future<void> onInit() async {
    uid.value = getCurrentAuthUser()?.uid;
    super.onInit();
  }

  Future<bool> registerWithEmail(String email, String password) async {
    try {
      final UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = authResult.user;

      uid.value = user?.uid;
      return user != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = authResult.user;

      uid.value = user?.uid;
      return user != null;
    } catch (e) {
      return false;
    }
  }

  bool isAuth() => firebaseAuth.currentUser != null;

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  User? getCurrentAuthUser() => firebaseAuth.currentUser;

  Future<void> delete() async {
    if (firebaseAuth.currentUser != null) {
      await firebaseAuth.currentUser!.delete();
    }
  }
}