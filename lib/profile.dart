import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  bool _isLoading = true;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _fetchUserProfile();
  }

  Future<void> _loadProfileImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile_pic.png');
    if (await file.exists()) {
      setState(() => _profileImage = file);
    } else {
      setState(() => _profileImage = null);
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      final response = await supabase
          .from('users')
          .select('name, email')
          .eq('id', user.id)
          .maybeSingle();

      setState(() {
        name = response != null ? response['name'] as String? : 'No Name';
        email = response != null ? response['email'] as String? : user.email;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.grey[50]!;
    final cardColor = widget.isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = widget.isDarkMode
        ? Colors.white70
        : Colors.grey[600]!;
    final defaultIconColor = widget.isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;
    final defaultIconBg = widget.isDarkMode
        ? Colors.grey[800]!
        : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: defaultIconBg,
                    child: _profileImage != null
                        ? ClipOval(
                            child: Image.file(
                              _profileImage!,
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.person, size: 64, color: defaultIconColor),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text(
                        name ?? 'No Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email ?? 'No Email',
                        style: TextStyle(fontSize: 16, color: subtitleColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildProfileOption(
                  title: 'Edit Profile',
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () async {
                    final updated = await Navigator.pushNamed(
                      context,
                      '/editprofile',
                      arguments: {
                        'isDarkMode': widget.isDarkMode,
                        'toggleTheme': widget.toggleTheme,
                      },
                    );
                    if (updated == true) {
                      await _fetchUserProfile();
                      await _loadProfileImage();
                    }
                  },
                  isDarkMode: widget.isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildProfileOption(
                  title: 'Terms Of Services',
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/terms',
                      arguments: {
                        'isDarkMode': widget.isDarkMode,
                        'toggleTheme': widget.toggleTheme,
                      },
                    );
                  },
                  isDarkMode: widget.isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildProfileOption(
                  title: 'Help & Support',
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/help',
                      arguments: {
                        'isDarkMode': widget.isDarkMode,
                        'toggleTheme': widget.toggleTheme,
                      },
                    );
                  },
                  isDarkMode: widget.isDarkMode,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => _showLogoutConfirmation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Confirm Logout',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white70 : Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Supabase.instance.client.auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Logout', style: TextStyle(color: Colors.red.shade500)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required String title,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white70 : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
