import 'package:cached_network_image/cached_network_image.dart';
import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
import 'package:del_cafeshop/common/widgets/images/circular_image.dart';
import 'package:del_cafeshop/common/widgets/texts/section_heading.dart';
import 'package:del_cafeshop/features/authentication/controllers/onboarding/profile_controller.dart';
import 'package:del_cafeshop/features/personalization/screens/profile/edit_profile.dart';
import 'package:del_cafeshop/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:del_cafeshop/features/personalization/screens/settings/settings.dart';
import 'package:del_cafeshop/utils/constants/api_constants.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final formatter = DateFormat('dd MMMM yyyy');
      return formatter.format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController(), tag: 'profile');

    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final prefs = snapshot.data as SharedPreferences;
        final token = prefs.getString('auth_token');
        if (token == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/login');
          });
          return const Center(child: Text('Mengalihkan ke login...'));
        }

        return Scaffold(
          appBar: const TAppbar(
            showBackArrow: true,
            title: Text('Profil'),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.user.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Gagal memuat profil'),
                    TextButton(
                      onPressed: () => controller.fetchUserProfile(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            final user = controller.user.value!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: ClipOval(
                              child: user.imageUrl != null && user.imageUrl!.isNotEmpty
                                  ? CachedNetworkImage(
                                      key: ValueKey(user.imageUrl),
                                      imageUrl: '${APIConstants.baseUrl}${user.imageUrl}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const CircularImages(
                                        image: TImages.user,
                                        width: 80,
                                        height: 80,
                                      ),
                                    )
                                  : const CircularImages(
                                      image: TImages.user,
                                      width: 80,
                                      height: 80,
                                    ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.to(() => const EditProfileScreen()),
                            child: const Text('Edit Profil'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const SectionHeading(
                      title: 'Informasi Profil',
                      showActionButton: false,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    ProfileMenu(
                      onPressed: () {},
                      title: 'Nama',
                      value: user.name,
                    ),
                    ProfileMenu(
                      onPressed: () {},
                      title: 'ID Pengguna',
                      value: user.id.toString(),
                    ),
                    ProfileMenu(
                      onPressed: () {},
                      title: 'E-mail',
                      value: user.email,
                    ),
                    ProfileMenu(
                      onPressed: () {},
                      title: 'Nomor Telepon',
                      value: user.phone,
                    ),
                    ProfileMenu(
                      onPressed: () {},
                      title: 'Dibuat Pada',
                      value: formatDate(user.createdAt),
                    ),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.to(() => const SettingScreen()),
                        child: const Text(
                          'Tutup Akun',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}