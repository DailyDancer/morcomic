import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late SharedPreferences _prefs;

  static const _keyStarBits = 'star_bits';
  static const _keySectorBest = 'sector_best';
  static const _keyHapticsEnabled = 'haptics_enabled';
  static const _keyEquippedSkin = 'equipped_skin';
  static const _keyUnlockedSkins = 'unlocked_skins';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Star Bits (lifetime bank)
  int get starBits => _prefs.getInt(_keyStarBits) ?? 0;
  Future<void> setStarBits(int value) => _prefs.setInt(_keyStarBits, value);
  Future<void> addStarBits(int amount) => setStarBits(starBits + amount);
  Future<void> spendStarBits(int amount) => setStarBits(starBits - amount);

  // Sector Best (all-time high score)
  double get sectorBest => _prefs.getDouble(_keySectorBest) ?? 0;
  Future<void> setSectorBest(double value) => _prefs.setDouble(_keySectorBest, value);
  Future<void> updateSectorBest(double score) async {
    if (score > sectorBest) await setSectorBest(score);
  }

  // Haptics toggle
  bool get hapticsEnabled => _prefs.getBool(_keyHapticsEnabled) ?? true;
  Future<void> setHapticsEnabled(bool value) => _prefs.setBool(_keyHapticsEnabled, value);

  // Equipped skin
  String get equippedSkin => _prefs.getString(_keyEquippedSkin) ?? 'default';
  Future<void> setEquippedSkin(String id) => _prefs.setString(_keyEquippedSkin, id);

  // Unlocked skins
  List<String> get unlockedSkins =>
      _prefs.getStringList(_keyUnlockedSkins) ?? ['default'];
  Future<void> unlockSkin(String id) async {
    final skins = unlockedSkins;
    if (!skins.contains(id)) {
      skins.add(id);
      await _prefs.setStringList(_keyUnlockedSkins, skins);
    }
  }

  bool isSkinUnlocked(String id) => unlockedSkins.contains(id);
}
