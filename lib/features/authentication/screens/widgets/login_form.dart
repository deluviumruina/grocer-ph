import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/authentication/controllers/login_controller.dart';
import 'package:grocer_ph/features/authentication/screens/signup_screen.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.spaceBtwSections,
        ),
        child: Column(
          children: [
            
            /// -- Email
            TextFormField(
              controller: controller.email,
              validator: (value) => Validator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
    
            /// -- Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => Validator.validateEmptyText('Password', value),
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
    
            /// -- Remember Me and Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [

                    /// -- Remember Me
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value, 
                        onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value
                      ),
                    ),
                    const Text('Remember Me'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,

              /// -- Sign In Button
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),

            SizedBox(
              width: double.infinity,

              /// -- Create Account Button
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text('Create Account'),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}