import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

late bool isDarkMode;

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  late VoidCallback toggleTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    isDarkMode = args['isDarkMode'];
    toggleTheme = args['toggleTheme'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF010101) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF010101) : Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 24),

          // Account Section
          _SectionHeader('ACCOUNT', isDarkMode: isDarkMode),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/editprofile',
                arguments: {
                  'isDarkMode': isDarkMode,
                  "toggleTheme": toggleTheme,
                },
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/changepass',
                arguments: {
                  'isDarkMode': isDarkMode,
                  'toggleTheme': toggleTheme,
                },
              );
            },
          ),
          const SizedBox(height: 32),

          // Preferences Section
          _SectionHeader('PREFERENCES', isDarkMode: isDarkMode),
          const SizedBox(height: 8),
          _buildNotificationTile(),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            onTap: () {},
          ),
          const SizedBox(height: 32),

          // More Section
          _SectionHeader('MORE', isDarkMode: isDarkMode),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/help',
                arguments: {
                  'isDarkMode': isDarkMode,
                  'toggleTheme': toggleTheme,
                },
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/about',
                arguments: {
                  'isDarkMode': isDarkMode,
                  'toggleTheme': toggleTheme,
                },
              );
            },
          ),
          const SizedBox(height: 32),

          // Legal Section
          _SectionHeader('LEGAL', isDarkMode: isDarkMode),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.gavel_outlined,
            title: 'Terms of Service',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/terms',
                arguments: {
                  'isDarkMode': isDarkMode,
                  'toggleTheme': toggleTheme,
                },
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.shield_outlined,
            title: 'Privacy Policy',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/privacy',
                arguments: {
                  'isDarkMode': isDarkMode,
                  'toggleTheme': toggleTheme,
                },
              );
            },
          ),
          const SizedBox(height: 40),

          // Log Out Button
          _buildLogoutButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDarkMode ? Colors.white70 : Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildNotificationTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.notifications_none_outlined,
        color: isDarkMode ? Colors.white70 : Colors.black54,
      ),
      title: Text(
        'Notifications',
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      trailing: Switch(
        value: _notificationsEnabled,
        onChanged: (bool value) {
          setState(() {
            _notificationsEnabled = value;
          });
        },
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          _showLogoutConfirmation(context);
        },
        child: const Text(
          'Log Out',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          title: Text(
            'Confirm Logout',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                ); // Go to login
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red.shade500),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  const _SectionHeader(this.title, {required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: isDarkMode ? Colors.grey[400] : Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
}
