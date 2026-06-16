import 'package:flutter/material.dart';
import 'package:pemrograman_mobile_project/models/song.dart';
import 'package:pemrograman_mobile_project/widgets/background.dart';
import 'package:pemrograman_mobile_project/screens/player_screen.dart';

class FavoriteScreen extends StatefulWidget {
  final AppState state;
  const FavoriteScreen({super.key, required this.state});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showToast = false;
  String _toastMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  void _showSuccessToast(String message) {
    setState(() {
      _toastMessage = message;
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showToast = false;
        });
      }
    });
  }

  void _showDeleteDialog(Song song) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Hapus Favorit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Apakah Anda Ingin Menghapus Lagu ${song.title} dari Favorite?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Tidak Button (Red)
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          child: const Text('Tidak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Ya Button (Green)
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.state.removeFromFavorite(song);
                            });
                            Navigator.pop(context);
                            _showSuccessToast('Musik Berhasil di Hapus!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade500,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          child: const Text('Ya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSongOptions(Song song) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Details
                ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: song.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.music_note, color: Colors.white),
                  ),
                  title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(song.artist),
                ),
                const Divider(),
                // Delete from playlist Option
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Hapus dari playlist', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteDialog(song);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final favoriteList = state.favorites.where((song) {
      return song.title.toLowerCase().contains(_searchQuery) ||
          song.artist.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          // Background with music kid illustrations
          NadaCilikBackground(
            footerType: 'music',
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
                          'Favorit',
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
                  const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Apa lagu yang ingin anda cari?',
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // List content
                  Expanded(
                    child: favoriteList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_border_rounded,
                                  size: 72,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Anda belum menambahkan lagu ke favorit.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: favoriteList.length,
                            itemBuilder: (context, index) {
                              final song = favoriteList[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                margin: const EdgeInsets.only(bottom: 12.0),
                                elevation: 2,
                                child: ListTile(
                                  leading: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: song.color,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.music_note, color: Colors.white),
                                  ),
                                  title: Text(
                                    song.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(song.artist),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.more_horiz),
                                    onPressed: () => _showSongOptions(song),
                                  ),
                                  onTap: () {
                                    state.playSong(song);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PlayerScreen(state: state)),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          
          // Toast Notification Overlay
          if (_showToast)
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _showToast ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.red.shade600, // Red theme from mockup
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          _toastMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
