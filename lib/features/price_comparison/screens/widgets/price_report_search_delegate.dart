import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/features/price_comparison/screens/price_reports_detail_screen.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/price_report_card_wide.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class PriceReportSearchDelegate extends SearchDelegate {

  PriceReportSearchDelegate({
    super.searchFieldLabel, 
    super.searchFieldStyle, 
    super.searchFieldDecorationTheme, 
    super.keyboardType, 
    super.textInputAction, 
    super.autocorrect, 
    super.enableSuggestions, 
    required this.productId});
  
  final String productId;
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){query = '';}, 
        icon: Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){close(context, null);}, 
      icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    
    if (query.isEmpty) {
      return const Center(child: Text('Type something to search.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
        .collection('PriceReports')
        .where('ProductId', isEqualTo: productId)
        .where('StoreName', isGreaterThanOrEqualTo: query)
        .where('StoreName', isLessThanOrEqualTo: '${query}z')
        .orderBy('Confirmations', descending: true)
        .orderBy('Date', descending: true)
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        final List<PriceReportModel> priceReports = snapshot.data!.docs.map((doc) => PriceReportModel.fromQuerySnapshot(doc)).toList();

        return Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: ListView.separated(
            itemCount: priceReports.length,
            itemBuilder: (_, index) {
              return PriceReportCardWide(
                priceReport: priceReports[index],
                onTap: () => Get.to(() => PriceReportsDetailScreen(selectedPriceReport: priceReports[index]))
              );
            }, 
            separatorBuilder: (_, index) =>
              const SizedBox(height: Sizes.spaceBtwItems)
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type something to search.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
        .collection('PriceReports')
        .where('ProductId', isEqualTo: productId)
        .where('StoreName', isGreaterThanOrEqualTo: query)
        .where('StoreName', isLessThanOrEqualTo: '${query}z')
        .orderBy('Confirmations', descending: true)
        .orderBy('Date', descending: true)
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        final List<PriceReportModel> priceReports = snapshot.data!.docs.map((doc) => PriceReportModel.fromQuerySnapshot(doc)).toList();

        return Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: ListView.separated(
            itemCount: priceReports.length,
            itemBuilder: (_, index) {
              return PriceReportCardWide(
                priceReport: priceReports[index],
                onTap: () => Get.to(() => PriceReportsDetailScreen(selectedPriceReport: priceReports[index]))
              );
            }, 
            separatorBuilder: (_, index) =>
              const SizedBox(height: Sizes.spaceBtwItems)
          ),
        );
      },
    );
  }
}