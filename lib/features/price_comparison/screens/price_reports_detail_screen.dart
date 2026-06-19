import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/common/widgets/texts/clickable_section_heading.dart';
import 'package:grocer_ph/features/price_comparison/controllers/price_report_controller.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/detail_price_report_card.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/price_report_card_wide.dart';
import 'package:grocer_ph/features/products/screens/product_screen.dart';
import 'package:grocer_ph/features/stores/screens/store_screen.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/cloud_helper_functions.dart';
import 'package:grocer_ph/utils/loaders/shimmer_sizes.dart';

class PriceReportsDetailScreen extends StatelessWidget {
  const PriceReportsDetailScreen({
    super.key,
    required this.selectedPriceReport,
  });

  final PriceReportModel selectedPriceReport;

  @override
  Widget build(BuildContext context) {
    final controller = PriceReportController.instance;  

    return Scaffold(
      appBar: DefaultAppBar(
        title: Text(selectedPriceReport.productName),
        showBackArrow: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              /// -- Selected Price Report Card
              PriceReportCardWide(priceReport: selectedPriceReport),
              const SizedBox(height: Sizes.spaceBtwSections / 2),

              /// -- Product & Store Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: controller.getProduct(selectedPriceReport.productId), 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const OutlinedButtonShimmer();
                      }
                      final product = snapshot.data!;
                      return SizedBox(
                        width: 150,
                        child: OutlinedButton(
                          onPressed: () async => Get.to(() => ProductScreen(product: product)), 
                          child: Text('Go to product')
                        ),
                      );
                    }
                  ),
                  SizedBox(width: Sizes.spaceBtwItems),
                  FutureBuilder(
                    future: controller.getStore(selectedPriceReport.storeId), 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const OutlinedButtonShimmer();
                      }
                      final store = snapshot.data!;
                      return SizedBox(
                        width: 150,
                        child: OutlinedButton(
                          onPressed: () async => Get.to(() => StoreScreen(store: store)), 
                          child: Text('Go to store')
                        ),
                      );
                    }
                  ),
                ],
              ),
              
              const SizedBox(height: Sizes.spaceBtwSections / 2), 
              const Divider(),
              const SizedBox(height: Sizes.spaceBtwSections / 2),

              /// -- Other Price Reports for the same store
              ClickableSectionHeading(title: 'All Price Reports for this Store', showActionButton: false),
              const SizedBox(height: Sizes.spaceBtwItems),
              
              FutureBuilder(
                future: controller.getStoreProductPriceReports(selectedPriceReport.productId, selectedPriceReport.storeId),
                builder: (context, snapshot) {
                  const loader = PriceReportsDetailLoader();
                  final widget = CloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                  if (widget != null) return widget;

                  final allPriceReports = snapshot.data!;

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allPriceReports.length,
                    itemBuilder: (_, index) {
                      return PriceReportCardDetail(priceReport: allPriceReports[index]);
                    },
                    separatorBuilder: (_, index) =>
                        const SizedBox(height: Sizes.spaceBtwItems),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceReportsDetailLoader extends StatelessWidget {
  const PriceReportsDetailLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        return const PriceReportCardNarrowShimmer();
      },
      separatorBuilder: (_, index) =>
        const SizedBox(height: Sizes.spaceBtwItems),
    );
  }
}
