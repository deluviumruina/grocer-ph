import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/success_screen.dart';
import 'package:grocer_ph/data/repositories/product_repository.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/navigation_menu.dart';
import 'package:grocer_ph/utils/constants/images.dart';
import 'package:grocer_ph/utils/formatters/formatters.dart';
import 'package:grocer_ph/utils/loaders/loader_fullscreen.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';
import 'package:grocer_ph/utils/network_manager.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  /// -- [INIT]
  final _productRepository = Get.put(ProductRepository());
  RxList<ProductModel> homeProducts = <ProductModel>[].obs;
  final isLoading = false.obs;

  /// -- [POST]
  String? name;
  String? categoryId;
  String? description;
  File? image; 
  String? downloadUrl;
  GlobalKey<FormState> productFormKey = GlobalKey<FormState>();

  /// -- [SORT]
  final RxString selectedSortOption = 'Newest'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    getHomeProducts();
    super.onInit();
  }

  // # -------------- [FORMATTING] Default Values -------------- # 
  /// -- Add Default Value to image if empty
  String formatImage(ProductModel product) {
    String imageUrl;

    if (product.image!.isEmpty || product.image == null) {
      imageUrl = 'https://firebasestorage.googleapis.com/v0/b/sp-grocerph.firebasestorage.app/o/placeholder-image.png?alt=media&token=0c360493-c3da-4609-971c-253f713f5c8f';
    } else {
      imageUrl = product.image!;
    }

    return imageUrl;
  }

  /// -- Add Default Value to description if empty
  String formatDescription(ProductModel product) {
    String description;

    if (product.description!.isEmpty || product.description == null) {
      description = 'Add a product description.';
    } else {
      description = product.description!;
    }

    return description;
  }

  // # -------------- [FORMATTING] Quantities -------------- # 
  /// -- Format PRICE REPORT TOTAL
  String formatPriceReportNumber(ProductModel product) {
    String priceReportNumber;

    if (product.priceReports == 1) {
      priceReportNumber = '1 price report';
    } else {
      priceReportNumber = '${product.priceReports.toString()} reports';
    }

    return priceReportNumber;
  }

  /// -- Format PRICE RANGE
  String formatPriceRange(ProductModel product) {
    String priceRange;

    if (product.priceMinimum == 0.00) {
      priceRange = '0.00';
    }

    if (product.priceMinimum == product.priceMaximum) {
      priceRange = GFormatter.formatPrice(product.priceMinimum!);
    } else {
      priceRange = '${GFormatter.formatPrice(product.priceMinimum!)} - ₱${GFormatter.formatPrice(product.priceMaximum!)}';
    }

    return priceRange;
  }


  // # -------------- [GET] -------------- #  
  /// -- Get HOME Products
  void getHomeProducts() async {
    try {

      /// -- Show Loader while loading products
      isLoading.value = true;

      /// -- Fetch Products
      final products = await _productRepository.getHomeProducts();

      /// -- Assign Products
      homeProducts.assignAll(products);
      
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // # -------------- [CREATE] -------------- #  
  Future addProduct() async {
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
      if (!productFormKey.currentState!.validate()) {
        FullscreenLoader.stopLoading();
        return;
      }

      if (image != null) {
        var imageName = DateTime.now().millisecondsSinceEpoch.toString();
        var storageRef = FirebaseStorage.instance.ref().child('products/$imageName.jpg');

        var uploadTask = storageRef.putFile(image!);
        downloadUrl = await (await uploadTask).ref.getDownloadURL();
      } else {
        downloadUrl = '';
      }

      productFormKey.currentState!.save();

      /// -- Save Product Data
      final product = ProductModel(
        id: '', 
        name: name!.trim(),
        categoryId: categoryId!.trim(),
        description: description!.trim(),
        image: downloadUrl.toString(),
        lastUpdated: DateTime.now(),
        priceReports: 0,
      );
      await _productRepository.addProduct(product);

      /// -- Stop Loading
      FullscreenLoader.stopLoading();

      /// -- Redirect to Success Screen
      Get.off(
        () => SuccessScreen(
          image: Images.successAnimation, 
          title: 'Your product has been added to the database.', 
          subTitle: 'Thank you for your contribution.', 
          onPressed: () => Get.offAll(() => const NavigationMenu()),
        )
      );
    } catch (e) {
      FullscreenLoader.stopLoading();
      AppSnackBars.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // # -------------- [UPDATE] -------------- #
  Future updateProduct(ProductModel product) async {
    try {
      final Map<String, dynamic> updates = {};

      /// -- Start Loading
      FullscreenLoader.openLoadingDialog('Processing data...', Images.loadingAnimation);

      /// -- Check Network Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullscreenLoader.stopLoading();
        return;
      }

      /// -- Validate Form
      if (!productFormKey.currentState!.validate()) {
        FullscreenLoader.stopLoading();
        return;
      }

      if (image != null) {
        var imageName = DateTime.now().millisecondsSinceEpoch.toString();
        var storageRef = FirebaseStorage.instance.ref().child('products/$imageName.jpg');

        var uploadTask = storageRef.putFile(image!);
        downloadUrl = await (await uploadTask).ref.getDownloadURL();
      } else {
        downloadUrl = '';
      }

      productFormKey.currentState!.save();

      if (name!.trim() != product.name) {
        updates['Name'] = name!.trim();
      }

      if (description!.trim() != product.description) {
        updates['Description'] = description!.trim();
      }

      if (downloadUrl!.isNotEmpty && downloadUrl.toString() != product.image) {
        updates['Image'] = downloadUrl.toString();
      }

      if (updates.isNotEmpty) {
        updates['LastUpdated'] = DateTime.now();
        await _productRepository.updateProduct(product.id, updates);
      }

      /// -- Stop Loading
      FullscreenLoader.stopLoading();

      /// -- Redirect to Success Screen
      Get.off(
        () => SuccessScreen(
          image: Images.successAnimation, 
          title: 'Your product has been updated.', 
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
  void sortProducts (String sortOption, List<ProductModel> originalSort) {
    selectedSortOption.value = sortOption;

    switch (sortOption) {
      case 'Newest':
        products.assignAll(originalSort);
        break;
      case 'Oldest':
        products.sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
        break;
      case 'Most Reported':
        products.sort((a, b) => b.priceReports.compareTo(a.priceReports));
        break;
      case 'Least Reported':
        products.sort((a, b) => a.priceReports.compareTo(b.priceReports));
        break;
      default:
        products.assignAll(originalSort);
    }
  }

  void assignProducts(List<ProductModel> products, String sortOption, List<ProductModel> originalSort) {
    this.products.assignAll(products);
    sortProducts(sortOption, originalSort);
  }
}