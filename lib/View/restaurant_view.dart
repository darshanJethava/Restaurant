import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/Controller/restaurant_controller.dart';
import 'package:restaurant/Model/restaurant_Model.dart';

class RestaurantView extends StatelessWidget {
  final RestaurantController controller = Get.put(RestaurantController());

  RestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => _showAddDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Restaurant'),
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
                if (controller.restaurants.isEmpty) {
                  return const Center(child: Text('No restaurants found'));
                }
                return ListView.builder(
                  itemCount: controller.restaurants.length,
                  itemBuilder: (context, index) {
                    final res = controller.restaurants[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(res.res_name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Address: ${res.res_add}'),
                            Text('Phone: ${res.res_phone}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue[700]),
                              onPressed: () => _showEditDialog(res),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRestaurant(res),
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
    final nameCtrl = TextEditingController();
    final addCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Restaurant'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: addCtrl,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                controller.addRestaurant(
                  Restaurant(
                    res_name: nameCtrl.text,
                    res_add: addCtrl.text,
                    res_phone: phoneCtrl.text,
                  ),
                );
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Restaurant restaurant) {
    final nameCtrl = TextEditingController(text: restaurant.res_name);
    final addCtrl = TextEditingController(text: restaurant.res_add);
    final phoneCtrl = TextEditingController(text: restaurant.res_phone);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Restaurant'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: addCtrl,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.updateRestaurant(
                restaurant.res_name,
                Restaurant(
                  res_name: nameCtrl.text,
                  res_add: addCtrl.text,
                  res_phone: phoneCtrl.text,
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

  void _deleteRestaurant(Restaurant restaurant) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Restaurant'),
        content: Text('Delete ${restaurant.res_name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteRestaurant(restaurant.res_name);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
