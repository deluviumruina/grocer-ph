import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/common/widgets/containers/rounded_container.dart';
import 'package:grocer_ph/features/products/controllers/product_category_controller.dart';
import 'package:grocer_ph/features/products/controllers/product_controller.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/cloud_helper_functions.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';
import 'package:grocer_ph/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final categoryController = ProductCategoryController.instance;

    return Scaffold(
      appBar: DefaultAppBar(showBackArrow: true, title: Text('Add a Product')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Form(
            key: controller.productFormKey,
            child: Column(
              children: [

                /// -- Product Name
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.bag),
                    labelText: 'Product Name',
                  ),
                  validator: (value) =>
                      Validator.validateEmptyText('Product Name', value),
                  onSaved: (value) {
                    controller.name = value;
                  },
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),

                /// -- Category
                FutureBuilder(
                  future: categoryController.getProductCategoriesMethod(),
                  builder: (context, snapshot) {
                    const loader = Column(
                      children: [
                        ShimmerLoader(width: 360, height: 40, radius: 10),
                        SizedBox(height: Sizes.spaceBtwInputFields),
                      ],
                    );

                    final widget = CloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot,
                      loader: loader,
                    );
                    if (widget != null) return widget;

                    return DropdownButtonFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.category),
                        labelText: 'Category',
                      ),
                      items: snapshot.data!
                          .map(
                            (category) => DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      initialValue: controller.categoryId,
                      onChanged: (String? newValue) {
                        setState(() {
                          controller.categoryId = newValue;
                        });
                      },
                      onSaved: (value) {
                        controller.categoryId = value;
                      },
                      validator: (value) =>
                          Validator.validateEmptyText('Category', value),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),

                /// -- Product Description
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Product Description (optional)',
                    alignLabelWithHint: true,
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: null,
                  onSaved: (value) {
                    controller.description = value ?? '';
                  },
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),

                /// -- Product Image
                SizedBox(
                  width: double.infinity,
                  child: RoundedContainer(
                    showBorder: true,
                    borderColor: AppColors.darkGrey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 3.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Product Image (optional)',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final image = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (image != null) {
                                    controller.image = File(image.path);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(1),
                                  fixedSize: const Size(35, 30),
                                ),
                                child: Text(
                                  'Upload',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Sizes.spaceBtwInputFields),

                          Center(
                            child: SizedBox(
                              height: 150,
                              width: 300,
                              child: Center(
                                child: controller.image == null
                                    ? Text('No image selected')
                                    : Image.file(controller.image!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),

                /// -- Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.addProduct(),
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
