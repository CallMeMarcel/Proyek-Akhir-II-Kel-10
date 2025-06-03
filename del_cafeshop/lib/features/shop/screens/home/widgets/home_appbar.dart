import 'dart:async';

import 'package:del_cafeshop/common/widgets/appbar/appbar.dart';
import 'package:del_cafeshop/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:del_cafeshop/utils/constants/colors.dart';
import 'package:del_cafeshop/utils/constants/text_strings.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> 
    with TickerProviderStateMixin {
  String? username;
  late AnimationController _waveController;
  late AnimationController _greetingController;
  late AnimationController _sparkleController;
  late Animation<double> _waveAnimation;
  late Animation<double> _greetingAnimation;
  late Animation<double> _sparkleAnimation;

  // Daftar emoticon untuk variasi
  final List<String> _greetingEmojis = ['👋', '😊', '🤗', '😄', '🌟'];
  String _currentEmoji = '👋';

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadUsername();
    _startGreetingCycle();
  }

  void _initAnimations() {
    // Wave animation untuk emoticon
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.elasticOut,
    ));

    // Greeting slide animation
    _greetingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _greetingAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _greetingController,
      curve: Curves.easeOutBack,
    ));

    // Sparkle animation
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));
  }

  void _startGreetingCycle() {
    // Mulai animasi setelah widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _greetingController.forward();
      _waveController.forward();
      
      // Ganti emoticon setiap 3 detik
      _startEmojiCycle();
    });
  }

  void _startEmojiCycle() {
    int currentIndex = 0;
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % _greetingEmojis.length;
          _currentEmoji = _greetingEmojis[currentIndex];
        });
        
        // Reset wave animation untuk emoji baru
        _waveController.reset();
        _waveController.forward();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    setState(() {
      username = storedUsername;
    });
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 17) {
      return 'Selamat Siang';
    } else if (hour < 21) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _greetingController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);
    final textColor = darkMode ? TColors.light : TColors.dark;
    final iconColor = darkMode ? TColors.light : TColors.dark;
    final subtitleColor = darkMode ? TColors.lightGrey : const Color.fromARGB(255, 255, 255, 255);

    return TAppbar(
        title: AnimatedBuilder(
          animation: _greetingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _greetingAnimation.value),
              child: Row(
                children: [
                  // Animated Greeting Emoji
                  AnimatedBuilder(
                    animation: _waveAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _waveAnimation.value * 0.5,
                        child: Transform.scale(
                          scale: 1.0 + (_waveAnimation.value * 0.2),
                          child: Text(
                            _currentEmoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Greeting Text with Sparkle Effect
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time-based greeting
                        Row(
                          children: [
                            Text(
                              _getTimeBasedGreeting(),
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: subtitleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            AnimatedBuilder(
                              animation: _sparkleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_sparkleAnimation.value * 0.3),
                                  child: Icon(
                                    Iconsax.sun_1,
                                    size: 14,
                                    color: Colors.orange.withOpacity(
                                      0.5 + (_sparkleAnimation.value * 0.5)
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 2),
                        
                        // Username with gradient text effect
                        Row(
                          children: [
                            Flexible(
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: darkMode 
                                    ? [TColors.light, Colors.blue.shade200]
                                    : [TColors.dark, const Color.fromARGB(255, 0, 0, 0)],
                                ).createShader(bounds),
                                child: Text(
                                  username != null && username!.isNotEmpty
                                      ? 'Hai, $username!'
                                      : 'Hai, Pengguna!',
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            AnimatedBuilder(
                              animation: _sparkleAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _sparkleAnimation.value * 2 * 3.14159,
                                  child: Icon(
                                    Iconsax.star_1,
                                    size: 16,
                                    color: const Color.fromARGB(255, 255, 255, 255).withOpacity(
                                      0.3 + (_sparkleAnimation.value * 0.7)
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          // Notification Bell with Badge
          // Container(
          //   margin: const EdgeInsets.only(right: 8),
          //   child: Stack(
          //     children: [
          //       // IconButton(
          //       //   onPressed: () {
          //       //     // Handle notification tap
          //       //   },
          //       //   icon: Icon(
          //       //     Iconsax.notification,
          //       //     color: iconColor,
          //       //     size: 24,
          //       //   ),
          //       // ),
          //       // Positioned(
          //       //   right: 8,
          //       //   top: 8,
          //       //   child: Container(
          //       //     width: 8,
          //       //     height: 8,
          //       //     decoration: BoxDecoration(
          //       //       color: Colors.red,
          //       //       borderRadius: BorderRadius.circular(4),
          //       //       boxShadow: [
          //       //         BoxShadow(
          //       //           color: Colors.red.withOpacity(0.3),
          //       //           blurRadius: 4,
          //       //           spreadRadius: 1,
          //       //         ),
          //       //       ],
          //       //     ),
          //       //   ),
          //       ),
          //     ],
          //   ),
          // ),
          
          // Enhanced Cart Icon
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.1),
                        Colors.pink.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CartCounterIcon(
                    onPressed: () {},
                    iconColor: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}
