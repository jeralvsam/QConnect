import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qaltrix/signup.dart';
import 'aboutus.dart';
import 'editprofile.dart';
import 'helpandsupport.dart';
import 'login.dart';
import 'privacy.dart';
import 'termsofservice.dart';
import 'homepage.dart';
import 'settings.dart';
import 'reportcrime.dart';
import 'password.dart';

// Global theme controller
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://vmqehujlieflzaxjovho.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZtcWVodWpsaWVmbHpheGpvdmhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4MDE1MjQsImV4cCI6MjA3MjM3NzUyNH0.M0bM7MFx6pQJGNc6AKk7M_1aVDL-BAMI4a661fhHiAU',
  );

  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Connect App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[900],
          ),
          themeMode: mode,
          home: PermissionsHandler(
            isLoggedIn: isLoggedIn,
          ), // Directly start here
          routes: {
            '/settings': (context) => const SettingsScreen(),
            '/editprofile': (context) => const EditProfilePage(),
            '/crimereport': (context) => const ReportCrimePage(),
            '/changepass': (context) => const ChangePasswordPage(),
            '/help': (context) => const HelpAndSupportPage(),
            '/about': (context) => const AboutUsPage(),
            '/terms': (context) => const TermsOfServicePage(),
            '/privacy': (context) => const PrivacyPolicyPage(),
            '/logout': (context) => const LogoutPage(),
            '/signup': (context) => const SignUpPage(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}

// ---------------- Permissions Handler ----------------
class PermissionsHandler extends StatefulWidget {
  final bool isLoggedIn;
  const PermissionsHandler({super.key, required this.isLoggedIn});

  @override
  State<PermissionsHandler> createState() => _PermissionsHandlerState();
}

class _PermissionsHandlerState extends State<PermissionsHandler> {
  bool _permissionsChecked = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.sms,
      Permission.phone,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Permissions Required'),
          content: const Text(
            'This app needs location, SMS, and phone permissions for emergency features. Please allow them.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _permissionsChecked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionsChecked) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return widget.isLoggedIn ? const HomeScreen() : const LoginPage();
  }
}

// ---------------- Logout Page ----------------
class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    _logout(context);
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
