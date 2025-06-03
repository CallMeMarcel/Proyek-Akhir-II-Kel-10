import 'package:del_cafeshop/data/services/category_services.dart';
import 'package:del_cafeshop/utils/helpers/icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:del_cafeshop/data/models/category.dart';
import 'package:iconsax/iconsax.dart';

class HomeCategory extends StatefulWidget {
  const HomeCategory({super.key});

  @override
  State<HomeCategory> createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> with TickerProviderStateMixin {
  late Future<List<Category>> futureCategories;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryService.fetchCategories();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoader(dark);
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString(), dark);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(dark);
          }

          final categories = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (_, index) {
              final category = categories[index];
              return _buildCategoryItem(category, index, dark);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(Category category, int index, bool dark) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () {
                // Handle category tap
                _animationController.forward().then((_) {
                  _animationController.reverse();
                });
              },
              child: Container(
                width: 80,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    // Icon Container with Gradient
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_animationController.value * 0.1),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: _getCategoryGradient(category.name, dark),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _getCategoryColor(category.name).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                                if (!dark)
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    blurRadius: 1,
                                    offset: const Offset(0, -1),
                                    spreadRadius: 0,
                                  ),
                              ],
                            ),
                            child: Icon(
                              _getIconSaxForCategory(category.name),
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Category Name
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: dark ? TColors.light : TColors.dark,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoader(bool dark) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      itemBuilder: (_, index) {
        return Container(
          width: 80,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: dark ? TColors.darkerGrey : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: dark ? TColors.darkerGrey : Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error, bool dark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 48,
            color: dark ? TColors.light.withOpacity(0.5) : TColors.dark.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Gagal memuat kategori',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: dark ? TColors.light.withOpacity(0.7) : TColors.dark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool dark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.category,
            size: 48,
            color: dark ? TColors.light.withOpacity(0.5) : TColors.dark.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada kategori',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: dark ? TColors.light.withOpacity(0.7) : TColors.dark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Get appropriate IconSax icon for category
  IconData _getIconSaxForCategory(String categoryName) {
    final name = categoryName.toLowerCase();
    
    if (name.contains('coffee') || name.contains('kopi')) {
      return Iconsax.coffee;
    } else if (name.contains('tea') || name.contains('minuman')) {
      return Iconsax.cup;
    } else if (name.contains('cake') || name.contains('kue')) {
      return Iconsax.cake;
    } else if (name.contains('snack') || name.contains('gorengan')) {
      return Iconsax.note;
    } else if (name.contains('juice') || name.contains('jus')) {
      return Iconsax.glass_1;
    } else if (name.contains('ice') || name.contains('es')) {
      return Iconsax.drop;
    } else if (name.contains('food') || name.contains('makanan')) {
      return Iconsax.like;
    } else if (name.contains('dessert') || name.contains('desert')) {
      return Iconsax.wind;
    } else if (name.contains('hot') || name.contains('panas')) {
      return Iconsax.flash_circle;
    } else if (name.contains('cold') || name.contains('dingin')) {
      return Iconsax.bubble;
    } else {
      return Iconsax.category_2;
    }
  }

  // Get gradient colors for categories
  LinearGradient _getCategoryGradient(String categoryName, bool dark) {
    final color = _getCategoryColor(categoryName);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color,
        color.withOpacity(0.8),
      ],
    );
  }

  // Get primary color for category
  Color _getCategoryColor(String categoryName) {
    final name = categoryName.toLowerCase();
    
    if (name.contains('coffee') || name.contains('kopi')) {
      return const Color(0xFF8B4513);
    } else if (name.contains('tea') || name.contains('minuman')) {
      return const Color(0xFF228B22);
    } else if (name.contains('cake') || name.contains('kue')) {
      return const Color(0xFFFF69B4);
    } else if (name.contains('snack') || name.contains('gorengan')) {
      return const Color.fromARGB(255, 255, 76, 44);
    } else if (name.contains('juice') || name.contains('jus')) {
      return const Color(0xFFFF6347);
    } else if (name.contains('ice') || name.contains('es')) {
      return const Color(0xFF00CED1);
    } else if (name.contains('food') || name.contains('makanan')) {
      return const Color(0xFF32CD32);
    } else if (name.contains('dessert') || name.contains('penutup')) {
      return const Color(0xFFFF1493);
    } else if (name.contains('hot') || name.contains('panas')) {
      return const Color(0xFFFF4500);
    } else if (name.contains('cold') || name.contains('dingin')) {
      return const Color(0xFF4169E1);
    } else {
      return const Color(0xFF6A5ACD);
    }
  }
}