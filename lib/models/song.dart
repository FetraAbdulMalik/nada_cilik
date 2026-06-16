import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class Song {
  final String id;
  final String title;
  final String artist;
  final String category; // 'education' or 'music'
  final String duration;
  final Color color;
  bool isFavorite;
  final String? youtubeUrl;
  String? audioUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.category,
    required this.duration,
    required this.color,
    this.isFavorite = false,
    this.youtubeUrl,
    this.audioUrl,
  });
}

class AppState extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer(
    userAgent: 'Mozilla/5.0 (Linux; Android 13; SM-S901B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36',
  );
  final yt.YoutubeExplode _yt = yt.YoutubeExplode();

  // User Profile Data
  String username = 'Lois Becket';
  String email = 'Loisbecket@gmail.com';
  String birthDate = '18/03/2024';
  String password = 'password123';
  bool isLoggedIn = false;

  // Songs
  final List<Song> _songs = [
    Song(
      id: '1',
      title: 'Timun Mas',
      artist: 'Baby Kids',
      category: 'education',
      duration: '4:55',
      color: Colors.purple.shade300,
      youtubeUrl: 'https://www.youtube.com/watch?v=Gbpb69UI5UI',
    ),
    Song(
      id: '2',
      title: 'Lagu Anak Membaca',
      artist: 'Baby Kids',
      category: 'education',
      duration: '3:20',
      color: Colors.orange.shade300,
      isFavorite: true, // Preset in Figma
      youtubeUrl: 'https://www.youtube.com/watch?v=p4vWex1uW0w',
    ),
    Song(
      id: '3',
      title: 'Cicak Cicak Di Dinding',
      artist: 'Uwa and Friends',
      category: 'music',
      duration: '2:15',
      color: Colors.blue.shade300,
      youtubeUrl: 'https://www.youtube.com/watch?v=kGg_t17F-jQ',
    ),
    Song(
      id: '4',
      title: 'Lagu Anak Ampar Ampar Pisang',
      artist: 'Baby Kids',
      category: 'music',
      duration: '3:10',
      color: Colors.green.shade300,
      youtubeUrl: 'https://www.youtube.com/watch?v=KzE_XzHjO5Y',
    ),
    Song(
      id: '5',
      title: 'Lagu Anak Naik Kereta Api',
      artist: 'Baby Kids',
      category: 'music',
      duration: '2:45',
      color: Colors.red.shade300,
      youtubeUrl: 'https://www.youtube.com/watch?v=hYw0tD7-Y8A',
    ),
    Song(
      id: '6',
      title: 'Potong Bebek Angsa',
      artist: 'Lagu Anak-Anak',
      category: 'music',
      duration: '1:50',
      color: Colors.teal.shade300,
      youtubeUrl: 'https://www.youtube.com/watch?v=0h9Vp2dO1v4',
    ),
    Song(
      id: '7',
      title: 'Malin Kundang',
      artist: 'Cerita Rakyat',
      category: 'education',
      duration: '5:10',
      color: Colors.blueGrey.shade300,
      youtubeUrl: 'https://www.youtube.com/watch?v=E0YDv3WQUCU',
    ),
    Song(
      id: '8',
      title: 'Bawang Merah Bawang Putih',
      artist: 'Cerita Rakyat',
      category: 'education',
      duration: '6:30',
      color: Colors.blueGrey.shade300,
      youtubeUrl: 'https://www.youtube.com/watch?v=R9K1uM6K2g0',
    ),
  ];

  List<Song> get songs => _songs;
  List<Song> get favorites => _songs.where((song) => song.isFavorite).toList();

  // Active Playback
  Song? currentSong;
  bool isPlaying = false;
  double playbackProgress = 0.0; // 0.0 to 1.0
  bool isLoadingAudio = false;
  String? errorMessage;

  // Sleep Timer
  bool isSleepTimerEnabled = true;
  int sleepMinutesRemaining = 30;
  TimeOfDay? sleepTargetTime = const TimeOfDay(hour: 22, minute: 0);

  AppState() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying = state.playing;
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((pos) {
      final total = _audioPlayer.duration ?? Duration.zero;
      if (total.inSeconds > 0) {
        playbackProgress = pos.inSeconds / total.inSeconds;
        notifyListeners();
      }
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.loading || state == ProcessingState.buffering) {
        isLoadingAudio = true;
      } else {
        isLoadingAudio = false;
      }
      notifyListeners();

      if (state == ProcessingState.completed) {
        nextSong();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _yt.close();
    super.dispose();
  }

  void login(String user, String pass) {
    username = user;
    password = pass;
    isLoggedIn = true;
    notifyListeners();
  }

  void register(String user, String mail, String date, String pass) {
    username = user;
    email = mail;
    birthDate = date;
    password = pass;
    isLoggedIn = true;
    notifyListeners();
  }

  void updateProfile(String user, String mail, String date, String pass) {
    username = user;
    email = mail;
    birthDate = date;
    password = pass;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  void toggleFavorite(Song song) {
    song.isFavorite = !song.isFavorite;
    notifyListeners();
  }

  void addToFavorite(Song song) {
    song.isFavorite = true;
    notifyListeners();
  }

  void removeFromFavorite(Song song) {
    song.isFavorite = false;
    notifyListeners();
  }

  Future<void> playSong(Song song) async {
    currentSong = song;
    isPlaying = false;
    playbackProgress = 0.0;
    errorMessage = null;
    isLoadingAudio = true;
    notifyListeners();

    if (song.youtubeUrl != null) {
      try {
        if (kIsWeb) {
          // Bypassing YouTube Explode on Web due to CORS. Use CORS-friendly Indonesian children's song URLs.
          final songId = song.id;
          if (songId == '1') {
            song.audioUrl = 'https://archive.org/download/CeritaRakyatTimunMas-Audiobook/timun%20mas_sampel.mp3';
          } else if (songId == '2') {
            song.audioUrl = 'https://archive.org/download/IndonesiaLaguAnak/4.Pergi%20Belajar.mp3';
          } else if (songId == '3') {
            song.audioUrl = 'https://archive.org/download/IndonesiaLaguAnak/68.cicak%20cicak%20di%20dinding.mp3';
          } else if (songId == '4') {
            song.audioUrl = 'https://archive.org/download/IndonesiaLaguAnak/44.Pok%20Ame-Ame.mp3';
          } else if (songId == '5') {
            song.audioUrl = 'https://archive.org/download/IndonesiaLaguAnak/26.naek%20kereta%20api.mp3';
          } else if (songId == '6') {
            song.audioUrl = 'https://archive.org/download/IndonesiaLaguAnak/81.potong%20bebek%20angsa.mp3';
          } else if (songId == '7') {
            song.audioUrl = 'https://anchor.fm/s/d600920/podcast/play/4272773/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2020-02-19%2F9c76bcc298987b9ae96d84f1e99fd945.m4a';
          } else if (songId == '8') {
            song.audioUrl = 'https://anchor.fm/s/d600920/podcast/play/4238031/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2020-02-18%2F39578615b316c1dc41480e616e5b581e.m4a';
          } else {
            song.audioUrl = 'https://archive.org/download/IndonesiaLaguAnak/3.pelangi%20pelangi.mp3';
          }
        } else {
          // Selalu ambil stream URL segar karena URL youtube memiliki masa kadaluwarsa (expired)
          final videoId = yt.VideoId.parseVideoId(song.youtubeUrl!);
          final manifest = await _yt.videos.streamsClient
              .getManifest(videoId)
              .timeout(const Duration(seconds: 8));
          final audioStream = manifest.audioOnly.withHighestBitrate();
          song.audioUrl = audioStream.url.toString();
        }

        await _audioPlayer
            .setUrl(song.audioUrl!)
            .timeout(const Duration(seconds: 12));
        _audioPlayer.play();
      } catch (e) {
        print("Error playing YouTube audio: $e");
        errorMessage = "Gagal memutar audio: $e";
        isLoadingAudio = false;
        notifyListeners();
      }
    } else {
      isLoadingAudio = false;
      isPlaying = true;
      notifyListeners();
    }
  }

  void togglePlay() {
    if (currentSong?.youtubeUrl != null) {
      if (_audioPlayer.playing) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play();
      }
    } else {
      isPlaying = !isPlaying;
    }
    notifyListeners();
  }

  void nextSong() {
    if (currentSong == null) return;
    int index = _songs.indexOf(currentSong!);
    int nextIndex = (index + 1) % _songs.length;
    playSong(_songs[nextIndex]);
  }

  void prevSong() {
    if (currentSong == null) return;
    int index = _songs.indexOf(currentSong!);
    int prevIndex = (index - 1 + _songs.length) % _songs.length;
    playSong(_songs[prevIndex]);
  }

  void setPlaybackProgress(double progress) {
    playbackProgress = progress;
    if (currentSong?.youtubeUrl != null) {
      final duration = _audioPlayer.duration ?? Duration.zero;
      final targetPosition = duration * progress;
      _audioPlayer.seek(targetPosition);
    }
    notifyListeners();
  }

  Future<bool> addYoutubeSong(String url, String category) async {
    try {
      final videoId = yt.VideoId.parseVideoId(url);
      
      String title;
      String artist;
      String durationStr;

      if (kIsWeb) {
        // Mock YouTube metadata on Web because retrieving it directly fails due to CORS
        title = 'Lagu YouTube ($videoId)';
        artist = 'Artis YouTube';
        durationStr = '3:00';
      } else {
        final video = await _yt.videos.get(videoId);
        title = video.title;
        artist = video.author;
        durationStr = "${video.duration?.inMinutes ?? 0}:${(video.duration?.inSeconds ?? 0) % 60}";
      }

      final newSong = Song(
        id: (songs.length + 1).toString(),
        title: title,
        artist: artist,
        category: category,
        duration: durationStr,
        color: Colors.pink.shade300,
        youtubeUrl: url,
      );

      _songs.add(newSong);
      notifyListeners();
      return true;
    } catch (e) {
      print("Failed to add YouTube song: $e");
      return false;
    }
  }

  void toggleSleepTimer(bool value) {
    isSleepTimerEnabled = value;
    notifyListeners();
  }

  void setSleepTimer(int minutes) {
    sleepMinutesRemaining = minutes;
    sleepTargetTime = null;
    notifyListeners();
  }

  void setSleepTargetTime(TimeOfDay? time) {
    sleepTargetTime = time;
    if (time != null) {
      final now = DateTime.now();
      var targetDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      if (targetDateTime.isBefore(now)) {
        targetDateTime = targetDateTime.add(const Duration(days: 1));
      }
      sleepMinutesRemaining = targetDateTime.difference(now).inMinutes;
    }
    notifyListeners();
  }
}
