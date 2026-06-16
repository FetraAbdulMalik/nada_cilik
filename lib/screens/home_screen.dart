import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pemrograman_mobile_project/models/song.dart';
import 'package:pemrograman_mobile_project/widgets/background.dart';
import 'package:pemrograman_mobile_project/screens/favorite_screen.dart';
import 'package:pemrograman_mobile_project/screens/sleep_screen.dart';
import 'package:pemrograman_mobile_project/screens/education_screen.dart';
import 'package:pemrograman_mobile_project/screens/music_screen.dart';
import 'package:pemrograman_mobile_project/screens/player_screen.dart';
import 'package:pemrograman_mobile_project/screens/edit_profile_screen.dart';
import 'package:pemrograman_mobile_project/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppState state;
  const HomeScreen({super.key, required this.state});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showProfileDropdown = false;

  void _navigateTo(Widget screen) {
    setState(() {
      _showProfileDropdown = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_showProfileDropdown) {
            setState(() {
              _showProfileDropdown = false;
            });
          }
        },
        child: Stack(
          children: [
            NadaCilikBackground(
              footerType: 'book',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat datang, ${state.username}!',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Nada Cilik',
                                style: GoogleFonts.pottaOne(
                                  textStyle: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Profile Avatar Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showProfileDropdown = !_showProfileDropdown;
                              });
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Grid Menu Buttons (2x2)
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Favorit Button
                          _buildGridItem(
                            title: 'Favorit',
                            icon: Icons.star_rounded,
                            iconColor: const Color(0xFF4CAF50),
                            backgroundColor: const Color(0xFFE8F5E9),
                            onTap: () => _navigateTo(FavoriteScreen(state: state)),
                          ),
                          // Tidur Button
                          _buildGridItem(
                            title: 'Tidur',
                            icon: Icons.brightness_3_rounded,
                            iconColor: const Color(0xFF9C27B0),
                            backgroundColor: const Color(0xFFF3E5F5),
                            onTap: () => _navigateTo(SleepScreen(state: state)),
                          ),
                          // Edukasi Button
                          _buildGridItem(
                            title: 'Edukasi',
                            icon: Icons.menu_book_rounded,
                            iconColor: const Color(0xFFFF9800),
                            backgroundColor: const Color(0xFFFFF3E0),
                            onTap: () => _navigateTo(EducationScreen(state: state)),
                          ),
                          // Musik Button
                          _buildGridItem(
                            title: 'Musik',
                            icon: Icons.music_note_rounded,
                            iconColor: const Color(0xFF2196F3),
                            backgroundColor: const Color(0xFFE3F2FD),
                            onTap: () => _navigateTo(MusicScreen(state: state)),
                          ),
                        ],
                      ),
                    ),

                    // Featured Song Card (Purple)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withAlpha(76),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lagu Rekomendasi Hari Ini',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(51),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.album_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Timun Mas',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Baby Kids • 4:55',
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(204),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Play Button
                              GestureDetector(
                                onTap: () {
                                  final timunMas = state.songs.firstWhere((s) => s.id == '1');
                                  state.playSong(timunMas);
                                  _navigateTo(PlayerScreen(state: state));
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Color(0xFF5E35B1),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Copyright Footer
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '© 2026 Nada Cilik',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Dropdown Popover Overlay
            if (_showProfileDropdown)
              Positioned(
                top: 75,
                right: 20,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Info Row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(Icons.person, color: Colors.blueAccent),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    state.email,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        // My Profile Option
                        ListTile(
                          leading: const Icon(Icons.account_circle, color: Colors.blueAccent),
                          title: const Text('My Profile'),
                          trailing: const Icon(Icons.chevron_right, size: 20),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          onTap: () => _navigateTo(EditProfileScreen(state: state)),
                        ),
                        // Log Out Option
                        ListTile(
                          leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                          title: const Text('Log Out'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            state.logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(state: state),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
