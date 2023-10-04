
import 'package:go_router/go_router.dart';
import 'package:trashcash_app/core/router/app_route_constans.dart';
import 'package:trashcash_app/screens/dashboard/admin/dashboard_admin_screen.dart';
import 'package:trashcash_app/screens/login/login_screen.dart';
import 'package:trashcash_app/screens/register_user/register_user_screen.dart';

class AppRouter {
  static GoRouter returnRouter() {
    GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          name: AppRouteConstants.loginRouteName,
          path: '/',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: AppRouteConstants.registerUserRouteName,
          path: AppRouteConstants.registerUserRouteName,
          builder: (context, state) => const RegisterUserScreen(),
        ),
        GoRoute(
          name: AppRouteConstants.dashboardAdminRouteName,
          path: AppRouteConstants.dashboardAdminRouteName,
          builder: (context, state) => const DashboardAdminScreen(),
        )
      ],
    );
    return router;
  }
}
