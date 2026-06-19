import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/success_screen.dart';
import 'package:grocer_ph/data/repositories/store_repository.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';
import 'package:grocer_ph/navigation_menu.dart';
import 'package:grocer_ph/utils/constants/images.dart';
import 'package:grocer_ph/utils/loaders/loader_fullscreen.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';
import 'package:grocer_ph/utils/network_manager.dart';

class StoreController extends GetxController {
  static StoreController get instance => Get.find();

  final _storeRepository = Get.put(StoreRepository());
  final RxList<StoreModel> allStores = <StoreModel>[].obs;
  RxBool isLoading = true.obs;

  String? name;
  String? categoryId;
  String? location;
  File? image;
  String? downloadUrl;
  GlobalKey<FormState> storeFormKey = GlobalKey<FormState>();

  /*   -------------- [FORMATTING] Default Values -------------- */
  String formatImage(StoreModel store) {
    String imageUrl;

    if (store.image!.isEmpty || store.image == null) {
      imageUrl = 'https://firebasestorage.googleapis.com/v0/b/sp-grocerph.firebasestorage.app/o/placeholder-image.png?alt=media&token=0c360493-c3da-4609-971c-253f713f5c8f';
    } else {
      imageUrl = store.image!;
    }

    return imageUrl;
  }

  /*   -------------- [FORMATTING] Quantities -------------- */
  String formatPriceReportNumber(StoreModel store) {
    String priceReportNumber;

    if (store.priceReports == 1) {
      priceReportNumber = '1 price report';
    } else {
      priceReportNumber = '${store.priceReports.toString()} reports';
    }

    return priceReportNumber;
  }

  // # -------------- [GET] -------------- # 
  /// -- Get ALL stores
  Future<List<StoreModel>> getAllStores() async {
    try {
      final stores = await _storeRepository.getAllStores();
      return stores;
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());
      return [];
    }
  }

  /// -- Get Store PRODUCT IDs
  Future<List<String>> getStoreProductIds(String storeId) async {
    try {
      final ids = await _storeRepository.getStoreProductIds(storeId);
      return ids;
    } catch (e) {
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());
      return [];
    }
  }

  // # -------------- [POST] -------------- # 
  Future addStore() async {
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
      if (!storeFormKey.currentState!.validate()) {
        FullscreenLoader.stopLoading();
        return;
      }

      if (image != null) {
        var imageName = DateTime.now().millisecondsSinceEpoch.toString();
        var storageRef = FirebaseStorage.instance.ref().child('stores/$imageName.jpg');

        var uploadTask = storageRef.putFile(image!);
        downloadUrl = await (await uploadTask).ref.getDownloadURL();
      } else {
        downloadUrl = '';
      }

      storeFormKey.currentState!.save();

      /// -- Save Price Report Data
      final store = StoreModel(
        id: '', 
        name: name!.trim(),
        categoryId: categoryId!.trim(),
        location: location!.trim(),
        image: downloadUrl.toString(),
        lastUpdated: DateTime.now(),
        priceReports: 0
      );
      await _storeRepository.addStore(store);

      /// -- Stop Loading
      FullscreenLoader.stopLoading();

      /// -- Redirect to Success Screen
      Get.off(
        () => SuccessScreen(
          image: Images.successAnimation, 
          title: 'Your store has been added to the database.', 
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
  Future updateStore(StoreModel store) async {
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
      if (!storeFormKey.currentState!.validate()) {
        FullscreenLoader.stopLoading();
        return;
      }

      if (image != null) {
        var imageName = DateTime.now().millisecondsSinceEpoch.toString();
        var storageRef = FirebaseStorage.instance.ref().child('stores/$imageName.jpg');

        var uploadTask = storageRef.putFile(image!);
        downloadUrl = await (await uploadTask).ref.getDownloadURL();
      } else {
        downloadUrl = '';
      }

      storeFormKey.currentState!.save();

      if (name!.trim() != store.name) {
        updates['Name'] = name!.trim();
      }

      if (location!.trim() != store.location) {
        updates['Location'] = location!.trim();
      }

      if (downloadUrl!.isNotEmpty && downloadUrl.toString() != store.image) {
        updates['Image'] = downloadUrl.toString();
      }

      if (updates.isNotEmpty) {
        updates['LastUpdated'] = DateTime.now();
        await _storeRepository.updateStore(store.id, updates);
      }

      /// -- Stop Loading
      FullscreenLoader.stopLoading();

      /// -- Redirect to Success Screen
      Get.off(
        () => SuccessScreen(
          image: Images.successAnimation, 
          title: 'Your store has been updated.', 
          subTitle: 'Thank you for your contribution.', 
          onPressed: () => Get.offAll(() => const NavigationMenu()),
        )
      );
    } catch (e) {
      FullscreenLoader.stopLoading();
      AppSnackBars.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}