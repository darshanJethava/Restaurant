import 'package:restaurant/Model/restaurant_Model.dart';
import 'package:restaurant/Services/restaurant_services.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class RestaurantRepo {
  final RestaurantServices services = RestaurantServices();

  Future<List<Restaurant>> fetchAllRestaurants() async {
    try {
      final data = await services.getAllRestaurants();
      return data.map((e) {
        try {
          return Restaurant.fromJson(e as Map<String, dynamic>);
        } catch (e) {
          throw ParseException(
            message: 'Failed to parse restaurant data',
            originalException: e,
          );
        }
      }).toList();
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to fetch restaurants: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error fetching restaurants',
        originalException: e,
      );
    }
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      if (restaurant.res_name.isEmpty) {
        throw RepositoryException(message: 'Restaurant name cannot be empty');
      }

      await services.createRestaurant(restaurant.tojson());
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to add restaurant: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error adding restaurant',
        originalException: e,
      );
    }
  }

  Future<void> updateRestaurant(String id, Restaurant restaurant) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(message: 'Restaurant ID cannot be empty');
      }

      await services.updateRestaurant(id, restaurant.tojson());
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to update restaurant: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error updating restaurant',
        originalException: e,
      );
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      if (id.isEmpty) {
        throw RepositoryException(message: 'Restaurant ID cannot be empty');
      }

      await services.deleteRestaurant(id);
    } on ApiException catch (e) {
      throw RepositoryException(
        message: 'Failed to delete restaurant: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Unexpected error deleting restaurant',
        originalException: e,
      );
    }
  }
}
