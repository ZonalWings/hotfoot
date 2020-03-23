import 'package:flutter/material.dart';
import 'package:hotfoot/features/login/presentation/ui/screen/login_screen.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/screen/home_screen.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_state.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:hotfoot/src/screens/settings_screen.dart';
import 'package:hotfoot/src/screens/request_run_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/login/presentation/ui/screen/splash_screen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NavigationHomeBloc>(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: BlocBuilder<NavigationAuthBloc, NavigationAuthState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            } else if (state is Authenticated) {
              print('Authenticated');
              return BlocBuilder<NavigationScreenBloc, NavigationScreenState>(
                  builder: (context, state) {
                if (state is Home) {
                  return HomeScreen();
                } else if (state is RequestRun) {
                  return RequestRunScreen();
                } else if (state is Settings) {
                  return SettingsScreen();
                } else if (state is Login) {
                  return LoginScreen();
                }
                return Container();
              });
            } else if (state is Unauthenticated) {
              print('Not logged in');
              return LoginScreen();
            }
            print('Navigation Auth State: $state');
            return SplashScreen();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      // TODO: Delete all cached images.
      print('DELETED ALL CACHED IMAGES');
    }
  }


}
