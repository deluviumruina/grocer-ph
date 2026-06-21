import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/containers/app_bar.dart';
import 'package:grocer_ph/common/widgets/containers/large_header_container.dart';
import 'package:grocer_ph/common/widgets/texts/clickable_section_heading.dart';
import 'package:grocer_ph/features/profiles/controllers/user_controller.dart';
import 'package:grocer_ph/features/profiles/screens/widgets/profile_row.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// -- Header
            LargeHeaderContainer(
              child: Column(
                children: [

                  /// -- App Bar
                  DefaultAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: Colors.white),
                    ),

                    /// -- Logout Button
                    actions: [
                      IconButton(
                        icon: Icon(Iconsax.logout, color: Colors.white),
                        onPressed: controller.logoutUser,
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                ],
              ),
            ),

            /// -- Body
            Padding(
              padding: EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [

                        /// -- Username
                        Text(
                          controller.user.value.username,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: Sizes.spaceBtwItems / 4),

                        /// -- Price Reports & Account Reputation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.formatPriceReportNumber(controller.user.value)),
                            SizedBox(width: Sizes.spaceBtwItems),
                            Text('${controller.user.value.reputation} reputation'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  const Divider(),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  /// -- Account Details
                  const ClickableSectionHeading(
                    title: 'Account Information',
                    showActionButton: false,
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),

                  /// -- User ID
                  GProfileRow(
                    title: 'User ID',
                    value: controller.user.value.id,
                    onPressed: () {},
                  ),

                  /// -- Email
                  GProfileRow(
                    title: 'Email',
                    value: controller.user.value.email,
                    showIcon: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
