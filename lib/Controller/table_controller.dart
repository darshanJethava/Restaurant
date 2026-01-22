import 'package:get/get.dart';
import 'package:restaurant/Model/table_Model.dart';
import 'package:restaurant/Repo/table_repo.dart';

class TableController extends GetxController {
  final repo = TableRepo();

  var tables = <Table>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTables();
  }

  Future<void> fetchTables() async {
    try {
      isLoading(true);
      tables.value = await repo.fetchAllTables();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTable(Table table) async {
    try {
      await repo.addTable(table);
      fetchTables();
      Get.snackbar("Success", "Table added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateTable(String id, Table table) async {
    try {
      await repo.updateTable(id, table);
      fetchTables();
      Get.snackbar("Success", "Table updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteTable(String id) async {
    try {
      await repo.deleteTable(id);
      fetchTables();
      Get.snackbar("Success", "Table deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
