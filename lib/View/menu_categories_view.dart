import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/Controller/menu_categories_controller.dart';
import 'package:restaurant/Model/menu_categories_model.dart';

class MenuCategoryView extends StatelessWidget {
  final MenuCategoryController controller = Get.put(MenuCategoryController());

  MenuCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Categories'),
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
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Category'),
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
                if (controller.categories.isEmpty) {
                  return const Center(child: Text('No categories found'));
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
                              Expanded(flex: 2, child: _buildTableHeader('ID')),
                              Expanded(
                                flex: 2,
                                child: _buildTableHeader('Category Name'),
                              ),
                              Expanded(
                                flex: 2,
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
                          itemCount: controller.categories.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 0, color: Colors.grey[200]),
                          itemBuilder: (context, index) {
                            final category = controller.categories[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(category.menu_id),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(category.menu_cat_name),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(category.menu_cat_img),
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
                                              _showEditDialog(category),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _deleteCategory(category),
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
        fontSize: 13,
        color: Colors.grey,
      ),
    );
  }

  void _showAddDialog() {
    final idCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final imgCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'Category ID'),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Category Name'),
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
                controller.addCategory(
                  MenuCategories(
                    menu_id: idCtrl.text,
                    menu_cat_name: nameCtrl.text,
                    menu_cat_img: imgCtrl.text,
                  ),
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Please fill all fields');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(MenuCategories category) {
    final idCtrl = TextEditingController(text: category.menu_id);
    final nameCtrl = TextEditingController(text: category.menu_cat_name);
    final imgCtrl = TextEditingController(text: category.menu_cat_img);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'Category ID'),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Category Name'),
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
              controller.updateCategory(
                category.menu_id,
                MenuCategories(
                  menu_id: idCtrl.text,
                  menu_cat_name: nameCtrl.text,
                  menu_cat_img: imgCtrl.text,
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

  void _deleteCategory(MenuCategories category) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Delete ${category.menu_cat_name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteCategory(category.menu_id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
