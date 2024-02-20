import 'package:go_router/go_router.dart';
import 'package:saved/account/form/view/account_form_page.dart';
import 'package:saved/account/list/view/view.dart';
import 'package:saved/company/company.dart';
import 'package:saved/customer/form/customer_form.dart';
import 'package:saved/customer/list/view/view.dart';
import 'package:saved/dashboard/dashboard.dart';
import 'package:saved/daybook/detail/form/view/daybook_detail_form_page.dart';
import 'package:saved/daybook/form/view/daybook_form_page.dart';
import 'package:saved/daybook/list/view/daybook_list_page.dart';
import 'package:saved/login/view/login_page.dart';
import 'package:saved/app_provider.dart';
import 'package:saved/material/form/view/view.dart';
import 'package:saved/material/list/view/material_list_page.dart';
import 'package:saved/my_profile/view/my_profile_page.dart';
import 'package:saved/product/form/view/view.dart';
import 'package:saved/product/list/view/product_list_page.dart';
import 'package:saved/register/register.dart';
import 'package:saved/supplier/form/view/view.dart';
import 'package:saved/supplier/list/view/view.dart';
import 'package:saved/user/company/user_company.dart';
import 'package:saved/user/form/user_form.dart';
import 'package:saved/user/list/user_list.dart';
import 'package:saved/widgets/error_layout.dart';
import 'package:saved/widgets/logout_layout.dart';

class RouteUri {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String daybook = '/daybook';
  static const String user = '/user';
  static const String userForm = '/user-form';
  static const String userCompanyForn = '/user-company-form';
  static const String daybookForm = '/daybook-form';
  static const String daybookDetailForm = '/daybook-detail-from';
  static const String company = '/company';
  static const String myProfile = '/my-profile';
  static const String logout = '/logout';
  static const String error404 = '/404';
  static const String login = '/login';
  static const String register = '/register';
  static const String crud = '/crud';
  static const String crudDetail = '/crud-detail';
  static const String account = '/account';
  static const String accountFrom = '/account-form';
  static const String supplier = '/supplier';
  static const String supplierFrom = '/supplier-form';
  static const String customer = '/customer';
  static const String customerFrom = '/customer-form';
  static const String material = '/material';
  static const String materialFrom = '/material-form';
  static const String product = '/product';
  static const String productFrom = '/product-form';
}

const List<String> unrestrictedRoutes = [
  RouteUri.error404,
  RouteUri.logout,
  RouteUri.login, // Remove this line for actual authentication flow.
  RouteUri.register, // Remove this line for actual authentication flow.
];

const List<String> publicRoutes = [
  // RouteUri.login, // Enable this line for actual authentication flow.
  // RouteUri.register, // Enable this line for actual authentication flow.
];

GoRouter appRouter(AppProvider provider) {
  return GoRouter(
    initialLocation: RouteUri.home,
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const ErrorScreen(),
    ),
    routes: [
      GoRoute(
        path: RouteUri.home,
        redirect: (context, state) => RouteUri.dashboard,
      ),
      GoRoute(
        path: RouteUri.dashboard,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const DashboardPage(),
        ),
      ),
      GoRoute(
        path: RouteUri.daybook,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const DaybookListPage(),
        ),
      ),
      GoRoute(
        path: RouteUri.daybookForm,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: DaybookFormPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.daybookDetailForm,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: DaybookDetailFormPage(
            id: state.queryParameters['id'] ?? '',
            daybook: state.queryParameters['daybook'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.company,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: CompanyPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.myProfile,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MyProfilePage(),
        ),
      ),
      GoRoute(
        path: RouteUri.logout,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LogoutLayout(),
        ),
      ),
      GoRoute(
        path: RouteUri.login,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: RouteUri.register,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterPage(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.user,
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const UserPage(),
          );
        },
      ),
      GoRoute(
        path: RouteUri.userForm,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: UserFormPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.userCompanyForn,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: UserCompanyPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.account,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const AccountPage(),
        ),
      ),
      GoRoute(
        path: RouteUri.accountFrom,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: AccountFormPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.supplier,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const SupplierPage(),
        ),
      ),
      GoRoute(
        path: RouteUri.supplierFrom,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: SupplierFormPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.customer,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const CustomerPage(),
        ),
      ),
      GoRoute(
        path: RouteUri.customerFrom,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: CustomerFormPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.material,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MaterialListPage(),
        ),
      ),
      GoRoute(
        path: RouteUri.materialFrom,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: MaterialFormPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteUri.product,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const ProductPage(),
        ),
      ),
      GoRoute(
        path: RouteUri.productFrom,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: ProductFormPage(
            id: state.queryParameters['id'] ?? '',
          ),
        ),
      ),
    ],
    redirect: (context, state) async {
      // final provider = context.read<AppProvider>();
      if (state.matchedLocation == RouteUri.dashboard) {
        await Future.wait([
          provider.clearPrevious(),
          provider.setCurrent(state.matchedLocation),
        ]);
      } else {
        var query = "";
        state.queryParameters.forEach((key, value) {
          if (query == "") {
            query += '?';
          } else {
            query += '&';
          }
          query += '$key=$value';
        });
        String current = state.matchedLocation + query;
        String previous = provider.current;
        // print("provider.previous ${provider.previous}");
        await provider.setCurrent(current);
        await provider.setPrevious(previous);
      }
      if (unrestrictedRoutes.contains(state.matchedLocation)) {
        return null;
      } else if (publicRoutes.contains(state.matchedLocation)) {
        // Is public route.
        if (provider.isUserLoggedIn()) {
          // User is logged in, redirect to home page.
          return RouteUri.home;
        }
      } else {
        // Not public route.
        if (!provider.isUserLoggedIn()) {
          // User is not logged in, redirect to login page.
          return RouteUri.login;
        }
      }

      return null;
    },
  );
}
