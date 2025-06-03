import 'package:cached_network_image/cached_network_image.dart';
import 'package:del_cafeshop/common/widgets/images/circular_image.dart';
import 'package:del_cafeshop/features/authentication/controllers/onboarding/profile_controller.dart';
import 'package:del_cafeshop/features/personalization/screens/profile/profile.dart';
import 'package:del_cafeshop/utils/constants/api_constants.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>(tag: 'profile');

    return Obx(() {
      final user = controller.user.value;
      return ListTile(
        onTap: onPressed,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
          ),
          child: ClipOval(
            child: user != null && user.imageUrl != null && user.imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    key: ValueKey(user.imageUrl),
                    imageUrl: '${APIConstants.baseUrl}${user.imageUrl}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircularImages(
                      image: TImages.user,
                      width: 50,
                      height: 50,
                      padding: 0,
                    ),
                  )
                : const CircularImages(
                    image: TImages.user,
                    width: 50,
                    height: 50,
                    padding: 0,
                  ),
          ),
        ),
        title: Text(
          user?.name ?? 'Pengguna',
          style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),
        ),
        subtitle: Text(
          user?.email ?? 'Email belum diatur',
          style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),
        ),
        trailing: IconButton(
          onPressed: () => Get.to(() => const ProfileScreen()),
          icon: const Icon(Iconsax.edit, color: TColors.white),
        ),
      );
    });
  }
}