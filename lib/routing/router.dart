import 'package:go_router/go_router.dart';
import 'package:mobile_test_siscom/routing/routes.dart';
import 'package:mobile_test_siscom/ui/detail_stock/view/detail_stock_screen.dart';
import 'package:mobile_test_siscom/ui/list_stock/view/list_stock_screen.dart';
import 'package:mobile_test_siscom/ui/search/view/search_screen.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.listStock,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: Routes.listStock,
      name: Routes.listStock,
      builder: (context, state) {
        return ListStockScreen();
      },
    ),
    GoRoute(
      path: Routes.searchStock,
      name: Routes.searchStock,
      builder: (context, state) {
        return SearchScreen();
      },
    ),
    GoRoute(
      path: Routes.detailStock,
      name: Routes.detailStock,
      builder: (context, state) {
        return DetailStockScreen();
      },
    ),
  ]
);