import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/Controller/user_controller.dart';
import 'package:restaurant/Controller/auth_controller.dart';
import 'package:restaurant/View/restaurant_view.dart';
import 'package:restaurant/View/user_list_view.dart';
import 'package:restaurant/View/table_view.dart';
import 'package:restaurant/View/menu_categories_view.dart';
import 'package:restaurant/View/menu_item_view.dart';

class DashboardView extends StatelessWidget {
  final UserController controller = Get.put(UserController());
  final AuthController authController = Get.put(AuthController());

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Management'),
        backgroundColor: Colors.blue[700],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[700]),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.restaurant, size: 40, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      'Restaurant Manager',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Username: ${authController.userData['username'] ?? 'N/A'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _menuItem(Icons.store, 'Restaurants', () {
              Get.to(() => RestaurantView());
            }),
            _menuItem(Icons.people, 'Users', () {
              Get.to(() => UserListView());
            }),
            _menuItem(Icons.table_restaurant, 'Tables', () {
              Get.to(() => TableView());
            }),
            _menuItem(Icons.category, 'Categories', () {
              Get.to(() => MenuCategoryView());
            }),
            _menuItem(Icons.dining, 'Menu Items', () {
              Get.to(() => MenuItemView());
            }),
            _menuItem(Icons.receipt, 'Orders', () {}),
            _menuItem(Icons.shopping_cart, 'Items', () {}),
            _menuItem(Icons.kitchen, 'Kitchen', () {}),
            const Divider(),
            _menuItem(Icons.logout, 'Logout', () {
              authController.logout();
            }, isRed: true),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Users',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.Users.isEmpty) {
                  return Center(
                    child: Text(
                      'No users',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.Users.length,
                  itemBuilder: (context, index) {
                    final user = controller.Users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text('${user.id}'),
                        subtitle: Text('${user.user_role}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue[700]),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {},
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

  static ListTile _menuItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isRed = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.red : Colors.blue[700]),
      title: Text(
        label,
        style: TextStyle(
          color: isRed ? Colors.red : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
