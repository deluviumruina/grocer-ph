import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/common/widgets/containers/search_container.dart';
import 'package:grocer_ph/data/repositories/price_report_repository.dart';
import 'package:grocer_ph/features/price_comparison/controllers/price_report_controller.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/features/price_comparison/screens/price_reports_detail_screen.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/price_report_card_wide.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/price_report_search_delegate.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer_sizes.dart';
import 'package:iconsax/iconsax.dart';

class AllPriceReportsScreen extends StatefulWidget {
  const AllPriceReportsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<AllPriceReportsScreen> createState() => _AllPriceReportsScreenState();
}

class _AllPriceReportsScreenState extends State<AllPriceReportsScreen> {
  final ScrollController scrollController = ScrollController();
  final controller = PriceReportController.instance;
  List<PriceReportModel> priceReports = [];
  List<PriceReportModel> sortablePriceReports = [];
  int limit = 5;
  bool _isLoadingFirst = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    getFirst();
    scrollController.addListener(_scrollListener);
  }

  Future<void> getFirst() async {
    setState(() => _isLoadingFirst = true);

    QuerySnapshot query = await PriceReportRepository.instance.getFirstAllProductPriceReports(widget.product.id, limit);

    if(query.docs.isNotEmpty) {
      _lastDocument = query.docs.last;
      priceReports.addAll(query.docs.map((snapshot) => PriceReportModel.fromQuerySnapshot(snapshot)).toList());
      sortablePriceReports.addAll(priceReports);

      if (query.docs.length <= limit - 1) {
        _hasMoreData = false;
      }
    } else {
      _hasMoreData = false;
    }

    setState(() => _isLoadingFirst = false);
  }

  Future<void> getMore() async {
    if (_isLoadingFirst || _isLoadingMore || !_hasMoreData) return;

    setState(() => _isLoadingMore = true);

    QuerySnapshot query = await PriceReportRepository.instance.getMoreAllProductPriceReports(widget.product.id, _lastDocument!, limit);
    
    if (query.docs.isNotEmpty) {
      _lastDocument = query.docs.last;
      priceReports.addAll(query.docs.map((snapshot) => PriceReportModel.fromQuerySnapshot(snapshot)).toList());
      sortablePriceReports.addAll(priceReports);
    } else {
      _hasMoreData = false;
    }

    setState(() => _isLoadingMore = false);
  }

  void _scrollListener() {
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      getMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.assignPriceReports(sortablePriceReports, controller.selectedSortOption.value, priceReports);

    return Scaffold(
      appBar: DefaultAppBar(title: Text('All Price Reports'), showBackArrow: true),
      
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [

            /// -- Search
            Padding(
              padding: const EdgeInsets.only(top: Sizes.defaultSpace),
              child: SearchContainer(
                text: 'Search by store',
                onTap: () {
                  showSearch(
                    context: context, 
                    delegate: PriceReportSearchDelegate(productId: widget.product.id)
                  );
                },
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections / 4),

            Padding(
                padding: EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  children: [
                    
                    /// -- Dropdown Sorting Menu
                    DropdownButtonFormField(
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                      initialValue: controller.selectedSortOption.value,
                      onChanged: (value) {
                        controller.sortProducts(value!, priceReports);
                      },
                      items: ['Confirmations', 'Newest', 'Oldest', 'Lowest Price', 'Highest Price']
                        .map(
                          (option) =>
                            DropdownMenuItem(value: option, child: Text(option)),
                        )
                        .toList(),
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),

                    /// -- Price Reports
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.priceReports.length + (_hasMoreData ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (_isLoadingFirst) {
                          return AllPriceReportsLoader(itemCount: limit);
                        } else if (index == controller.priceReports.length) {
                          return const PriceReportCardWideShimmer();
                        }
                                
                        return Obx(
                          () => PriceReportCardWide(
                            priceReport: controller.priceReports[index],
                            onTap: () => Get.to(() => PriceReportsDetailScreen(selectedPriceReport: controller.priceReports[index]))
                          ),
                        );
                      }, 
                      separatorBuilder: (_, index) => 
                        const SizedBox(height: Sizes.spaceBtwItems)
                    ),
                  ],
                )
              ),
          ],
        ),
      ),
    );
  }
}

class AllPriceReportsLoader extends StatelessWidget {
  const AllPriceReportsLoader({
    super.key,
    required this.itemCount
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (_, index) =>
        const PriceReportCardWideShimmer(),
      separatorBuilder: (_, index) => 
        const SizedBox(height: Sizes.spaceBtwItems),
      );
  }
}
