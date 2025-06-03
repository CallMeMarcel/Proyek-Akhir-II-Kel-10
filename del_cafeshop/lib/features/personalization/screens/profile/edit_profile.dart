// lib/features/personalization/screens/profile/edit_profile.dart
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
import 'package:del_cafeshop/features/authentication/controllers/onboarding/profile_controller.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>(tag: 'profile');
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: controller.user.value?.name ?? '');
    final emailController = TextEditingController(text: controller.user.value?.email ?? '');
    final phoneController = TextEditingController(text: controller.user.value?.phone ?? '');
    final imageFile = Rxn<File>(); // State untuk file gambar yang dipilih

    return Scaffold(
      appBar: const TAppbar(
        showBackArrow: true,
        title: Text('Edit Profil'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.user.value == null) {
          return const Center(child: Text('Gagal memuat data pengguna'));
        }

        final user = controller.user.value!;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto Profil
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ClipOval(
                            child: Obx(() {
                              if (imageFile.value != null) {
                                return Image.file(
                                  imageFile.value!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                );
                              } else if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
                                return CachedNetworkImage(
                                  imageUrl: 'http://172.27.81.227:8000${user.imageUrl}',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Image.asset(
                                    TImages.user,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                              return Image.asset(
                                TImages.user,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        TextButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery, // Ganti ke ImageSource.camera untuk kamera
                              maxWidth: 800, // Batasi ukuran untuk efisiensi
                            );
                            if (pickedFile != null) {
                              imageFile.value = File(pickedFile.path);
                              await controller.uploadProfileImage(imageFile.value!);
                            }
                          },
                          child: const Text('Pilih Foto Profil'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Field Nama
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Field Email
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-mail tidak boleh kosong';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Format e-mail tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Field Nomor Telepon
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon tidak boleh kosong';
                      }
                      if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                        return 'Format nomor telepon tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            await controller.updateProfile(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              imageUrl: user.imageUrl,
                            );
                          } catch (e) {
                            Get.snackbar('Error', 'Gagal menyimpan perubahan: $e');
                          }
                        }
                      },
                      child: const Text('Simpan Perubahan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}