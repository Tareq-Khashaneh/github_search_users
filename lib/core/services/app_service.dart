import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:syncrow_test/core/services/network_service.dart';
import '../../features/github_search/data/models/user_model.dart';
import '../utils/network/network_checker.dart';

class AppService extends GetxService {

  late Box<List> cacheBox ;
  late NetworkService networkService;
  late NetworkInfo networkInfo;

  Future<AppService> init() async {
    networkInfo = NetworkInfoInternetChecker(InternetConnectionChecker.createInstance());
    networkService =  NetworkServiceDio();
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    cacheBox  = await Hive.openBox('user_search_cache');
    return this;
  }
  Future<void> initialize() async {
    await Get.putAsync(() => AppService().init());
  }
}
