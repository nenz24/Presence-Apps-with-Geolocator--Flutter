import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class CreatePasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != 'password') {
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPassC.text);
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan", "Password Lemah");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat membuat password");
        }
      } else {
        Get.snackbar('TErjadi Kesalahan', 'Password harus beda');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Password baru harus diisi');
    }
  }
}
