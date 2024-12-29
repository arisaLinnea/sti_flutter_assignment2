import 'package:flutter/material.dart';
import 'package:parking_admin/providers/auth_provider.dart';
import 'package:parking_admin/providers/parking_provider.dart';
import 'package:parking_admin/providers/theme_provider.dart';
import 'package:parking_admin/routes/router.dart';
import 'package:parking_admin/style/theme.dart';
import 'package:parking_admin/views/login_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthState()),
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => ParkingProvider())
    ],
    child: const FindMeASpotAdmin(),
  ));
}

class FindMeASpotAdmin extends StatelessWidget {
  const FindMeASpotAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthViewSwitcher(),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthState>().status;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: authStatus == AuthStatus.authenticated
            ? const NavRailView()
            : const LoginView(),
      ),
    );
  }
}

class NavRailView extends StatefulWidget {
  const NavRailView({super.key});

  @override
  State<NavRailView> createState() => _NavRailViewState();
}

class _NavRailViewState extends State<NavRailView> {
  // final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: 'Find Me A Spot Admin',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
        );
      },
    );
  }
}
