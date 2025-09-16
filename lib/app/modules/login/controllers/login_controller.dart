import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      //proses login
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);
        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            Get.offAllNamed(Routes.HOME);
          } else {
            await userCredential.user!.sendEmailVerification();
            Get.snackbar("Terjadi Kesalahan", "Silahkan verifikasi email anda");
            return;
          }
        }

        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              'Terjadi Kesalahan', 'Wrong password provided for that user.');
        }
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', e.toString());
      }
    } else {
      Get.snackbar("Error", "Please fill all the fields");
    }
  }
}
