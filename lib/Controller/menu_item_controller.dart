import 'package:get/get.dart';
import 'package:restaurant/Model/menu_item_model.dart';
import 'package:restaurant/Repo/menu_item_repo.dart';

class MenuItemController extends GetxController {
  final repo = MenuItemRepo();

  var menuItems = <MenuItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      isLoading(true);
      menuItems.value = await repo.fetchAllMenuItems();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addMenuItem(MenuItem item) async {
    try {
      await repo.addMenuItem(item);
      fetchMenuItems();
      Get.snackbar("Success", "Menu item added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateMenuItem(String id, MenuItem item) async {
    try {
      await repo.updateMenuItem(id, item);
      fetchMenuItems();
      Get.snackbar("Success", "Menu item updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteMenuItem(String id) async {
    try {
      await repo.deleteMenuItem(id);
      fetchMenuItems();
      Get.snackbar("Success", "Menu item deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
