import 'dart:math';

import 'package:first_math/angle_measurement_game/angle_measurement_game.dart';
import 'package:first_math/angle_measurement_game/angle_menu.dart';
import 'package:first_math/angle_measurement_game/angle_slide_game.dart';
import 'package:first_math/cerise_game/cerise_container.dart';
import 'package:first_math/five_across/five_accross_game.dart';
import 'package:first_math/geometry_game/geometry_game_container.dart';
import 'package:first_math/match_game/match_game_container.dart';
import 'package:first_math/memory_games/memory_game_container.dart';
import 'package:first_math/multi-cuisenaire/cuisenaire_game.dart';
import 'package:first_math/number_line_game/number_line_container.dart';
import 'package:first_math/pulley_game/pulley_game_container.dart';
import 'package:first_math/shape_match_game.dart/shape_match_game_container.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:star_menu/star_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Allow messages to queue instead of being discarded
  // Add this line:
  ServicesBinding.instance.defaultBinaryMessenger
      .setMessageHandler('flutter/lifecycle', (message) => Future.value(null));
  // Wait for platform channels to be ready
  await Future.delayed(const Duration(milliseconds: 200));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide Blocs to the entire app
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('fr', ''), // French
        // Add other locales as needed
      ],
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 700, name: MOBILE),
          const Breakpoint(start: 701, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }

  static void returnHome(BuildContext context) {
    context.go('/');
  }

  // Define your `go_router` routes
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) {
            return const ResponsiveScaledBox(
              width: 800,
              autoCalculateMediaQueryData: false,
              child: MenuPage(),
            );
          }),
      GoRoute(
        path: '/geometry-game',
        builder: (context, state) {
          return SafeArea(
              child:
                  GeometryGameContainer(returnHome: () => returnHome(context)));
        },
      ),
      GoRoute(
        path: '/angle',
        builder: (context, state) => const AngleMenu(),
        routes: [
          GoRoute(
            path: 'measurement',
            builder: (context, state) => const AngleMeasurementGame(),
          ),
          GoRoute(
            path: 'slide',
            builder: (context, state) => const AngleSlideGame(),
          ),
        ],
      ),

      GoRoute(
        path: '/five-accross-game',
        builder: (context, state) {
          return FiveAccrossContainer(returnHome: () => returnHome(context));
        },
      ),
      GoRoute(
        path: '/cuisenaire-game',
        builder: (context, state) {
          return GamePage(
              game: Cuisenaire(returnHome: () => returnHome(context)));
        },
      ),
      // Add more games as needed
      GoRoute(
        path: '/shape-match-game',
        builder: (context, state) {
          return ShapeMatchGameContainer(returnHome: () => returnHome(context));
        },
      ),
      GoRoute(
        path: '/match-game',
        builder: (context, state) {
          return MatchGameContainer(returnHome: () => returnHome(context));
        },
      ),
      // Add more games as needed
      GoRoute(
        path: '/memory-games',
        builder: (context, state) {
          return MemoryGameContainer(returnHome: () => returnHome(context));
        },
      ),
      GoRoute(
        path: '/pulley-game',
        builder: (context, state) {
          return PulleyGameContainer(returnHome: () => returnHome(context));
        },
      ),
      GoRoute(
        path: '/number-line-game',
        builder: (context, state) {
          return NumberLineContainer(returnHome: () => returnHome(context));
        },
      ),
      GoRoute(
        path: '/cerise-game',
        builder: (context, state) {
          return CeriseContainer(returnHome: () => returnHome(context));
        },
      ),
    ],
  );
}

class GamePage extends StatelessWidget {
  final Game game;

  const GamePage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    double limitingSize = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        ResponsiveBreakpoints.of(context).isMobile) {
      limitingSize = MediaQuery.of(context).size.height;
    }

    // entries for the dropdown menu
    final centerStarMenuController = StarMenuController();
    final otherEntries = <Widget>[
      // MenuItem(
      //     context: context,
      //     route: '/geometry-game',
      //     title: 'Géometrie',
      //     color: Colors.red,
      //     icon: Icons.hexagon_outlined),
      // MenuItem(
      //     context: context,
      //     route: '/angle',
      //     title: 'Angles',
      //     color: Colors.red,
      //     icon: Icons.text_rotation_angleup),
      MenuItem(
          key: const Key('shape-match'),
          context: context,
          route: '/shape-match-game',
          title: 'Shape Match',
          color: Colors.blue,
          icon: Icons.more_horiz_sharp),
      MenuItem(
          key: const Key('match-game'),
          context: context,
          route: '/match-game',
          title: 'Match',
          color: Colors.lightGreen,
          icon: Icons.compare_arrows),
      MenuItem(
          key: const Key('five-accross'),
          context: context,
          route: '/five-accross-game',
          title: 'Five Accross',
          color: Colors.orange,
          icon: Icons.compare_arrows),
      MenuItem(
          key: const Key('cuisenaire'),
          context: context,
          route: '/cuisenaire-game',
          title: 'Cuisenaire',
          color: Colors.yellow,
          icon: Icons.compare_arrows),
      MenuItem(
          key: const Key('memory-games'),
          context: context,
          route: '/memory-games',
          title: 'Memory',
          color: Colors.pink,
          icon: Icons.compare_arrows),
      // MenuItem(
      //     context: context,
      //     route: '/pulley-game',
      //     title: 'Pulley',
      //     color: const Color.fromARGB(255, 101, 30, 233),
      //     icon: Icons.compare_arrows),
      MenuItem(
          key: const Key('number-line'),
          context: context,
          route: '/number-line-game',
          title: 'Number Line',
          color: const Color.fromARGB(255, 101, 30, 233),
          icon: Icons.compare_arrows),
      MenuItem(
          key: const Key('cerise-game'),
          context: context,
          route: '/cerise-game',
          title: 'Cerise Game',
          color: const Color.fromARGB(255, 101, 30, 233),
          icon: Icons.compare_arrows),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true, // Ensures the title is centered

        title: const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            'Extreme Accessibility',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [],
        // upper bar menu
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StarMenu(
                    controller: centerStarMenuController,
                    params: StarMenuParameters.arc(
                      ArcType.semiUp,
                      radiusX: min(
                          max(
                            limitingSize * 0.25,
                            150,
                          ),
                          250),
                      radiusY: min(
                          max(
                            limitingSize * 0.30,
                            150,
                          ),
                          250),
                    ).copyWith(
                      onHoverScale: 1.3,
                    ),
                    items: otherEntries,
                    child: Container(
                      width: 75,
                      height: 75,
                      child: const FloatingActionButton(
                        heroTag: 'menu',
                        onPressed: null,
                        child: Icon(
                          Icons.open_with_sharp,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // background

            // center menu with default [StarMenuParameters] parameters
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final BuildContext context;
  final String route;
  final String title;
  final IconData icon;
  final Color color;
  const MenuItem({
    required this.context,
    required this.route,
    required this.title,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double limitingSize = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        ResponsiveBreakpoints.of(context).isMobile) {
      limitingSize = MediaQuery.of(context).size.height;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: min(limitingSize * 0.1, 80),
          height: min(limitingSize * 0.1, 80),
          child: FloatingActionButton(
            heroTag: route,
            onPressed: () => context.go(route),
            backgroundColor: color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    icon,
                    size: min(limitingSize * 0.07, 40),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
