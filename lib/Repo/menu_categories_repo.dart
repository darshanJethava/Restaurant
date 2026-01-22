import 'package:restaurant/Model/menu_categories_model.dart';
import 'package:restaurant/Services/menu_categories_services.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class MenuCategoryRepo {
  final MenuCategoryServices services = MenuCategoryServices();

  Future<List<MenuCategories>> fetchAllCategories() async {
    try {
      final data = await services.getAllCategories();
      return data.map((e) {
        try {
          return MenuCategories.fromJson(e as Map<String, dynamic>);
        } catch (e) {
          throw ParseException(
            message: 'Failed to parse category data',
            originalException: e,
          );
        }
      }).toList();
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to fetch categories: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error fetching categories',
        originalException: e,
      );
    }
  }

  Future<void> addCategory(MenuCategories category) async {
    try {
      if (category.menu_id.isEmpty) {
        throw RepositoryException(message: 'Category ID cannot be empty');
      }

      await services.createCategory(category.toJson());
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to add category: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error adding category',
        originalException: e,
      );
    }
  }

  Future<void> updateCategory(String id, MenuCategories category) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(message: 'Category ID cannot be empty');
      }

      await services.updateCategory(id, category.toJson());
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to update category: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error updating category',
        originalException: e,
      );
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(message: 'Category ID cannot be empty');
      }

      await services.deleteCategory(id);
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to delete category: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error deleting category',
        originalException: e,
      );
    }
  }
}
