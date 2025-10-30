import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/auth/email_verification_page.dart';
import '../presentation/pages/sales/new_sale_page.dart';
import '../presentation/pages/sales/sales_page.dart';
import '../presentation/pages/sales/sale_detail_page.dart';
import '../presentation/pages/customers/customers_page.dart';
import '../presentation/pages/customers/create_customer_page.dart';
import '../presentation/pages/customers/edit_customer_page.dart';
import '../data/models/cliente_model.dart';
import '../presentation/pages/inventory/inventory_page.dart';
import '../presentation/pages/inventory/inventory_detail_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/admin/admin_page.dart';
import '../presentation/pages/brand_management/brand_management_page.dart';
import '../presentation/pages/category_management/category_management_page.dart';
import '../presentation/pages/producto_management/product_management_page.dart';
import '../presentation/pages/purchases/purchases_page.dart';
import '../presentation/pages/purchases/new_purchase_page.dart';
import '../presentation/pages/purchases/purchase_detail_page.dart';
import '../presentation/pages/purchases/purchases_reports_page.dart';
import '../presentation/pages/suppliers/suppliers_page.dart';
import '../presentation/pages/suppliers/create_supplier_page.dart';
import '../presentation/pages/suppliers/edit_supplier_page.dart';
import '../data/models/proveedor_model.dart';
import '../presentation/pages/reports/reports_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/layouts/page_wrapper.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';

  // Products
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String newProduct = '/products/new';
  static const String editProduct = '/products/:id/edit';

  // Sales
  static const String sales = '/sales';
  static const String newSale = '/sales/new';
  static const String saleDetail = '/sales/:id';

  // Purchases
  static const String purchases = '/purchases';
  static const String newPurchase = '/purchases/new';
  static const String purchaseDetail = '/purchases/:id';
  static const String purchasesReports = '/purchases/reports';

  // Inventory
  static const String inventory = '/inventory';
  static const String inventoryDetail = '/inventory/:id';
  static const String productDetails = '/product-details';

  // Customers
  static const String customers = '/customers';
  static const String createCustomer = '/customers/create';
  static const String editCustomer = '/customers/:id/edit';

  // Suppliers
  static const String suppliers = '/suppliers';
  static const String createSupplier = '/suppliers/create';
  static const String editSupplier = '/suppliers/:id/edit';

  // Reports
  static const String reports = '/reports';

  // Users
  static const String users = '/users';
  static const String userDetail = '/users/:id';

  // Settings
  static const String settings = '/settings';

  // Admin
  static const String profile = '/profile';
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
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'Crear Cuenta',
          child: RegisterPage(),
        ),
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
          final email =
              state.uri.queryParameters['email'] ?? 'usuario@ejemplo.com';
          return EmailVerificationPage(email: email);
        },
      ),

      
      GoRoute(
        path: editProduct,
        name: 'editProduct',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(title: Text('Editar Producto $productId')),
            body: Center(
              child: Text('Editar producto $productId - En desarrollo'),
            ),
          );
        },
      ),

      // Purchases
      GoRoute(
        path: purchases,
        name: 'purchases',
        builder: (context, state) => const PageWrapper(
          currentIndex: 2,
          title: 'Purchases',
          child: PurchasesPage(),
        ),
      ),
      GoRoute(
        path: newPurchase,
        name: 'newPurchase',
        builder: (context, state) => const PageWrapper(
          currentIndex: 2,
          title: 'New Purchase',
          child: NewPurchasePage(),
        ),
      ),
      GoRoute(
        path: purchaseDetail,
        name: 'purchaseDetail',
        builder: (context, state) {
          final purchaseId = state.pathParameters['id']!;
          return PageWrapper(
            currentIndex: 2,
            title: 'Detalle de Compra',
            child: PurchaseDetailPage(compraId: int.parse(purchaseId)),
          );
        },
      ),
      GoRoute(
        path: purchasesReports,
        name: 'purchasesReports',
        builder: (context, state) => const PageWrapper(
          currentIndex: 2,
          title: 'Reportes de Compras',
          child: PurchasesReportsPage(),
        ),
      ),

      // Suppliers
      GoRoute(
        path: suppliers,
        name: 'suppliers',
        builder: (context, state) => const PageWrapper(
          currentIndex: 1,
          title: 'Suppliers',
          child: SuppliersPage(),
        ),
      ),
      GoRoute(
        path: createSupplier,
        name: 'createSupplier',
        builder: (context, state) => const PageWrapper(
          currentIndex: 1,
          title: 'Crear Proveedor',
          child: CreateSupplierPage(),
        ),
      ),
      GoRoute(
        path: editSupplier,
        name: 'editSupplier',
        builder: (context, state) {
          final supplier = state.extra as Proveedor;
          return PageWrapper(
            currentIndex: 1,
            title: 'Editar Proveedor',
            child: EditSupplierPage(supplier: supplier),
          );
        },
      ),

      // Product Details
      // GoRoute(
      //   path: productDetails,
      //   name: 'productDetails',
      //   builder: (context, state) {
      //     final detalleProductoId = int.parse(state.pathParameters['id'] ?? '0');
      //     return PageWrapper(
      //       currentIndex: 3,
      //       title: 'Detalles de Producto',
      //       child: InventoryDetailPage(detalleProductoId: detalleProductoId),
      //     );
      //   },
      // ),

      // Sales
      GoRoute(
        path: newSale,
        name: 'newSale',
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'New Sale',
          child: NewSalePage(),
        ),
      ),
      GoRoute(
        path: sales,
        name: 'sales',
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'Sales',
          child: SalesPage(),
        ),
      ),
      GoRoute(
        path: saleDetail,
        name: 'saleDetail',
        builder: (context, state) {
          final saleId = int.parse(state.pathParameters['id']!);
          return PageWrapper(
            currentIndex: 0,
            title: 'Detalle de Venta',
            child: SaleDetailPage(ventaId: saleId),
          );
        },
      ),

      // Inventory
      GoRoute(
        path: inventory,
        name: 'inventory',
        builder: (context, state) => const PageWrapper(
          currentIndex: 3,
          title: 'Inventory',
          child: InventoryPage(),
        ),
      ),
      GoRoute(
        path: inventoryDetail,
        name: 'inventoryDetail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PageWrapper(
            currentIndex: 3,
            title: 'Detalle de Producto',
            child: InventoryDetailPage(detalleProductoId: id),
          );
        },
      ),

      // Customers
      GoRoute(
        path: customers,
        name: 'customers',
        builder: (context, state) => const PageWrapper(
          currentIndex: 1,
          title: 'Customers',
          child: CustomersPage(),
        ),
      ),
      GoRoute(
        path: createCustomer,
        name: 'createCustomer',
        builder: (context, state) => const PageWrapper(
          currentIndex: 1,
          title: 'Crear Cliente',
          child: CreateCustomerPage(),
        ),
      ),
      GoRoute(
        path: editCustomer,
        name: 'editCustomer',
        builder: (context, state) {
          final customerId = int.parse(state.pathParameters['id']!);
          final customer = Cliente(
            clienteId: customerId,
            nombre: '',
            telefono: '',
            email: '',
            direccion: '',
            activo: true,
          );
          return PageWrapper(
            currentIndex: 1,
            title: 'Editar Cliente',
            child: EditCustomerPage(customer: customer),
          );
        },
      ),

      // Usuarios
      GoRoute(
        path: users,
        name: 'users',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Gestión de Usuarios - En desarrollo')),
        ),
      ),
      GoRoute(
        path: userDetail,
        name: 'userDetail',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(title: Text('Usuario $userId')),
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
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'Configuración',
          child: SettingsPage(),
        ),
      ),

      // Administración
      GoRoute(
        path: admin,
        name: 'admin',
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'Administración',
          child: AdminPage(),
        ),
      ),

      // Perfil
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'Perfil',
          child: ProfilePage(),
        ),
      ),

      // brand management
      GoRoute(
        path: '/admin/brands',
        name: 'brandManagement',
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'Gestión de Marcas',
          child: BrandManagementPage(),
        ),
      ),

      // category management
      GoRoute(
        path: '/admin/categories',
        name: 'categoryManagement',
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'Gestión de Categorías',
          child: CategoryManagementPage(),
        ),
      ),

      // producto magement
      GoRoute(
        path: '/admin/products',
        name: 'productManagement',
        builder: (context, state) => const PageWrapper(
          currentIndex: 0,
          title: 'Gestión de Productos',
          child: ProductManagementPage(),
        ),
      ),

      // Reportes
      GoRoute(
        path: reports,
        name: 'reports',
        builder: (context, state) => const PageWrapper(
          currentIndex: 3,
          title: 'Reportes',
          child: ReportsPage(),
        ),
      ),
    ],
  );
}
