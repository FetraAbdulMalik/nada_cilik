import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pemrograman_mobile_project/models/song.dart';
import 'package:pemrograman_mobile_project/widgets/background.dart';

class SleepScreen extends StatefulWidget {
  final AppState state;
  const SleepScreen({super.key, required this.state});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  Timer? _timer;
  late int _secondsRemaining;

  @override
  void initState() {
    super.initState();
    // Initialize seconds remaining based on the app state's minutes remaining
    _secondsRemaining = widget.state.sleepMinutesRemaining * 60;
    if (widget.state.isSleepTimerEnabled) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          // Keep the AppState minutes in sync
          widget.state.sleepMinutesRemaining = (_secondsRemaining / 60).ceil();
        });
      } else {
        _timer?.cancel();
        setState(() {
          widget.state.toggleSleepTimer(false);
          widget.state.isPlaying = false; // Stop playback when sleep timer hits 0
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSecs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Scaffold(
      body: NadaCilikBackground(
        footerType: 'sleep',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      'Pengaturan Tidur',
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

              // Timer Display Card (Purple container)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8E24AA), Color(0xFF6A1B9A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withAlpha(76),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Waktu Tidur Sekarang',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatDuration(_secondsRemaining),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.nightlight_round,
                          color: Colors.yellowAccent,
                          size: 24,
                        ),
                        if (state.sleepTargetTime != null && state.isSleepTimerEnabled) ...[
                          const SizedBox(width: 8),
                          Text(
                            'Matikan Musik pada ${state.sleepTargetTime!.format(context)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Time (Jam) Selector Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.access_time_filled_rounded,
                      color: Color(0xFF8E24AA),
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Pilih Jam Musik Berhenti',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    state.sleepTargetTime != null
                        ? 'Musik akan mati pada pukul ${state.sleepTargetTime!.format(context)}'
                        : 'Atur jam spesifik agar musik berhenti otomatis',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF8E24AA)),
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: state.sleepTargetTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        state.setSleepTargetTime(picked);
                        _secondsRemaining = state.sleepMinutesRemaining * 60;
                        if (state.isSleepTimerEnabled) {
                          _startTimer();
                        } else {
                          state.toggleSleepTimer(true);
                          _startTimer();
                        }
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Controls Card/Row
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.alarm_rounded,
                          color: Color(0xFF8E24AA),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Timer Otomatis',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.isSleepTimerEnabled
                                  ? 'Matikan otomatis aktif: ${state.sleepMinutesRemaining} menit lagi'
                                  : 'Aktifkan untuk mematikan musik otomatis',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Toggle Switch
                      Switch(
                        value: state.isSleepTimerEnabled,
                        activeThumbColor: const Color(0xFF8E24AA),
                        onChanged: (bool value) {
                          setState(() {
                            state.toggleSleepTimer(value);
                            if (value) {
                              _secondsRemaining = state.sleepMinutesRemaining * 60;
                              _startTimer();
                            } else {
                              _stopTimer();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Interactive duration slider (Alternative duration tuning)
              if (state.isSleepTimerEnabled)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sesuaikan Durasi (Menit)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Slider(
                          value: state.sleepMinutesRemaining.toDouble().clamp(5.0, 120.0),
                          min: 5,
                          max: 120,
                          divisions: 23,
                          activeColor: const Color(0xFF8E24AA),
                          inactiveColor: Colors.purple.shade100,
                          label: '${state.sleepMinutesRemaining} menit',
                          onChanged: (double value) {
                            setState(() {
                              state.setSleepTimer(value.round());
                              _secondsRemaining = value.round() * 60;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
