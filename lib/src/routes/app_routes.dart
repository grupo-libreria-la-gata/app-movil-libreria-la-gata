import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/auth/email_verification_page.dart';
import '../presentation/pages/products/products_page.dart';
import '../presentation/pages/products/product_detail_page.dart';
import '../presentation/pages/sales/new_sale_page.dart';
import '../presentation/pages/sales/sales_history_page.dart';
import '../presentation/pages/customers/customers_page.dart';
import '../presentation/pages/inventory/inventory_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/admin/admin_page.dart';
import '../presentation/pages/settings/settings_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  
  // Productos
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String newProduct = '/products/new';
  static const String editProduct = '/products/:id/edit';
  
  // Ventas
  static const String sales = '/sales';
  static const String newSale = '/sales/new';
  static const String saleDetail = '/sales/:id';
  
  // Inventario
  static const String inventory = '/inventory';
  
  // Clientes
  static const String customers = '/customers';
  static const String customerDetail = '/customers/:id';
  
  // Reportes
  static const String reports = '/reports';
  
  // Usuarios
  static const String users = '/users';
  static const String userDetail = '/users/:id';
  
  // Configuración
  static const String settings = '/settings';
  static const String profile = '/profile';
  
  // Administración
  static const String admin = '/admin';

  static GoRouter get router => GoRouter(
    initialLocation: splash,
    routes: [
      // Página de splash
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Dashboard principal
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      
      // Autenticación
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
      
      // Productos
      GoRoute(
        path: products,
        name: 'products',
        builder: (context, state) => const ProductsPage(),
      ),
      GoRoute(
        path: newProduct,
        name: 'newProduct',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Nuevo Producto - En desarrollo'),
          ),
        ),
      ),
      GoRoute(
        path: productDetail,
        name: 'productDetail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailPage(productId: productId);
        },
      ),
      GoRoute(
        path: editProduct,
        name: 'editProduct',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Editar Producto $productId'),
            ),
            body: Center(
              child: Text('Editar producto $productId - En desarrollo'),
            ),
          );
        },
      ),
      
      // Ventas
      GoRoute(
        path: newSale,
        name: 'newSale',
        builder: (context, state) => const NewSalePage(),
      ),
      GoRoute(
        path: sales,
        name: 'sales',
        builder: (context, state) => const SalesHistoryPage(),
      ),
      GoRoute(
        path: saleDetail,
        name: 'saleDetail',
        builder: (context, state) {
          final saleId = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Venta $saleId'),
            ),
            body: Center(
              child: Text('Detalle de venta $saleId - En desarrollo'),
            ),
          );
        },
      ),
      
      // Inventario
      GoRoute(
        path: inventory,
        name: 'inventory',
        builder: (context, state) => const InventoryPage(),
      ),
      
      // Clientes
      GoRoute(
        path: customers,
        name: 'customers',
        builder: (context, state) => const CustomersPage(),
      ),
      GoRoute(
        path: customerDetail,
        name: 'customerDetail',
        builder: (context, state) {
          final customerId = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Cliente $customerId'),
            ),
            body: Center(
              child: Text('Detalle del cliente $customerId - En desarrollo'),
            ),
          );
        },
      ),
      
      // Reportes
      GoRoute(
        path: reports,
        name: 'reports',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Reportes y Estadísticas - En desarrollo'),
          ),
        ),
      ),
      
      // Usuarios
      GoRoute(
        path: users,
        name: 'users',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Gestión de Usuarios - En desarrollo'),
          ),
        ),
      ),
      GoRoute(
        path: userDetail,
        name: 'userDetail',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Usuario $userId'),
            ),
            body: Center(
              child: Text('Detalle del usuario $userId - En desarrollo'),
            ),
          );
        },
      ),
      
      // Configuración
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      
      // Administración
      GoRoute(
        path: admin,
        name: 'admin',
        builder: (context, state) => const AdminPage(),
      ),
      
      // Perfil
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
