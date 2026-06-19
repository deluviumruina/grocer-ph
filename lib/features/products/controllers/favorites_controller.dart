import 'dart:convert';

import 'package:get/get.dart';
import 'package:grocer_ph/data/repositories/product_repository.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';
import 'package:grocer_ph/utils/local_storage/storage_utility.dart';

class FavoritesController extends GetxController {
  static FavoritesController get instance => Get.find();

  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavorites();
  }

  /// -- Initialize favorites by reading from storage
  void initFavorites() {
    final json = LocalStorage.instance().readData('favorites');
    if (json != null) {
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  /// -- Check if product is favorited
  bool isFavorite(String productId) {
    return favorites[productId] ?? false;
  }

  /// -- Add/Remove product from favorites
  void toggleFavoriteProduct(String productId) {
    if(!favorites.containsKey(productId)) {
      favorites[productId] = true;
      saveFavoritesToStorage();
      AppSnackBars.customToast(message: 'Product has been added to favorites.');
    } else {
      LocalStorage.instance().removeData(productId);
      favorites.remove(productId);
      saveFavoritesToStorage();
      favorites.refresh();
      AppSnackBars.customToast(message: 'Product has been removed from favorites.');
    }
  }

  /// -- Save favorites to local storage
  void saveFavoritesToStorage() {
    final encodedFavorites = json.encode(favorites);
    LocalStorage.instance().saveData('favorites', encodedFavorites);
  }

  Future<List<ProductModel>> favoriteProducts() async {
    return await ProductRepository.instance.getFavoriteProducts(favorites.keys.toList());
  }


}