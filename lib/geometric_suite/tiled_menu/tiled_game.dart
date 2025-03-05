import 'package:first_math/geometric_suite/common/components/sprite_display.dart';
import 'package:first_math/geometric_suite/tiled_menu/components/character_component.dart';
import 'package:first_math/geometric_suite/tiled_menu/components/menu_trigger_component.dart';
import 'package:first_math/geometric_suite/tiled_menu/components/obstacle_component.dart';
import 'package:first_math/geometric_suite/tiled_menu/tile_world.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class TiledGame extends FlameGame with HasCollisionDetection {
  TiledComponent? mainMap;
  late double mapWidth;
  late double mapHeight;
  late CharacterComponent george;
  Direction direction = Direction.idle;
  CollisionDirection collisionDirection = CollisionDirection.none;
  int characterSpeed = 50;
  final double characterSize = 64;
  final Function returnHome;

  TiledGame({required this.returnHome}) : super() {
    Flame.images.clearCache();
  }

  Future<void> loadMap() async {
    try {
      print('loadMap - start');

      // Remove old map completely before loading a new one
      if (mainMap != null) {
        if (mainMap!.isMounted) {
          mainMap!.removeFromParent();
        }
        // Force garbage collection by nullifying
        mainMap = null;
      }

      // Clear image cache before loading new assets
      Flame.images.clearCache();
      TiledAtlas.clearCache();
      await Flame.images.loadAll([
        'Monster_Elemental_Fire.png',
        'HF1_Tents_1.png',
        'HF1_Outdoors_1.png',
        'HF1_A2.png',
        'Water32Frames8x4.png'
      ]);
      print("after load all images");
      print("images loaded ${Flame.images.keys}");
      await Future.delayed(const Duration(milliseconds: 100));
      // Load the new map
      mainMap = await TiledComponent.load('mainMap.tmx', Vector2.all(32),
          useAtlas: false, images: Flame.images);
      print("mainMap loaded ${mainMap!.atlases()}");
      mainMap!.position = Vector2.zero();
      world.add(mainMap!);

      print('loadMap - complete');
    } catch (e) {
      print('Error loading map: $e');
    }
  }

  @override
  Future<void> onLoad() async {
    print("onLoad of tiled game");

    world = TileWorld();
    camera.viewfinder
      ..zoom = 1
      ..anchor = Anchor.topLeft;
    await Future.delayed(const Duration(milliseconds: 100));

    await loadMap();

    mapWidth =
        mainMap!.tileMap.map.width * mainMap!.tileMap.map.tileWidth.toDouble();
    mapHeight = mainMap!.tileMap.map.height *
        mainMap!.tileMap.map.tileHeight.toDouble();
    print("mapWidth $mapWidth mapHeight $mapHeight");
    print("screenwidht and screen height ${size.x} ${size.y}");
    final screenRatio = size.x / size.y;

    george = CharacterComponent(
        fileName: 'Monster_Elemental_Fire.png', srcSize: Vector2(100, 100))
      ..position = Vector2(0, 8 * 32)
      // ..debugMode = true
      ..size = Vector2.all(characterSize);
    world.add(george);
    double fixedViewWidth = (screenRatio * mapHeight);
    camera = CameraComponent.withFixedResolution(
      width: fixedViewWidth, // Use the screen width
      height: mapHeight, // Use the screen height
      world: world,
    )..moveTo(Vector2(fixedViewWidth / 2, mapHeight / 2));
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = 1;
    camera.follow(george, horizontalOnly: true, snap: true);
    camera.setBounds(Rectangle.fromLTRB(
        (fixedViewWidth) / 2, 0, mapWidth - (fixedViewWidth) / 2, mapHeight));

    final obstacleGroup = mainMap!.tileMap.getLayer<ObjectGroup>('Barrier');

    for (final object in obstacleGroup!.objects) {
      print("object name ${object.name}");
      final newObstacle = ObstacleComponent()
        ..size = Vector2(object.width, object.height)
        ..position = Vector2(object.x, object.y);
      if (object.name == 'Lock2') {
        final SpriteDisplay lockComponent =
            SpriteDisplay(spriteName: 'padlock.png', spriteSize: 64)
              ..size = Vector2(64, 64)
              ..position = Vector2(object.x, object.y)
              ..anchor = Anchor.topLeft;

        world.add(lockComponent);
      }

      world.add(newObstacle);
    }
    final menuGroup = mainMap!.tileMap.getLayer<ObjectGroup>('MenuItems');

    for (final object in menuGroup!.objects) {
      final menuItem = MenuTriggerComponent()
        ..size = Vector2(object.width, object.height)
        ..position = Vector2(object.x, object.y);

      world.add(menuItem);
    }
    overlays.add('text-overlay');
  }

  @override
  void onDispose() {
    print("onDispose of tiled game - start");

    super.onDispose();

    print("onDispose of tiled game - complete");
  }

  @override
  void onDetach() {
    // When component detaches, clear any Tiled resources
    if (mainMap != null) {
      // Explicitly clear any cached images from the map
      for (final tileset in mainMap!.tileMap.map.tilesets) {
        final imagePath = tileset.image?.source;
        if (imagePath != null) {
          Flame.images.clear(imagePath);
        }
      }
    }
    super.onDetach();
  }

  @override
  void onRemove() {
    print("onRemove of tiled game - start");

    // Stop all ongoing game activities
    pauseEngine();

    // Remove all components first
    world.removeAll(world.children);

    // Specifically handle the TiledComponent
    if (mainMap != null) {
      try {
        // Important: First remove it from world
        if (mainMap!.isMounted) {
          mainMap!.removeFromParent();
        }

        // Wait for a frame to ensure it's fully removed
        Future.delayed(Duration.zero, () {
          try {
            // Now clear the specific images
            for (final tileset in mainMap!.tileMap.map.tilesets) {
              if (tileset.image?.source != null) {
                print('Clearing tileset image: ${tileset.image!.source}');
                // Make sure to use the correct path - might need adjustments
                final imagePath = tileset.image!.source!.replaceAll('..', '');
                Flame.images.clear(imagePath);
              }
            }
          } catch (e) {
            print('Delayed tileset cleanup error: $e');
          }

          // Make sure to null the reference
          mainMap = null;
        });
      } catch (e) {
        print('Error in TiledComponent cleanup: $e');
      }
    }

    // Clear all game components
    removeAll(children);

    // Force clear ALL cached images
    Flame.images.clearCache();

    print("onRemove of tiled game - complete");
    super.onRemove();
  }
}
