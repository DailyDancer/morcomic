import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/skin_data.dart';
import '../game/cosmic_morph_game.dart';
import '../services/storage_service.dart';

class ArsenalOverlay extends StatefulWidget {
  const ArsenalOverlay({super.key, required this.game});

  final CosmicMorphGame game;

  @override
  State<ArsenalOverlay> createState() => _ArsenalOverlayState();
}

class _ArsenalOverlayState extends State<ArsenalOverlay> {
  String _equippedSkin = StorageService.instance.equippedSkin;
  int _starBits = StorageService.instance.starBits;

  void _onSkinTapped(SkinData skin) async {
    final storage = StorageService.instance;

    if (storage.isSkinUnlocked(skin.id)) {
      await storage.setEquippedSkin(skin.id);
      setState(() {
        _equippedSkin = skin.id;
      });
    } else if (_starBits >= skin.price) {
      await storage.spendStarBits(skin.price);
      await storage.unlockSkin(skin.id);
      await storage.setEquippedSkin(skin.id);
      setState(() {
        _starBits = storage.starBits;
        _equippedSkin = skin.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.deepSpace,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.game.overlays.remove('Arsenal');
                      widget.game.overlays.add('CosmicHub');
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.stardust, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('THE ARSENAL', style: textTheme.labelLarge),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.starBitWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.sphereCyan, blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$_starBits',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.sphereCyan,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: SkinData.all.length,
                  itemBuilder: (context, index) {
                    final skin = SkinData.all[index];
                    final isUnlocked = StorageService.instance.isSkinUnlocked(skin.id);
                    final isEquipped = _equippedSkin == skin.id;
                    final canAfford = _starBits >= skin.price;

                    return _SkinCard(
                      skin: skin,
                      isUnlocked: isUnlocked,
                      isEquipped: isEquipped,
                      canAfford: canAfford,
                      onTap: () => _onSkinTapped(skin),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkinCard extends StatelessWidget {
  const _SkinCard({
    required this.skin,
    required this.isUnlocked,
    required this.isEquipped,
    required this.canAfford,
    required this.onTap,
  });

  final SkinData skin;
  final bool isUnlocked;
  final bool isEquipped;
  final bool canAfford;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.stardust,
          borderRadius: BorderRadius.circular(8),
          border: isEquipped
              ? Border.all(color: AppColors.sphereCyan, width: 2)
              : null,
        ),
        child: ColorFiltered(
          colorFilter: isUnlocked
              ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
              : const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ColorDot(color: skin.sphereColor),
                  const SizedBox(width: 8),
                  _ColorDot(color: skin.apexColor),
                  const SizedBox(width: 8),
                  _ColorDot(color: skin.blockColor),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                skin.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              if (isEquipped)
                Text(
                  'EQUIPPED',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.sphereCyan,
                    fontSize: 11,
                  ),
                )
              else if (isUnlocked)
                Text(
                  'OWNED',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                )
              else
                Text(
                  '${skin.price} ★',
                  style: textTheme.bodySmall?.copyWith(
                    color: canAfford ? AppColors.blockYellow : Colors.white38,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}
