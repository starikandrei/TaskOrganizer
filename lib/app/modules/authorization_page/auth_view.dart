import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/generated/locales.g.dart';
import 'auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: LocaleKeys.email.tr,
                ),
                validator: (value) {
                  if (value != null &&
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return LocaleKeys.wrongEmail.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.password.tr,
                ),
                validator: (value) {
                  if (value != null && value.length < 6) {
                    return LocaleKeys.wrongPassword.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            controller.isLoading.value = true;
                            try {
                              controller.signIn();
                            } catch (e) {
                              Get.snackbar('Ошибка', e.toString(),
                                  snackPosition: SnackPosition.TOP);
                            } finally {
                              controller.isLoading.value = false;
                            }
                          }
                        },
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Get.theme.cardColor)
                      : Text(
                          LocaleKeys.signIn.tr,
                          style: Get.textTheme.bodyLarge,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            controller.isLoading.value = true;
                            try {
                              controller.signUp();
                            } catch (e) {
                              Get.snackbar(
                                LocaleKeys.fail.tr,
                                e.toString(),
                                snackPosition: SnackPosition.TOP,
                              );
                            } finally {
                              controller.isLoading.value = false;
                            }
                          }
                        },
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Get.theme.cardColor)
                      : Text(
                          LocaleKeys.signUp.tr,
                          style: Get.textTheme.bodyLarge,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
