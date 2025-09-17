import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> processAddUsers() async {
    if (passAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential adminCredential = await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);

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
          await userCredential.user!.sendEmailVerification();
          await auth.signOut();
          UserCredential adminCredential =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passAdminC.text);

          Get.back();
          Get.back();
          Get.snackbar("BERHASIL", "Berhasil menambahakan user");
        }

        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Terjadi Kesalahan', 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan',
              'The account already exists for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password salah !");
        }
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', e.toString());
      }
      ;
      Get.snackbar("Terjadi Kesalahan", "Password Salah");
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password Wajib Diisi untuk Validasi");
    }
  }

  void addUsers() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Validasi Akun",
          content: Column(
            children: [
              Text("Masukkan password untuk validasi admin"),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text('CANCEL')),
            OutlinedButton(
                onPressed: () async {
                  await processAddUsers();
                },
                child: Text('ADD USER'))
          ]);
    } else {
      Get.snackbar("Error", "Please fill all the fields");
    }
  }
}
