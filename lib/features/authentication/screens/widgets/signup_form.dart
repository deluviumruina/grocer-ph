import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/authentication/controllers/signup_controller.dart';
import 'package:grocer_ph/features/authentication/screens/widgets/informed_consent_page.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';
import 'package:grocer_ph/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
    
          /// -- Username
          TextFormField(
            controller: controller.username,
            validator: (value) => Validator.validateEmptyText('Username', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          /// -- Email
          TextFormField(
            controller: controller.email,
            validator: (value) => Validator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),
    
          /// -- Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => Validator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value 
                    ? Iconsax.eye_slash
                    : Iconsax.eye
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwSections),
    
          /// -- Terms&Conditions Checkbox
          DataConsentCheckbox(),
          const SizedBox(height: Sizes.spaceBtwSections),
    
          /// -- Signup Button
          SizedBox(
            width: double.infinity, 
            child: ElevatedButton(
              onPressed: () => controller.signup(), 
              child: const Text('Create Account')
            )
          ),
        ],
      ),
    );
  }
}

class DataConsentCheckbox extends StatelessWidget {
  const DataConsentCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() => Checkbox(
            value: controller.dataConsent.value,
            onChanged: (value) => controller.dataConsent.value = !controller.dataConsent.value
          )),
        ),
        const SizedBox(width: Sizes.spaceBtwItems),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'I have read and understood the ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() => const InformedConsentForm()),
                  text: 'informed consent form',
                  style: Theme.of(context).textTheme.bodyMedium!
                      .apply(
                        color: dark
                            ? Colors.white
                            : AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: dark
                            ? Colors.white
                            : AppColors.primary,
                      ),
                ),
                TextSpan(
                  text: ' and I formally consent to participate in this study.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
