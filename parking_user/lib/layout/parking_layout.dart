import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parking_user/providers/auth_state.dart';
import 'package:parking_user/providers/theme_provider.dart';
import 'package:parking_user/routes/navigation.dart';
import 'package:provider/provider.dart';

class ParkingLayout extends StatelessWidget {
  const ParkingLayout({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ParkingLayout'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
        //appBar finns på pages
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Find Me A Spot'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => context.read<AuthState>().logout(),
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                ThemeNotifier themeNotifier =
                    Provider.of<ThemeNotifier>(context, listen: false);
                if (themeNotifier.themeMode == ThemeMode.light) {
                  themeNotifier.setTheme(ThemeMode.dark);
                } else {
                  themeNotifier.setTheme(ThemeMode.light);
                }
              },
            )
          ],
        ),
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          indicatorColor: Theme.of(context).primaryColor,
          destinations: navbar,
        ),
      );
}
