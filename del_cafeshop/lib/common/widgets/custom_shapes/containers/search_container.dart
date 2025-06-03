import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/device/device_utility.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchContainer extends StatefulWidget {
  final String text;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool showBorder;
  final double? maxWidth;
  final bool showFilter;
  final VoidCallback? onFilterTap;
  final String? filterText;

  const SearchContainer({
    super.key,
    required this.text,
    this.controller,
    this.onTap,
    this.showBorder = true,
    this.maxWidth,
    this.showFilter = false,
    this.onFilterTap,
    this.filterText,
  });

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
    
    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth ?? TDeviceUtils.getScreenWidth(context) * 0.85,
        minWidth: 200,
      ),
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  boxShadow: [
                    // Main shadow
                    BoxShadow(
                      color: isDark 
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.15),
                      spreadRadius: _isFocused ? 2 : 1,
                      blurRadius: _isFocused ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                    // Glow effect when focused
                    if (_isFocused)
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2 * _glowAnimation.value),
                        spreadRadius: 4,
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                  ],
                ),
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.md, 
                      vertical: TSizes.sm
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                          ? [
                              Colors.grey[850]!,
                              Colors.grey[900]!,
                            ]
                          : [
                              Colors.white,
                              Colors.grey[50]!,
                            ],
                      ),
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                      border: Border.all(
                        color: _isFocused
                          ? Colors.blue.withOpacity(0.5)
                          : widget.showBorder
                            ? isDark 
                              ? Colors.grey[700]!.withOpacity(0.5)
                              : Colors.grey[300]!.withOpacity(0.7)
                            : Colors.transparent,
                        width: _isFocused ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Search Icon with Animation
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _isFocused || _isHovered
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Iconsax.search_normal_1,
                            color: _isFocused
                              ? Colors.blue
                              : isDark 
                                ? Colors.grey[400] 
                                : Colors.grey[600],
                            size: TSizes.iconMd,
                          ),
                        ),
                        
                        const SizedBox(width: TSizes.sm),
                        
                        // TextField
                        Expanded(
                          child: Focus(
                            onFocusChange: _handleFocusChange,
                            child: TextField(
                              controller: widget.controller,
                              enabled: widget.onTap == null,
                              decoration: InputDecoration(
                                hintText: widget.text,
                                hintStyle: TextStyle(
                                  color: isDark 
                                    ? Colors.grey[500] 
                                    : Colors.grey[500],
                                  fontSize: TSizes.fontSizeMd,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: TSizes.sm,
                                ),
                              ),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: TSizes.fontSizeMd,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        
                        // Filter Button (Optional)
                        if (widget.showFilter) ...[
                          const SizedBox(width: TSizes.sm),
                          GestureDetector(
                            onTap: widget.onFilterTap,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.withOpacity(0.1),
                                    Colors.purple.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.filter,
                                    color: Colors.blue,
                                    size: TSizes.iconSm,
                                  ),
                                  if (widget.filterText != null) ...[
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.filterText!,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: TSizes.xs,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                        
                        // Voice Search (Optional)
                        const SizedBox(width: TSizes.xs),
                        GestureDetector(
                          onTap: () {
                            // Handle voice search
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _isHovered
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            // child: Icon(
                            //   Iconsax.microphone,
                            //   color: _isHovered
                            //     ? Colors.orange
                            //     : isDark 
                            //       ? Colors.grey[500] 
                            //       : Colors.grey[600],
                            //   size: TSizes.iconSm,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}