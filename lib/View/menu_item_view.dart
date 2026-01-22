import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/Controller/menu_item_controller.dart';
import 'package:restaurant/Model/menu_item_model.dart';

class MenuItemView extends StatelessWidget {
  final MenuItemController controller = Get.put(MenuItemController());

  MenuItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Items'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
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
                if (controller.menuItems.isEmpty) {
                  return const Center(child: Text('No menu items found'));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: _buildTableHeader('ID')),
                              Expanded(
                                flex: 2,
                                child: _buildTableHeader('Item Name'),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildTableHeader('Price'),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildTableHeader('Category'),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildTableHeader('Image'),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildTableHeader('Actions'),
                              ),
                            ],
                          ),
                        ),
                        // Table Rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.menuItems.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 0, color: Colors.grey[200]),
                          itemBuilder: (context, index) {
                            final item = controller.menuItems[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(item.menu_item_id),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(item.menu_item_name),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(item.item_price),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(item.category_id),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      item.item_img.length > 20
                                          ? '${item.item_img.substring(0, 20)}...'
                                          : item.item_img,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue[700],
                                          ),
                                          onPressed: () =>
                                              _showEditDialog(item),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _deleteItem(item),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  void _showAddDialog() {
    final idCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final imgCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'Item ID'),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category ID'),
              ),
              TextField(
                controller: imgCtrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (idCtrl.text.isNotEmpty && nameCtrl.text.isNotEmpty) {
                controller.addMenuItem(
                  MenuItem(
                    menu_item_id: idCtrl.text,
                    menu_item_name: nameCtrl.text,
                    item_price: priceCtrl.text,
                    category_id: categoryCtrl.text,
                    item_img: imgCtrl.text,
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

  void _showEditDialog(MenuItem item) {
    final idCtrl = TextEditingController(text: item.menu_item_id);
    final nameCtrl = TextEditingController(text: item.menu_item_name);
    final priceCtrl = TextEditingController(text: item.item_price);
    final categoryCtrl = TextEditingController(text: item.category_id);
    final imgCtrl = TextEditingController(text: item.item_img);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'Item ID'),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category ID'),
              ),
              TextField(
                controller: imgCtrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.updateMenuItem(
                item.menu_item_id,
                MenuItem(
                  menu_item_id: idCtrl.text,
                  menu_item_name: nameCtrl.text,
                  item_price: priceCtrl.text,
                  category_id: categoryCtrl.text,
                  item_img: imgCtrl.text,
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

  void _deleteItem(MenuItem item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Delete ${item.menu_item_name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteMenuItem(item.menu_item_id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
