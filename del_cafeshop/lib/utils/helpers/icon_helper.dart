import 'package:flutter/material.dart';

IconData getIconForCategory(String name) {
              switch (name.toLowerCase()) {
                case 'makanan':
                  return Icons.fastfood;
                case 'minuman':
                case 'ice':
                  return Icons.local_drink;
                case 'gorengan':
                  return Icons.set_meal;
                default:
                  return Icons.category;
              }
            }