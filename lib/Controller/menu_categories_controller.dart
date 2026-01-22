import 'package:get/get.dart';
import 'package:restaurant/Model/menu_categories_model.dart';
import 'package:restaurant/Repo/menu_categories_repo.dart';

class MenuCategoryController extends GetxController {
  final repo = MenuCategoryRepo();

  var categories = <MenuCategories>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      categories.value = await repo.fetchAllCategories();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCategory(MenuCategories category) async {
    try {
      await repo.addCategory(category);
      fetchCategories();
      Get.snackbar("Success", "Category added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateCategory(String id, MenuCategories category) async {
    try {
      await repo.updateCategory(id, category);
      fetchCategories();
      Get.snackbar("Success", "Category updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await repo.deleteCategory(id);
      fetchCategories();
      Get.snackbar("Success", "Category deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
