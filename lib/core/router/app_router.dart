import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:trashcash_app/core/router/app_route_constans.dart';
import 'package:trashcash_app/screens/credit/credit_screen.dart';
import 'package:trashcash_app/screens/dashboard/admin/dashboard_admin_screen.dart';
import 'package:trashcash_app/screens/debit/debit_screen.dart';
import 'package:trashcash_app/screens/list_customer/list_customer_screen.dart';
import 'package:trashcash_app/screens/login/login_screen.dart';
import 'package:trashcash_app/screens/register_user/register_user_screen.dart';
import 'package:trashcash_app/screens/waste_type/waste_type_screen.dart';

@injectable
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
            builder: (context, state) {
              final iduser = state.queryParams['idUser'] as String;
              return DashboardAdminScreen(
                userId: iduser,
              );
            }),
        GoRoute(
          name: AppRouteConstants.wasteTypeRouteName,
          path: AppRouteConstants.wasteTypeRouteName,
          builder: (context, state) {
            return const WasteTypeScreen();
          }
        ),
        GoRoute(
            name: AppRouteConstants.listCustomerRouteName,
            path: AppRouteConstants.listCustomerRouteName,
            builder: (context, state) {
              return const ListCustomerScreen();
            }
        ),
        GoRoute(
            name: AppRouteConstants.debitRouteName,
            path: AppRouteConstants.debitRouteName,
            builder: (context, state) {
              return const DebitScreen();
            }
        ),
        GoRoute(
            name: AppRouteConstants.creditRouteName,
            path: AppRouteConstants.creditRouteName,
            builder: (context, state) {
              return const CreditScreen();
            }
        ),
      ],
    );
    return router;
  }
}
