import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'helpline.dart';
import 'profile.dart';
import 'sos_service.dart'; // <-- Added for SOS feature

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;
  int _selectedIndex = 0; // Tracks current tab

  // Supabase client
  final SupabaseClient supabase = Supabase.instance.client;

  // Recent reports
  List<Map<String, dynamic>> recentReports = [];
  bool isReportsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTheme(); // Load saved theme on startup
    fetchRecentReports(); // Load recent reports from Supabase
  }

  // Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Save theme to SharedPreferences
  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    _saveTheme(isDarkMode); // Persist theme
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fetch recent reports from Supabase
  Future<void> fetchRecentReports() async {
    setState(() {
      isReportsLoading = true;
    });

    try {
      final List<Map<String, dynamic>> response = await supabase
          .from('crime_reports')
          .select('*')
          .order('created_at', ascending: false)
          .limit(10);

      setState(() {
        recentReports = response;
        isReportsLoading = false;
      });
    } catch (error) {
      print('Error fetching reports: $error');
      setState(() {
        recentReports = [];
        isReportsLoading = false;
      });
    }
  }

  // Map status to colors
  Color getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.red;
      case 'Under Review':
        return Colors.orange;
      case 'Investigation':
        return Colors.blue;
      case 'Action Taken':
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Generate title from subject
  String generateTitle(String? subject) {
    if (subject == null || subject.trim().isEmpty) return 'No Title';

    const keywords = [
      'robbery',
      'theft',
      'accident',
      'kidnapp',
      'murder',
      'cyber',
      'assault',
      'fraud',
      'harassment',
      'vandalism',
      'arson',
      'burglary',
      'stalking',
      'hacking',
      'scam',
      'abuse',
      'fight',
      'drugs',
      'shooting',
      'fraud',
      'extortion',
      'blackmail',
    ];

    final lower = subject.toLowerCase();
    for (final word in keywords) {
      if (lower.contains(word))
        return word[0].toUpperCase() + word.substring(1);
    }

    // Use first 3 words if no keyword found
    final words = subject.trim().split(RegExp(r'\s+'));
    return words.take(3).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? Colors.black : const Color(0xFFF9FAFB);
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final iconColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 8, 8, 8)
            : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: iconColor,
          ),
          onPressed: toggleTheme,
        ),
        title: Text(
          'Connect',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: iconColor),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
                arguments: {
                  'isDarkMode': isDarkMode,
                  'toggleTheme': toggleTheme,
                },
              );
            },
          ),
        ],
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _homeContent();
      case 1:
        return HelpPage(isDarkMode: isDarkMode, toggleTheme: toggleTheme);
      case 2:
        return ProfilePage(isDarkMode: isDarkMode, toggleTheme: toggleTheme);
      default:
        return _homeContent();
    }
  }

  Widget _homeContent() {
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSosCard(),
            const SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.edit_document,
              iconColor: const Color(0xFF6366F1),
              title: 'Report a Crime',
              subtitle: 'File an incident report securely',
              onTap: () async {
                // Navigate to report page and refresh after return
                await Navigator.pushNamed(
                  context,
                  '/crimereport',
                  arguments: {
                    'isDarkMode': isDarkMode,
                    'toggleTheme': toggleTheme,
                  },
                );

                // Refresh recent reports automatically
                fetchRecentReports();
              },
              cardColor: cardColor,
              titleColor: textColor,
              subtitleColor: subtitleColor,
            ),
            const SizedBox(height: 16),
            _buildSafetyTipCard(cardColor, textColor, subtitleColor),
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildRecentActivityCard(cardColor, textColor, subtitleColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSosCard() {
    return GestureDetector(
      onTap: () async {
        await SOSService.triggerSOS(context, isDarkMode: isDarkMode);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Emergency SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap here to send an instant alert',
                  style: TextStyle(color: Color(0xFFFECACA), fontSize: 14),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color cardColor,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDarkMode
            ? BorderSide.none
            : BorderSide(color: Colors.grey[200]!),
      ),
      color: cardColor,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 24),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: subtitleColor),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSafetyTipCard(
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDarkMode
            ? BorderSide.none
            : BorderSide(color: Colors.grey[200]!),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.yellow[700], size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety Tip of the Day',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Always let someone know your plans and where you are going.',
                    style: TextStyle(color: subtitleColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    if (isReportsLoading)
      return const Center(child: CircularProgressIndicator());
    if (recentReports.isEmpty)
      return Center(
        child: Text('No recent reports', style: TextStyle(color: textColor)),
      );

    return Column(
      children: recentReports.map((report) {
        final subject = report['subject'] as String?;
        final title = generateTitle(subject);
        final id = report['id']?.toString() ?? '';
        final date = report['created_at'] != null
            ? DateTime.parse(
                report['created_at'],
              ).toLocal().toString().split('.')[0]
            : '';
        final status = report['status'] as String? ?? 'Pending';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _activityItem(
            title: '$title',
            subtitle: 'Reported on $date',
            status: status,
            statusColor: getStatusColor(status),
            cardColor: cardColor,
            titleColor: textColor,
            subtitleColor: subtitleColor,
          ),
        );
      }).toList(),
    );
  }

  Widget _activityItem({
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required Color cardColor,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDarkMode
            ? BorderSide.none
            : BorderSide(color: Colors.grey[200]!),
      ),
      elevation: 0,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(30),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? Colors.blue
                      : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.call,
                  color: _selectedIndex == 1
                      ? Colors.blue
                      : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 2
                      ? Colors.blue
                      : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                ),
                onPressed: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
