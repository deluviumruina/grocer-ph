import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/containers/app_bar.dart';
import 'package:grocer_ph/features/profiles/controllers/user_controller.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class ReAuthForm extends StatelessWidget {
  const ReAuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: DefaultAppBar(showBackArrow: true, title: Text('Verify Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// -- Email
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: Validator.validateEmail,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right), 
                    labelText: 'Email'
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),

                /// -- Password
                Obx(
                  () => TextFormField(
                    obscureText: controller.hidePassword.value,
                    controller: controller.verifyPassword,
                    validator: (value) => Validator.validateEmptyText('Password', value),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value, 
                        icon: const Icon(Iconsax.eye_slash)
                      )
                    ),
                  )
                ),
                const SizedBox(height: Sizes.spaceBtwSections),

                /// -- ReAuth Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.deleteUser(), 
                    child: const Text('Verify')
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}