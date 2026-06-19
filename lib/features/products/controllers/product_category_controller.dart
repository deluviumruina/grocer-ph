import 'package:get/get.dart';
import 'package:grocer_ph/data/repositories/product_category_repository.dart';
import 'package:grocer_ph/features/products/models/product_category_model.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';

class ProductCategoryController extends GetxController {
  static ProductCategoryController get instance => Get.find();

  final _productCategoryRepository = Get.put(ProductCategoryRepository());
  RxList<ProductCategoryModel> allProductCategories = <ProductCategoryModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    getProductCategories();
    super.onInit();
  }

  /// -- Load Product Category data
  Future<void> getProductCategories() async {
    try {

      /// -- Show Loader while loading categories
      isLoading.value = true;

      /// -- Fetch categories from Firebase
      final productCategories = await _productCategoryRepository.getProductCategories();

      /// -- Update categories
      allProductCategories.assignAll(productCategories);

    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error', message: e.toString());
    } finally {

      /// -- Remove Loader
      isLoading.value = false;
    }
  }

  /// -- Get ALL categories, but as a Method
  Future<List<ProductCategoryModel>> getProductCategoriesMethod () async {
    try {

      final productCategories = await _productCategoryRepository.getProductCategories();
      return productCategories;

    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());
      return [];
    }
  }
}