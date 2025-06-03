import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TAppbar({
  super.key, 
  this.title,  
  this.leadingIcon,  
  this.actions, 
  this.leadingOnPreesed,
  this.showBackArrow = false,

});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPreesed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md), 
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
        ? IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left)) 
        : leadingIcon != null ? IconButton(onPressed: leadingOnPreesed, icon:  Icon(leadingIcon)) : null,
      title: title,
      actions: actions,

      ),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
  
}