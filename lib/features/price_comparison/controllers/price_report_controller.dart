import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/success_screen.dart';
import 'package:grocer_ph/data/repositories/authentication_repository.dart';
import 'package:grocer_ph/data/repositories/price_report_repository.dart';
import 'package:grocer_ph/data/repositories/product_repository.dart';
import 'package:grocer_ph/data/repositories/store_repository.dart';
import 'package:grocer_ph/data/repositories/user_repository.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';
import 'package:grocer_ph/navigation_menu.dart';
import 'package:grocer_ph/utils/constants/images.dart';
import 'package:grocer_ph/utils/loaders/loader_fullscreen.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';
import 'package:grocer_ph/utils/network_manager.dart';

class PriceReportController extends GetxController {
  static PriceReportController get instance => Get.find();

  /// -- [INIT]
  final priceReportRepository = Get.put(PriceReportRepository());

  /// -- [POST]
  String? productId;
  String? storeId;
  String? price; 
  GlobalKey<FormState> priceReportFormKey = GlobalKey<FormState>();

  /// - [SORT]
  final RxString selectedSortOption = 'Confirmations'.obs;
  final RxList<PriceReportModel> priceReports = <PriceReportModel>[].obs;

  // # -------------- [FORMATTING] -------------- #
  String formatImage(PriceReportModel priceReport) {
    String imageUrl;

    if (priceReport.productImage!.isEmpty || priceReport.productImage == null) {
      imageUrl = 'https://firebasestorage.googleapis.com/v0/b/sp-grocerph.firebasestorage.app/o/placeholder-image.png?alt=media&token=0c360493-c3da-4609-971c-253f713f5c8f';
    } else {
      imageUrl = priceReport.productImage!;
    }

    return imageUrl;
  }
  
  // # -------------- [GET] -------------- #
  /// -- Get PRODUCT (limited) price reports
  Future<List<PriceReportModel>> getLimitedProductPriceReports(String productId) async {
    try {
      final priceReports = await PriceReportRepository.instance.getLimitedProductPriceReports(productId);
      return priceReports;
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());
      return [];
    }
  }

  /// -- Get PRODUCT price reports for a specific STORE
  Future<List<PriceReportModel>> getStoreProductPriceReports(String productId, String storeId) async {
    try {
      final priceReports = await PriceReportRepository.instance.getStoreProductPriceReports(productId, storeId);
      return priceReports;
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());
      return [];
    }
  }

  /// -- Get PRODUCT AND STORE from price report
  Future<ProductModel> getProduct(String productId) async {
    try {
      ProductModel product = await ProductRepository.instance.getSingleProduct(productId);
      return product;
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());
      return ProductModel.empty();
    }
  }

  Future<StoreModel> getStore(String storeId) async {
    try {
      StoreModel store = await StoreRepository.instance.getSingleStore(storeId);
      return store;
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());
      return StoreModel.empty();
    }
  }

  // # -------------- [POST] -------------- #
  /// -- Add price report
  Future addPriceReport() async {
    try {

      /// -- Start Loading
      FullscreenLoader.openLoadingDialog('Processing data...', Images.loadingAnimation);

      /// -- Check Network Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullscreenLoader.stopLoading();
        return;
      }

      /// -- Validate Form
      if (!priceReportFormKey.currentState!.validate()) {
        FullscreenLoader.stopLoading();
        return;
      }

      priceReportFormKey.currentState!.save();

      final product = await ProductRepository.instance.getSingleProduct(productId!);
      final store = await StoreRepository.instance.getSingleStore(storeId!);
      final user = await UserRepository.instance.getUserDetails();

      /// -- Save Price Report Data
      final priceReport = PriceReportModel(
        id: '', 
        price: double.parse(price!.trim()), 
        date: DateTime.now(), 
        productId: productId!.trim(), 
        productName: product.name,
        productImage: product.image,
        storeId: storeId!.trim(), 
        storeName: store.name,
        storeLocation: store.location,
        userId: AuthenticationRepository.instance.authUser!.uid,
        userName: user.username,
        confirmations: 0,
        confirmationsList: []
      );
      await PriceReportRepository.instance.addPriceReport(priceReport);
      await ProductRepository.instance.updateFromPriceReport(productId!, storeId!);
      await StoreRepository.instance.updateFromPriceReport(storeId!);
      await UserRepository.instance.updateFromPriceReport();

      /// -- Stop Loading
      FullscreenLoader.stopLoading();

      /// -- Redirect to Success Screen
      Get.off(
        () => SuccessScreen(
          image: Images.successAnimation, 
          title: 'Your price report has been added to the database.', 
          subTitle: 'Thank you for your contribution.', 
          onPressed: () => Get.offAll(() => const NavigationMenu()),
        )
      );
    } catch (e) {
      FullscreenLoader.stopLoading();
      AppSnackBars.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // # -------------- [SORT] -------------- #
  void sortProducts (String sortOption, List<PriceReportModel> originalSort) {
    selectedSortOption.value = sortOption;

    switch (sortOption) {
      case 'Confirmations':
        priceReports.assignAll(originalSort);
      case 'Newest':
        priceReports.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Oldest':
        priceReports.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Lowest Price':
        priceReports.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Highest Price':
        priceReports.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        priceReports.assignAll(originalSort);
    }
  }

  void assignPriceReports(List<PriceReportModel> priceReports, String sortOption, List<PriceReportModel> originalSort) {
    this.priceReports.assignAll(priceReports);
    sortProducts(sortOption, originalSort);
  }
}