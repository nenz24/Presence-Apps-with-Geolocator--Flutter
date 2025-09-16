import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addUsers() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );
        if (userCredential.user != null) {
          String? uid = userCredential.user?.uid;
          firestore.collection("users").doc(uid).set({
            "uid": uid,
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "CreatedAt": DateTime.now().toIso8601String(),
          });
        }

        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Terjadi Kesalahan', 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan',
              'The account already exists for that email.');
        }
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', e.toString());
      }
      ;
      // await users.doc(uidC.text).set(data);
      Get.back();
      Get.snackbar("Success", "Account Added");
    } else {
      Get.snackbar("Error", "Please fill all the fields");
    }
  }
}
