import 'dart:ui';

import 'app_colors.dart';

class SkinData {
  const SkinData({
    required this.id,
    required this.name,
    required this.sphereColor,
    required this.apexColor,
    required this.blockColor,
    required this.price,
  });

  final String id;
  final String name;
  final Color sphereColor;
  final Color apexColor;
  final Color blockColor;
  final int price;

  static const List<SkinData> all = [
    SkinData(
      id: 'default',
      name: 'Origin',
      sphereColor: AppColors.sphereCyan,
      apexColor: AppColors.apexMagenta,
      blockColor: AppColors.blockYellow,
      price: 0,
    ),
    SkinData(
      id: 'emerald',
      name: 'Emerald',
      sphereColor: Color(0xFF00E676),
      apexColor: Color(0xFF69F0AE),
      blockColor: Color(0xFFA5D6A7),
      price: 100,
    ),
    SkinData(
      id: 'solar',
      name: 'Solar',
      sphereColor: Color(0xFFFF9100),
      apexColor: Color(0xFFFFAB40),
      blockColor: Color(0xFFFFD740),
      price: 150,
    ),
    SkinData(
      id: 'arctic',
      name: 'Arctic',
      sphereColor: Color(0xFF80D8FF),
      apexColor: Color(0xFFB3E5FC),
      blockColor: Color(0xFFE1F5FE),
      price: 200,
    ),
    SkinData(
      id: 'phantom',
      name: 'Phantom',
      sphereColor: Color(0xFFB388FF),
      apexColor: Color(0xFFEA80FC),
      blockColor: Color(0xFFCE93D8),
      price: 250,
    ),
    SkinData(
      id: 'inferno',
      name: 'Inferno',
      sphereColor: Color(0xFFFF1744),
      apexColor: Color(0xFFFF5252),
      blockColor: Color(0xFFFF8A80),
      price: 300,
    ),
    SkinData(
      id: 'nebula',
      name: 'Nebula',
      sphereColor: Color(0xFF7C4DFF),
      apexColor: Color(0xFF448AFF),
      blockColor: Color(0xFF18FFFF),
      price: 400,
    ),
    SkinData(
      id: 'void_core',
      name: 'Void Core',
      sphereColor: Color(0xFFFFFFFF),
      apexColor: Color(0xFFBDBDBD),
      blockColor: Color(0xFF757575),
      price: 500,
    ),
  ];

  static SkinData getById(String id) {
    return all.firstWhere((s) => s.id == id, orElse: () => all.first);
  }
}
