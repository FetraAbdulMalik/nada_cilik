import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pemrograman_mobile_project/models/song.dart';
import 'package:pemrograman_mobile_project/widgets/background.dart';

class PlayerScreen extends StatefulWidget {
  final AppState state;
  const PlayerScreen({super.key, required this.state});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onStateChanged);
    _startProgressSimulation();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startProgressSimulation() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (widget.state.isPlaying &&
          widget.state.currentSong != null &&
          widget.state.currentSong!.youtubeUrl == null) {
        setState(() {
          double newProgress = widget.state.playbackProgress + 0.01;
          if (newProgress >= 1.0) {
            newProgress = 0.0;
            widget.state.nextSong();
          }
          widget.state.setPlaybackProgress(newProgress);
        });
      }
    });
  }

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    _progressTimer?.cancel();
    super.dispose();
  }

  String _getCurrentDurationString(double progress, String totalDuration) {
    // Parse duration like "4:55" into seconds
    final parts = totalDuration.split(':');
    if (parts.length != 2) return "0:00";
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    final totalSeconds = (minutes * 60) + seconds;

    final currentSeconds = (totalSeconds * progress).round();
    final curMinutes = currentSeconds ~/ 60;
    final curSecs = currentSeconds % 60;

    return '$curMinutes:${curSecs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final song = state.currentSong ?? state.songs.first;

    return Scaffold(
      body: NadaCilikBackground(
        footerType: 'music',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Sedang Diputar',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Comic Sans MS',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Player Card
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      elevation: 8,
                      color: Colors.white.withAlpha(242),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Album Art cover graphic (Square)
                            Hero(
                              tag: 'cover_${song.id}',
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  color: song.color,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: song.color.withAlpha(102),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.music_note_rounded,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Song Title & Artist Name
                            Text(
                              song.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              song.artist,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (state.errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                state.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            const SizedBox(height: 28),

                            // Timeline Progress Bar Slider
                            Slider(
                              value: state.playbackProgress,
                              activeColor: Colors.blueAccent,
                              inactiveColor: Colors.blue.shade100,
                              onChanged: (double val) {
                                setState(() {
                                  state.setPlaybackProgress(val);
                                });
                              },
                            ),

                            // Duration Labels (Current and Total)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _getCurrentDurationString(state.playbackProgress, song.duration),
                                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    song.duration,
                                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Media Control Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Previous Button
                                IconButton(
                                  icon: const Icon(Icons.skip_previous_rounded),
                                  iconSize: 44,
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    setState(() {
                                      state.prevSong();
                                    });
                                  },
                                ),
                                const SizedBox(width: 16),
                                // Play/Pause Button
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      state.togglePlay();
                                    });
                                  },
                                  child: Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent.withAlpha(76),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: state.isLoadingAudio
                                        ? const Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Icon(
                                            state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 44,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Next Button
                                IconButton(
                                  icon: const Icon(Icons.skip_next_rounded),
                                  iconSize: 44,
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    setState(() {
                                      state.nextSong();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80), // Padding to avoid overlap with background illustrator
            ],
          ),
        ),
      ),
    );
  }
}
