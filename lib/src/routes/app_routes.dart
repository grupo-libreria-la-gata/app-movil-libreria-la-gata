import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/reserves/reserves_page.dart';
import '../presentation/pages/reserves/reserve_detail_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/auth/email_verification_page.dart';
import '../presentation/pages/birds/birds_page.dart';
import '../presentation/pages/birds/bird_detail_page.dart';
import '../presentation/pages/bookings/bookings_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/events/events_page.dart';
import '../presentation/pages/education/education_page.dart';
// import '../presentation/pages/bookings/create_booking_page.dart';
// import '../presentation/pages/profile/profile_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String reserves = '/reserves';
  static const String reserveDetail = '/reserves/:id';
  static const String birds = '/birds';
  static const String birdDetail = '/birds/:id';
  static const String bookings = '/bookings';
  static const String createBooking = '/bookings/create';
  static const String profile = '/profile';
  static const String events = '/events';
  static const String education = '/education';

  static GoRouter get router => GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: reserves,
        name: 'reserves',
        builder: (context, state) => const ReservesPage(),
      ),
      GoRoute(
        path: reserveDetail,
        name: 'reserveDetail',
        builder: (context, state) {
          final reserveId = state.pathParameters['id']!;
          return ReserveDetailPage(reserveId: reserveId);
        },
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: emailVerification,
        name: 'emailVerification',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? 'usuario@ejemplo.com';
          return EmailVerificationPage(email: email);
        },
      ),
      // GoRoute(
      //   path: register,
      //   name: 'register',
      //   builder: (context, state) => const RegisterPage(),
      // ),
      // GoRoute(
      //   path: reserves,
      //   name: 'reserves',
      //   builder: (context, state) => const ReservesPage(),
      // ),
      // GoRoute(
      //   path: reserveDetail,
      //   name: 'reserveDetail',
      //   builder: (context, state) {
      //     final reserveId = state.pathParameters['id']!;
      //     return ReserveDetailPage(reserveId: reserveId);
      //   },
      // ),
      GoRoute(
        path: birds,
        name: 'birds',
        builder: (context, state) => const BirdsPage(),
      ),
      GoRoute(
        path: birdDetail,
        name: 'birdDetail',
        builder: (context, state) {
          final birdId = state.pathParameters['id']!;
          return BirdDetailPage(birdId: birdId);
        },
      ),
      GoRoute(
        path: bookings,
        name: 'bookings',
        builder: (context, state) => const BookingsPage(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: events,
        name: 'events',
        builder: (context, state) => const EventsPage(),
      ),
      GoRoute(
        path: education,
        name: 'education',
        builder: (context, state) => const EducationPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La página que buscas no existe',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
