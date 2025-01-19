import 'dart:math';

import 'package:first_math/number_line_game/audio_pool.dart';
import 'package:first_math/number_line_game/game_over.dart';
import 'package:first_math/number_line_game/game_path.dart';
import 'package:first_math/number_line_game/home.dart';
import 'package:first_math/number_line_game/number_ball.dart';
import 'package:first_math/number_line_game/number_line_world.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:just_audio/just_audio.dart';

class NumberLineGame extends FlameGame
    with TapCallbacks, DragCallbacks, HoverCallbacks, MouseMovementDetector {
  late final RouterComponent router;
  final Function returnHome;
  List<NumberBall> balls = [];
  bool hasVolume = true;
  int score = 0;
  double totalDistance = 0.0;
  int numberOfBallsAdded = 0;

  late final AudioPlayer bgmAudioPlayer;
  late AudioPool hitAudioPool;
  late AudioPool missAudioPool;
  late AudioPool shootAudioPool;

  GamePath gamePath =
      GamePath(gameSize: Vector2(775, 550).toSize(), pathRadius: 150);

  void resetGame() {
    balls.forEach((ball) {
      world.remove(ball);
    });
    balls.clear();
    int initialNumberOfBalls = 10;
    for (int i = 0; i < initialNumberOfBalls; i++) {
      final ball = NumberBall(
        number: Random().nextInt(9) + 1,
        isNextBall: false,
      )
        ..anchor = Anchor.center
        ..isVisible = true
        ..radius = 20;
      balls.add(ball);
    }
    world.addAll(balls);
    score = 0;
    paused = false;
    totalDistance = 0.0;
    numberOfBallsAdded = 0;
  }

  NumberLineGame({required this.returnHome})
      : super(
            camera: CameraComponent.withFixedResolution(
          width: 800,
          height: 600,
        )..moveTo(Vector2(400, 300)));

  @override
  Future<void> onLoad() async {
    bgmAudioPlayer = AudioPlayer();
    bgmAudioPlayer
        .setAsset('assets/audio/action-loop-e-90-bpm-brvhrtz-233462.mp3');
    bgmAudioPlayer.setLoopMode(LoopMode.one);

    hitAudioPool = AudioPool('assets/audio/won-point.mp3', 5); // Pool size: 5
    missAudioPool =
        AudioPool('assets/audio/near-miss-swing-whoosh-9-233430.mp3', 5);
    shootAudioPool = AudioPool('assets/audio/laser-gun-81720.mp3', 20);

    camera = CameraComponent.withFixedResolution(
      width: 800,
      height: 600,
    )..moveTo(Vector2(400, 300));
    camera.viewfinder.position = Vector2(400, 300);
    camera.viewfinder.anchor = Anchor.center;

    router = RouterComponent(
      routes: {
        'number-line': WorldRoute(
          () => NumberLineWorld(returnHome: returnHome),
        ),
        'game-over': OverlayRoute(
          (context, game) {
            return GameOver(
              onGoGame: () {
                game.overlays.remove('game-over');
                router.pushNamed('number-line');
              },
              returnHome: returnHome,
              game: game as NumberLineGame,
            );
          },
        ),
        'home': OverlayRoute(
          (context, game) {
            return Home(
              onGoGame: () {
                game.overlays.remove('home');
                router.pushNamed('number-line');
              },
              returnHome: returnHome,
              game: game as NumberLineGame,
            );
          },
        ),
      },
      initialRoute: 'home',
    );
    add(router);
    add(FpsTextComponent());
  }

  @override
  void onDispose() {
    bgmAudioPlayer.dispose();

    hitAudioPool.dispose();
    missAudioPool.dispose();
    shootAudioPool.dispose();

    super.onDispose();
  }

  @override
  void onRemove() {
    print("NumberLineGame onRemove");
    super.onRemove();
  }
}
