import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/main_page.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'injection_container.dart' as di;

class StreamXtreamApp extends StatelessWidget {
  const StreamXtreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => di.sl<ProfileBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'StreamXtream',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStatus.initial ||
                        state.status == AuthStatus.loading) {
                      return const Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Loading...'),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    if (state.status == AuthStatus.authenticated) {
                      return const MainPage();
                    }
                    
                    return const LoginPage();
                  },
                ),
              );
            case '/main':
              return MaterialPageRoute(
                builder: (_) => const MainPage(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStatus.authenticated) {
                      return const MainPage();
                    }
                    return const LoginPage();
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
