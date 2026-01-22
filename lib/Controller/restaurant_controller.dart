import 'package:get/get.dart';
import 'package:restaurant/Model/restaurant_Model.dart';
import 'package:restaurant/Repo/restaurant_repo.dart';

class RestaurantController extends GetxController {
  final repo = RestaurantRepo();

  var restaurants = <Restaurant>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      isLoading(true);
      restaurants.value = await repo.fetchAllRestaurants();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      await repo.addRestaurant(restaurant);
      fetchRestaurants();
      Get.snackbar("Success", "Restaurant added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateRestaurant(String id, Restaurant restaurant) async {
    try {
      await repo.updateRestaurant(id, restaurant);
      fetchRestaurants();
      Get.snackbar("Success", "Restaurant updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      await repo.deleteRestaurant(id);
      fetchRestaurants();
      Get.snackbar("Success", "Restaurant deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
