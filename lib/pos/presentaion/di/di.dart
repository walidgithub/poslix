
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/main_view_cubit/main_view_cubit.dart';
import 'package:poslix_app/pos/presentaion/ui/register_pos_view/register_pos_cubit/register_pos_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/pos_local_repo_impl.dart';
import '../../domain/repositories/pos_repo_impl.dart';
import '../../shared/core/local_db/dbHelper.dart';
import '../../shared/core/network/dio_manager.dart';
import '../../shared/core/network/network_info.dart';
import '../../shared/preferences/app_pref.dart';
import '../../shared/style/theme_manager.dart';
import '../ui/login_view/login_cubit/login_cubit.dart';
import '../ui/main_view/inner_dialogs/hold_dialog/local_main_view_cubit/local_main_view_cubit.dart';
import '../ui/main_view/inner_dialogs/orders_reports/orders_cubit/orders_cubit.dart';


final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {

    // app prefs instance
    sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));

    final sharedPrefs = await SharedPreferences.getInstance();

    sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

    // dbHelper
    sl.registerLazySingleton<DbHelper>(() => DbHelper());

    // Dio
    sl.registerLazySingleton(() => DioManager());

    // Network Info
    sl.registerLazySingleton<NetworkInfo>(
            () => NetworkInfoImpl(InternetConnectionChecker()));

    // Cubit
    sl.registerFactory(() => LoginCubit(sl()));
    sl.registerFactory(() => MainViewCubit(sl()));
    sl.registerFactory(() => RegisterPOSCubit(sl()));
    sl.registerFactory(() => MainViewLocalCubit(sl()));
    sl.registerFactory(() => OrdersCubit(sl()));

    // Repo
    sl.registerLazySingleton<POSRepositoryImpl>(() => POSRepositoryImpl(sl()));
    sl.registerLazySingleton<POSLocalRepositoryImp>(() => POSLocalRepositoryImp(sl()));

    // Theme
    sl.registerLazySingleton<ThemeManager>(() => ThemeManager());

  }
}
