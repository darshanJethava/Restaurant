import 'package:get/get.dart';
import 'package:restaurant/Services/auth_service.dart';

class AuthController extends GetxController {
  final authService = AuthService();

  var isLoggedIn = false.obs;
  var isLoading = false.obs;
  var userRole = ''.obs;
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      isLoading(true);
      final loggedIn = await authService.isLoggedIn();
      final role = await authService.getUserRole();
      final user = await authService.getUserData();

      if (loggedIn && role != null) {
        isLoggedIn(true);
        userRole(role);
        if (user != null) {
          userData(user);
        }
      } else {
        isLoggedIn(false);
        userRole('');
        userData({});
      }
    } catch (e) {
      isLoggedIn(false);
      userRole('');
      userData({});
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading(true);
      final result = await authService.login(username, password);

      isLoggedIn(true);
      userRole(result['role'] ?? '');
      userData(result['user'] ?? {});

      Get.snackbar('Success', 'Login successful');
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      isLoading(true);
      await authService.logout();

      isLoggedIn(false);
      userRole('');
      userData({});

      Get.snackbar('Success', 'Logout successful');
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  bool isManager() {
    return userRole.value.toLowerCase() == 'manager';
  }
}
