import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'features/admin/providers/admin_provider.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/screens/admin_login_screen.dart';
import 'features/admin/screens/admin_shell.dart';
import 'firebase_options.dart'; // بيتولد من أمر: flutterfire configure
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FindMyMedApp());
}

class FindMyMedApp extends StatelessWidget {
  const FindMyMedApp({super.key});

  @override
  Widget build(BuildContext context) {
    // الـ Provider فوق MaterialApp عشان كل الشاشات (حتى اللي بتتفتح بـ Navigator.push) تشوفه
    return ChangeNotifierProvider(
      create: (_) => AdminProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'فين دوائي؟',
        theme: AppTheme.light,
        locale: const Locale('ar'), // يخلي الاتجاه RTL تلقائي
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AuthGate(),
      ),
    );
  }
}

/// بوابة التوجيه: مش مسجل → Login | admin → لوحة الإدارة | غير كده → باقي الفريق
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authState,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
        }
        final user = snap.data;
        if (user == null) return const AdminLoginScreen();

        return FutureBuilder<String?>(
          future: AuthService.instance.getRole(user.uid),
          builder: (context, roleSnap) {
            if (!roleSnap.hasData && roleSnap.connectionState != ConnectionState.done) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
            }
            switch (roleSnap.data) {
              case UserRole.admin:
                return const AdminShell();
              case UserRole.pharmacist:
              // TODO: ضيف هنا PharmacistDashboard بتاع الفرد الثاني
                return const _Placeholder('لوحة الصيدلي');
              default:
              // TODO: ضيف هنا HomeScreen بتاع المريض (الفرد الأول)
                return const _Placeholder('الشاشة الرئيسية للمريض');
            }
          },
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title), actions: [
      IconButton(
          onPressed: () => AuthService.instance.signOut(),
          icon: const Icon(Icons.logout))
    ]),
    body: Center(child: Text(title)),
  );
}