import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';

enum SpriteType {
  a3dHammer,
  anchor,
  chessKnight,
  church,
  clubs,
  crownCoin,
  dinosaur,
  elephant,
  elvenCastle,
  fishbone,
  fleurDeLys,
  frogFoot,
  gorilla,
  grenade,
  labrador,
  largePaintBrush,
  lockedChest,
  mayanPyramid,
  monkey,
  mushroom,
  northStar,
  octopus,
  paperClip,
  pirateFlag,
  pistolGun,
  pumpkinLantern,
  roughWound,
  sailboat,
  scissors,
  seaStar,
  whiteTower,
  wineGlass,
}

class SpriteInfo {
  final String fileName;
  final String description;

  SpriteInfo({
    required this.fileName,
    required this.description,
  });
}

extension SpriteTypeExtension on SpriteType {
  SpriteInfo get fileName {
    switch (this) {
      case SpriteType.a3dHammer:
        return SpriteInfo(
          fileName: "3d-hammer.png",
          description: "a3dHammer",
        );
      case SpriteType.anchor:
        return SpriteInfo(
          fileName: "anchor.png",
          description: "anchor",
        );
      case SpriteType.chessKnight:
        return SpriteInfo(
          fileName: "chess-knight.png",
          description: "chessKnight",
        );
      case SpriteType.church:
        return SpriteInfo(
          fileName: "church.png",
          description: "church",
        );
      case SpriteType.clubs:
        return SpriteInfo(
          fileName: "clubs.png",
          description: "clubs",
        );
      case SpriteType.crownCoin:
        return SpriteInfo(
          fileName: "crown-coin.png",
          description: "crownCoin",
        );
      case SpriteType.dinosaur:
        return SpriteInfo(
          fileName: "dinosaur-rex.png",
          description: "dinosaur",
        );
      case SpriteType.elephant:
        return SpriteInfo(
          fileName: "elephant.png",
          description: "elephant",
        );
      case SpriteType.elvenCastle:
        return SpriteInfo(
          fileName: "elven-castle.png",
          description: "elvenCastle",
        );
      case SpriteType.fishbone:
        return SpriteInfo(
          fileName: "fishbone.png",
          description: "fishbone",
        );
      case SpriteType.fleurDeLys:
        return SpriteInfo(
          fileName: "fleur-de-lys.png",
          description: "fleurDeLys",
        );
      case SpriteType.frogFoot:
        return SpriteInfo(
          fileName: "frog-foot.png",
          description: "frogFoot",
        );
      case SpriteType.gorilla:
        return SpriteInfo(
          fileName: "gorilla.png",
          description: "gorilla",
        );
      case SpriteType.grenade:
        return SpriteInfo(
          fileName: "grenade.png",
          description: "grenade",
        );
      case SpriteType.labrador:
        return SpriteInfo(
          fileName: "labrador-head.png",
          description: "labrador",
        );
      case SpriteType.largePaintBrush:
        return SpriteInfo(
          fileName: "large-paint-brush.png",
          description: "largePaintBrush",
        );
      case SpriteType.lockedChest:
        return SpriteInfo(
          fileName: "locked-chest.png",
          description: "lockedChest",
        );
      case SpriteType.mayanPyramid:
        return SpriteInfo(
          fileName: "mayan-pyramid.png",
          description: "mayanPyramid",
        );
      case SpriteType.monkey:
        return SpriteInfo(
          fileName: "monkey.png",
          description: "monkey",
        );
      case SpriteType.mushroom:
        return SpriteInfo(
          fileName: "mushroom-gills.png",
          description: "mushroom",
        );
      case SpriteType.northStar:
        return SpriteInfo(
          fileName: "north-star-shuriken.png",
          description: "northStar",
        );
      case SpriteType.octopus:
        return SpriteInfo(
          fileName: "octopus.png",
          description: "octopus",
        );
      case SpriteType.paperClip:
        return SpriteInfo(
          fileName: "paper-clip.png",
          description: "paperClip",
        );
      case SpriteType.pirateFlag:
        return SpriteInfo(
          fileName: "pirate-flag.png",
          description: "pirateFlag",
        );
      case SpriteType.pistolGun:
        return SpriteInfo(
          fileName: "pistol-gun.png",
          description: "pistolGun",
        );
      case SpriteType.pumpkinLantern:
        return SpriteInfo(
          fileName: "pumpkin-lantern.png",
          description: "pumpkinLantern",
        );
      case SpriteType.roughWound:
        return SpriteInfo(
          fileName: "rough-wound.png",
          description: "roughWound",
        );
      case SpriteType.sailboat:
        return SpriteInfo(
          fileName: "sailboat.png",
          description: "sailboat",
        );
      case SpriteType.scissors:
        return SpriteInfo(
          fileName: "scissors.png",
          description: "scissors",
        );
      case SpriteType.seaStar:
        return SpriteInfo(
          fileName: "sea-star.png",
          description: "seaStar",
        );
      case SpriteType.whiteTower:
        return SpriteInfo(
          fileName: "white-tower.png",
          description: "whiteTower",
        );
      case SpriteType.wineGlass:
        return SpriteInfo(
          fileName: "wine-glass.png",
          description: "wineGlass",
        );
    }
  }
}

const brickColors = [
  // Add this const
  Color(0xfff94144),
  Color(0xfff3722c),
  Color(0xfff8961e),
  Color(0xfff9844a),
  Color(0xfff9c74f),
  Color(0xff90be6d),
  Color(0xff43aa8b),
  Color(0xff4d908e),
  Color(0xff277da1),
  Color(0xff577590),
];

class SpriteLoader {
  final Images images = Images();
  final Map<SpriteType, Sprite> sprites = {};
  final Map<SpriteType, String> descriptions = {};

  /// Load all sprites and their descriptions
  Future<void> loadSprites() async {
    for (final type in SpriteType.values) {
      final spriteInfo =
          type.fileName; // Fetching the `SpriteInfo` object from the extension
      final image = await images.load('memoryMatch/${spriteInfo.fileName}');
      sprites[type] = Sprite(image);
      descriptions[type] =
          spriteInfo.description; // Storing the description separately
    }
  }

  /// Get the sprite for a given type
  Sprite getSprite(SpriteType type) {
    if (!sprites.containsKey(type)) {
      throw Exception('Sprite not loaded for type: $type');
    }
    return sprites[type]!;
  }

  /// Get the description for a given type
  String getDescription(SpriteType type) {
    if (!descriptions.containsKey(type)) {
      throw Exception('Description not loaded for type: $type');
    }
    return descriptions[type]!;
  }
}
