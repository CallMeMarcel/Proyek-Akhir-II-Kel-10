import 'package:del_cafeshop/utils/constants/image_strings.dart';
import 'package:del_cafeshop/utils/constants/sizes.dart';
import 'package:del_cafeshop/utils/constants/text_strings.dart';
import 'package:del_cafeshop/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatefulWidget {
  const LoginHeader({
    super.key,
  });

  @override
  State<LoginHeader> createState() => _LoginHeaderState();
}

class _LoginHeaderState extends State<LoginHeader>
    with TickerProviderStateMixin {
  
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // Text animations
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Pulse animation for glow effect
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
    });
    
    // Start pulse animation and repeat
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animated Logo with enhanced effects
        Center(
          child: AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value.clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: _logoRotationAnimation.value,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.orange.withOpacity(0.3 * _pulseAnimation.value.clamp(0.0, 1.0)),
                              Colors.deepOrange.withOpacity(0.1 * _pulseAnimation.value.clamp(0.0, 1.0)),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 20 * _pulseAnimation.value.clamp(0.0, 1.0),
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.orange[100]!,
                                  Colors.orange[50]!,
                                ],
                              ),
                              border: Border.all(
                                color: Colors.orange[300]!,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image(
                                image: AssetImage(
                                  dark ? TImages.darkAppLogo : TImages.lightAppLogo,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: TSizes.spaceBtwSections),
        
        // Animated Title
        SlideTransition(
          position: _titleSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  TTexts.loginTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.orange.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: TSizes.sm),
        
        // Animated Subtitle with enhanced styling
        SlideTransition(
          position: _subtitleSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                TTexts.loginSubTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: dark 
                      ? Colors.orange[200] 
                      : Colors.orange[700],
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
        
        // Decorative elements
        const SizedBox(height: TSizes.spaceBtwItems),
        
        // Animated decorative line
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Container(
              height: 4,
              width: MediaQuery.of(context).size.width * 0.6 * value.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    Colors.orange,
                    Colors.deepOrange,
                    Colors.orange[300]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            );
          },
        ),
        
        const SizedBox(height: TSizes.sm),
        
        // Floating particles effect
        _buildFloatingParticles(),
      ],
    );
  }

  Widget _buildFloatingParticles() {
    return SizedBox(
      height: 50,
      child: Stack(
        children: List.generate(5, (index) {
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 2000 + (index * 200)),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Positioned(
                left: (index * 60.0) + (20 * value.clamp(0.0, 1.0)),
                top: 20 + (10 * (0.5 - (value.clamp(0.0, 1.0) - 0.5).abs())),
                child: Opacity(
                  opacity: (0.3 + (0.4 * value.clamp(0.0, 1.0))).clamp(0.0, 1.0),
                  child: Container(
                    width: 8 + (4 * value.clamp(0.0, 1.0)),
                    height: 8 + (4 * value.clamp(0.0, 1.0)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.orange[300]!,
                          Colors.orange[100]!,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}