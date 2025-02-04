import 'package:just_audio/just_audio.dart';

class AudioPool {
  final List<AudioPlayer> players;
  int currentIndex = 0;

  AudioPool(String filePath, int poolSize)
      : players = List.generate(poolSize, (_) {
          final player = AudioPlayer();
          player.setAsset(filePath); // Preload audio file
          return player;
        });

  void play() async {
    final player = players[currentIndex];
    await player.stop();
    await player.seek(Duration.zero);
    player.play();
    currentIndex = (currentIndex + 1) % players.length; // Circular indexing
  }

  void dispose() {
    for (final player in players) {
      player.dispose(); // Dispose of each player
    }
  }
}
