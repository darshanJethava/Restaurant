import 'package:flutter/material.dart';
import 'package:restaurant/Controller/user_controller.dart';
import 'package:restaurant/Model/user_Model.dart';
import 'package:get/get.dart';

class Listofuser extends StatelessWidget {
   Listofuser({super.key});

  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data"),),
      body: Obx(() => ListView.builder(
        itemCount: controller.Users.length,
        itemBuilder: (context, index) {
          final User u = controller.Users[index];
          return ListTile(
            title: Text(u.id),
            subtitle: Text(u.user_role),
          );
        },
      )),
    );
  }
}
