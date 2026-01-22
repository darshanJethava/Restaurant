import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/View/login_view.dart';
import 'package:restaurant/View/dashboard_view.dart';
import 'package:restaurant/Controller/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return GetMaterialApp(
      title: 'Restaurant POS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Obx(() {
        if (authController.isLoading.value) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return authController.isLoggedIn.value && authController.isManager()
            ? DashboardView()
            : const LoginView();
      }),
      getPages: [
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(
          name: '/dashboard',
          page: () => DashboardView(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isLoggedIn.value || !authController.isManager()) {
      Future.microtask(() {
        Get.offAllNamed('/login');
      });
      return RouteSettings(name: '/login');
    }

    return null;
  }
}
