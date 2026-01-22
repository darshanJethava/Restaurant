import 'package:get/get.dart';
import 'package:restaurant/Model/user_Model.dart';
import 'package:restaurant/Repo/user_repo.dart';

class UserController extends GetxController {
  final repo = UserRepo();

  var Users = <User>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      isLoading(true);
      Users.value = await repo.fetchUser();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void addUser(User u) async {
    try {
      await repo.addUser(u);
      fetchUser();
      Get.snackbar("Success", "User added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void updateUser(User u) async {
    try {
      await repo.updateUser(u);
      fetchUser();
      Get.snackbar("Success", "User updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void deleteUser(String id) async {
    try {
      await repo.deleteUser(id);
      fetchUser();
      Get.snackbar("Success", "User deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
