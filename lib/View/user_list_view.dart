import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/Controller/user_controller.dart';
import 'package:restaurant/Model/user_Model.dart';

class UserListView extends StatelessWidget {
  final UserController controller = Get.put(UserController());

  UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => _showAddDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.Users.isEmpty) {
                  return const Center(child: Text('No users found'));
                }
                return ListView.builder(
                  itemCount: controller.Users.length,
                  itemBuilder: (context, index) {
                    final user = controller.Users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text('ID: ${user.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Role: ${user.user_role}'),
                            Text('Restaurant: ${user.restaurantID}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue[700]),
                              onPressed: () => _showEditDialog(user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    final idCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final restaurantCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'User ID'),
              ),
              TextField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: roleCtrl,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: restaurantCtrl,
                decoration: const InputDecoration(labelText: 'Restaurant ID'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (idCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty) {
                controller.addUser(
                  User(
                    id: idCtrl.text,
                    username: idCtrl.text,
                    password: passwordCtrl.text,
                    user_role: roleCtrl.text,
                    restaurantID: restaurantCtrl.text,
                  ),
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Please fill required fields');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(User user) {
    final idCtrl = TextEditingController(text: user.id);
    final passwordCtrl = TextEditingController(text: user.password);
    final roleCtrl = TextEditingController(text: user.user_role);
    final restaurantCtrl = TextEditingController(text: user.restaurantID);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'User ID'),
              ),
              TextField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: roleCtrl,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: restaurantCtrl,
                decoration: const InputDecoration(labelText: 'Restaurant ID'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.updateUser(
                User(
                  id: idCtrl.text,
                  username: idCtrl.text,
                  password: passwordCtrl.text,
                  user_role: roleCtrl.text,
                  restaurantID: restaurantCtrl.text,
                ),
              );
              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(User user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Delete user ${user.id}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteUser(user.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
