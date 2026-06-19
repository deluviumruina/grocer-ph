import 'package:get/get.dart';
import 'package:grocer_ph/data/repositories/store_category_repository.dart';
import 'package:grocer_ph/features/stores/models/store_category_model.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';

class StoreCategoryController extends GetxController {
  static StoreCategoryController get instance => Get.find();

  final _storeCategoryRepository = Get.put(StoreCategoryRepository());
  RxList<StoreCategoryModel> allStoreCategories = <StoreCategoryModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getStoreCategories();
    super.onInit();
  }

  /// -- Get ALL categories
  Future<void> getStoreCategories() async {
    try {
      isLoading.value = true;
      
      final storeCategories = await _storeCategoryRepository.getallStoreCategories();
      allStoreCategories.assignAll(storeCategories);
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// -- Get ALL categories, method
  Future<List<StoreCategoryModel>> getAllStoreCategoriesMethod () async {
    try {
      final storeCategories = await _storeCategoryRepository.getallStoreCategories();
      return storeCategories;
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());
      return [];
    }
  }
}