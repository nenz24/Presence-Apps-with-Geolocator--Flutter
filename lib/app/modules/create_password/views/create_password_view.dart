import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/create_password_controller.dart';

class CreatePasswordView extends GetView<CreatePasswordController> {
  const CreatePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CREATE PASSWORD'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              autocorrect: false,
              controller: controller.newPassC,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => controller.newPassword(),
              child: Text('CREATE PASSWORD'),
            ),
          ],
        ));
  }
}
