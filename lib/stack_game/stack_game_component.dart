import 'dart:async';
import 'dart:math';

import 'package:first_math/bloc/game_stats_bloc.dart';
import 'package:first_math/stack_game/cube.dart';
import 'package:first_math/stack_game/info.dart';
import 'package:first_math/stack_game/mathColumn.dart';
import 'package:first_math/stack_game/stack_stat.dart';
import 'package:first_math/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class StackGameComponent extends PositionComponent {
  final World world;
  final GameStatsBloc gameStatsBloc;
  RouterComponent router;

  StackGameComponent(
      {required this.world, required this.gameStatsBloc, required this.router})
      : super(priority: 10) {
    this.router = router;
  }

  final List<PositionComponent> components = [];
  final List<MathColumn> columns = [];
  final worldSize = Vector2(600, 900);
  final double margin = 20.0;
  late double columnWidth;

  late StreamSubscription<GameStatsState> blocSubscription;

  @override
  Future<void> onLoad() async {
    print("StackGameComponent onLoad");
    super.onLoad();
    columnWidth = (worldSize.x - margin) / 13;

    columns.clear();
    components.clear();

    // Subscribe to Bloc state changes
    blocSubscription = gameStatsBloc.stream.listen((state) {
      _updateColumns(state);
    });

    // Initialize components
    _buildInitialComponents();
    _updateColumns(gameStatsBloc.state);
    printComponentTree(this);
  }

  @override
  Future<void> onRemove() async {
    // Cancel the Bloc subscription when the component is removed
    await blocSubscription.cancel();
    super.onRemove();
  }

  void _buildInitialComponents() {
    final hudWidth = size.x * 0.3;
    final hudHeight = 250.0;

    final stackStatHud = StackStatHudComponent(
      hudWidth: hudWidth,
      hudHeight: hudHeight,
      gameStatsBloc: gameStatsBloc,
    )..position = Vector2(margin * 2 + columnWidth * 8, 30);

    world.removeAll(children);
    world.add(stackStatHud);
    // Add Info component
    final info = Info()
      ..position = Vector2(25, 25)
      ..size = Vector2(50, 50) // Adjusted size for info
      ..anchor = Anchor.topLeft;
    components.add(info);
    world.add(info);
    // Add Cube component
    final cubeSize = Vector2(worldSize.y * 0.1, worldSize.y * 0.1);
    world.add(Cube(number: 1, priority: 100, isDraggable: true)
      ..position = Vector2(40, worldSize.y / 2 - cubeSize.y / 2)
      ..size = cubeSize);
  }

  // Called whenever the GameStatsBloc updates
  void _updateColumns(GameStatsState state) {
    // Clear existing columns from the list
    columns.clear();

    // Remove all MathColumn components from children
    final existingColumns = children.whereType<MathColumn>().toList();
    for (final column in existingColumns) {
      if (column.parent != null) {
        remove(column);
      }
    }

    // Define margins and layout

    // Add new Math Columns
    for (int i = 0; i < 7; i++) {
      int power = 6 - i;
      int number = (state.blockValue / pow(10, power)).floor() % 10;

      final column = MathColumn(
        number: number,
        power: power,
        priority: 15,
        gameStatsBloc: gameStatsBloc,
      )
        ..position = Vector2(margin * 4 + columnWidth * i, 100)
        ..size = Vector2(columnWidth - margin * 0.75, worldSize.y - 150)
        ..anchor = Anchor.topLeft;

      columns.add(column); // Keep track of columns
      world.add(column); // Add to the component tree
    }

    print("Columns updated: ${columns.length}");
  }
}
