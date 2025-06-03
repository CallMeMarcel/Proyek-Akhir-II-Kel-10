import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
import 'package:del_cafeshop/common/widgets/custom_shapes/containers/primary_header_controller.dart';
import 'package:del_cafeshop/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:del_cafeshop/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:del_cafeshop/common/widgets/texts/section_heading.dart';
import 'package:del_cafeshop/features/authentication/controllers/onboarding/profile_controller.dart';
import 'package:del_cafeshop/features/authentication/screens/login/login.dart';
import 'package:del_cafeshop/features/personalization/screens/profile/profile.dart';
import 'package:del_cafeshop/features/shop/screens/cart/cart.dart';
import 'package:del_cafeshop/features/shop/screens/order/order.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _bodyAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late List<Animation<double>> _menuItemAnimations;

  bool _safeMode = false;
  bool _hdImageQuality = true;

  @override
  void initState() {
    super.initState();

    // Initialize ProfileController
    Get.put(ProfileController(), tag: 'profile');

    // Header animations
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.elasticOut,
    ));

    // Body animations
    _bodyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for menu items
    _menuItemAnimations = List.generate(
      8,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _bodyAnimationController,
        curve: Interval(
          (index * 0.08).clamp(0.0, 1.0),
          (0.4 + (index * 0.05)).clamp(0.0, 1.0),
          curve: Curves.easeOutBack,
        ),
      )),
    );

    // Start animations
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _bodyAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _bodyAnimationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedMenuItem({
    required int index,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _menuItemAnimations[index],
      builder: (context, _) {
        final opacityValue = _menuItemAnimations[index].value.clamp(0.0, 1.0);
        final translateValue = (50 * (1 - _menuItemAnimations[index].value)).clamp(-50.0, 50.0);

        return Transform.translate(
          offset: Offset(translateValue, 0),
          child: Opacity(
            opacity: opacityValue,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SlideTransition(
              position: _headerSlideAnimation,
              child: FadeTransition(
                opacity: _headerFadeAnimation,
                child: PrimaryHeaderController(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              TColors.primary.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: TAppbar(
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: TColors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Iconsax.setting_2,
                                  color: TColors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Settings',
                                style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: UserProfileTile(
                          onPressed: () => Get.to(() => const ProfileScreen()),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  _buildAnimatedMenuItem(
                    index: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            TColors.primary.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: TColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Iconsax.user_octagon,
                              color: TColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const SectionHeading(
                            title: 'Account Settings',
                            showActionButton: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _buildAnimatedMenuItem(
                    index: 1,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SettingsMenuTile(
                        icon: Iconsax.shopping_cart,
                        title: 'My Cart',
                        subTitle: 'Add, remove products and move to checkout',
                        onTap: () => Get.to(() => CartScreen()),
                      ),
                    ),
                  ),
                  _buildAnimatedMenuItem(
                    index: 2,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SettingsMenuTile(
                        icon: Iconsax.bag_tick,
                        title: 'My Orders',
                        subTitle: 'In Progress and Completed Orders',
                        onTap: () => Get.to(() => const OrderScreen()),
                      ),
                    ),
                  ),
                  _buildAnimatedMenuItem(
                    index: 3,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const SettingsMenuTile(
                        icon: Iconsax.notification_bing,
                        title: 'Notifications',
                        subTitle: 'Set any kind to notification message',
                      ),
                    ),
                  ),
                  _buildAnimatedMenuItem(
                    index: 4,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const SettingsMenuTile(
                        icon: Iconsax.shield_security,
                        title: 'Account Privacy',
                        subTitle: 'Manage data usage and connected accounts',
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  _buildAnimatedMenuItem(
                    index: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Iconsax.setting_3,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const SectionHeading(
                            title: 'App Settings',
                            showActionButton: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _buildAnimatedMenuItem(
                    index: 6,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SettingsMenuTile(
                        icon: Iconsax.shield_tick,
                        title: 'Safe Mode',
                        subTitle: 'Search Result is safe for all pages',
                        trailing: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Switch(
                            value: _safeMode,
                            onChanged: (value) {
                              setState(() {
                                _safeMode = value;
                              });
                            },
                            activeColor: TColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildAnimatedMenuItem(
                    index: 7,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SettingsMenuTile(
                        icon: Iconsax.gallery,
                        title: 'HD Image Quality',
                        subTitle: 'Set Image quality to be seen',
                        trailing: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Switch(
                            value: _hdImageQuality,
                            onChanged: (value) {
                              setState(() {
                                _hdImageQuality = value;
                              });
                            },
                            activeColor: TColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  AnimatedBuilder(
                    animation: _bodyAnimationController,
                    builder: (context, child) {
                      final scaleValue = _bodyAnimationController.value.clamp(0.0, 1.0);
                      return Transform.scale(
                        scale: scaleValue,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.withOpacity(0.1),
                                Colors.red.withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: OutlinedButton.icon(
                            onPressed: () => Get.to(() => const LoginScreen()),
                            icon: const Icon(
                              Iconsax.logout,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.red.withOpacity(0.3)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}