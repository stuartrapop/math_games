import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

abstract class GameWithFrameFeatures extends FlameGame
    with DoubleTapDetector, TapDetector, HasGameRef, LongPressDetector {}
