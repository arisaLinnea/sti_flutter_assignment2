import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_user/blocs/auth/auth_bloc.dart';
import 'package:parking_user/blocs/vehicle/vehicle_bloc.dart';
import 'package:parking_user/providers/theme_provider.dart';
import 'package:parking_user/routes/router.dart';
import 'package:parking_user/style/theme.dart';
import 'package:parking_user/views/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_client/shared_client.dart';

// void main() {
//   runApp(const FindMeASpot());
// }

void main() {
  // runApp(MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(create: (_) => AuthState()),
  //     ChangeNotifierProvider(create: (_) => ThemeNotifier()),
  //     ChangeNotifierProvider(create: (_) => VehicleListProvider()),
  //     ChangeNotifierProvider(create: (_) => ParkingProvider())
  //   ],
  //   child: const FindMeASpot(),
  // ));
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AuthBloc(userLoginRepository: UserLoginRepository())),
        BlocProvider(
            create: (context) => VehicleBloc(
                vehicleRepository: VehicleRepository(),
                authBloc: context.read<AuthBloc>())),
        BlocProvider(
            create: (context) =>
                ParkingLotBloc(parkingLotRepository: ParkingLotRepository())),
        BlocProvider(
            create: (context) =>
                ParkingBloc(parkingRepository: ParkingRepository())),
      ],
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(),
        child: const FindMeASpot(),
      )
      // MultiProvider(
      //   providers: [
      //     // ChangeNotifierProvider(create: (_) => AuthState()),
      //     ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      //     // ChangeNotifierProvider(create: (_) => VehicleListProvider()),
      //     // ChangeNotifierProvider(create: (_) => ParkingProvider())
      //   ],
      //   child: const FindMeASpot(),
      // ),
      ));
}

class FindMeASpot extends StatelessWidget {
  const FindMeASpot({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const AuthViewSwitcher(),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});
  @override
  Widget build(BuildContext context) {
    // context.read<AuthBloc>().add(AuthCheckEvent());
    //final authStatus = context.watch<AuthState>().status;

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
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticatedState) {
            return const UserView();
          } else {
            return const LoginView();
          }
        },
        // authStatus == AuthStatus.authenticated
        //     ? const UserView()
        //     : const LoginView(),
      ),
    ));
  }
}

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  // final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: 'Find Me A Spot',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
        );
      },
    );
  }
}
