import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocer_ph/common/widgets/containers/app_bar.dart';
import 'package:grocer_ph/features/price_comparison/controllers/price_report_controller.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/features/products/screens/widgets/product_card_horizontal.dart';
import 'package:grocer_ph/features/stores/controllers/store_controller.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/cloud_helper_functions.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';
import 'package:grocer_ph/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class AddPriceReportScreen extends StatefulWidget {
  const AddPriceReportScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<AddPriceReportScreen> createState() => _AddPriceReportScreenState();
}

class _AddPriceReportScreenState extends State<AddPriceReportScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = PriceReportController.instance;
    final storeController = StoreController.instance;

    return Scaffold(
      appBar: DefaultAppBar(showBackArrow: true, title: Text('Add Price Report')),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              ProductCardHorizontal(product: widget.product),

              const SizedBox(height: Sizes.spaceBtwSections),

              Form(
                key: controller.priceReportFormKey,
                child: Column(
                  children: [

                    /// -- Product Name
                    TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.bag),
                        labelText: 'Product ID',
                      ),
                      initialValue: widget.product.id,
                      onSaved: (value) {controller.productId = value;},
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),

                    /// -- Store Name
                    FutureBuilder(
                      future: storeController.getAllStores(),
                      builder: (context, snapshot) {
                        const loader = Column(
                          children: [
                            ShimmerLoader(width: 360, height: 40, radius: 10),
                            SizedBox(height: Sizes.spaceBtwInputFields),
                          ],
                        );

                        final widget =
                            CloudHelperFunctions.checkMultiRecordState(
                              snapshot: snapshot,
                              loader: loader,
                            );
                        if (widget != null) return widget;

                        return DropdownButtonFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.shop),
                            labelText: 'Store',
                          ),
                          items: snapshot.data!
                              .map(
                                (store) => DropdownMenuItem(
                                  value: store.id,
                                  child: Text(store.name),
                                ),
                              )
                              .toList(),
                          initialValue: controller.storeId,
                          onChanged: (String? newValue) {
                            setState(() {
                              controller.storeId = newValue;
                            });
                          },
                          onSaved: (value) {controller.storeId = value;},
                          validator: (value) => Validator.validateEmptyText('Store', value),
                        );
                      },
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),

                    /// -- Price
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.dollar_square),
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                      validator: Validator.validatePriceReport,
                      onSaved: (value) {controller.price = value;},
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),

                    /// -- Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.addPriceReport(),
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
