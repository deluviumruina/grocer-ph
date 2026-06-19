import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/data/repositories/price_report_repository.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/features/price_comparison/screens/price_reports_detail_screen.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/narrow_price_report_card.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer_sizes.dart';

class MyPriceReportsScreen extends StatefulWidget {
  const MyPriceReportsScreen({super.key});

  @override
  State<MyPriceReportsScreen> createState() => _MyPriceReportsScreenState();
}

class _MyPriceReportsScreenState extends State<MyPriceReportsScreen> {
  final ScrollController scrollController = ScrollController();
  List<PriceReportModel> priceReports = [];
  int limit = 8;
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

    QuerySnapshot query = await PriceReportRepository.instance.getFirstCurrentUserPriceReports(limit);

    if(query.docs.isNotEmpty) {
      _lastDocument = query.docs.last;
      priceReports.addAll(query.docs.map((snapshot) => PriceReportModel.fromQuerySnapshot(snapshot)).toList());

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

    QuerySnapshot query = await PriceReportRepository.instance.getMoreCurrentUserPriceReports(_lastDocument!, limit);
    
    if (query.docs.isNotEmpty) {
      _lastDocument = query.docs.last;
      priceReports.addAll(query.docs.map((snapshot) => PriceReportModel.fromQuerySnapshot(snapshot)).toList());
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
    return Scaffold(
      appBar: DefaultAppBar(
        showBackArrow: true,
        title: Text(
          'My Price Reports',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(Sizes.defaultSpace),
        child: ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: priceReports.length + (_hasMoreData ? 1 : 0),
          itemBuilder: (_, index) {
            if (_isLoadingFirst) {
              return MyPriceReportsLoader(itemCount: limit);
            } else if (index == priceReports.length) {
              return const PriceReportCardNarrowShimmer();
            }

            return NarrowPriceReportCard(
              priceReport: priceReports[index],
              onTap: () => Get.to(() => PriceReportsDetailScreen(selectedPriceReport: priceReports[index]))
            );
          },
          separatorBuilder: (_, index) =>
            Column(children: [
              const SizedBox(height: Sizes.spaceBtwItems / 2),
              Divider(),
              const SizedBox(height: Sizes.spaceBtwItems / 2)
            ],),
        )
      ),
    );
  }
}

class MyPriceReportsLoader extends StatelessWidget {
  const MyPriceReportsLoader({
    super.key, required this.itemCount,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (_, index) {
        return const PriceReportCardNarrowShimmer();
      },
      separatorBuilder: (_, index) => Column(children: [
        const SizedBox(height: Sizes.spaceBtwItems / 2),
        Divider(),
        const SizedBox(height: Sizes.spaceBtwItems /2)
      ])
    );
  }
}
