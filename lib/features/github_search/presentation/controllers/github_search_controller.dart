import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../domain/entites/user.dart';
import '../../domain/usecases/search_users_use_case.dart';

class GithubSearchController extends GetxController {
  GithubSearchController(this.searchUsers);

  final _query = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final SearchUsersUseCase searchUsers;
  final RxString _errorMessage = RxString('');
  final List<User> users = <User>[].obs;
  var isLoading = false.obs;
  User? selectedUser;

  @override
  void onInit() {
    super.onInit();
    debounce(_query, (_) => search(), time: Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clear() {
    searchController.clear();
    users.clear();
  }

  void onQueryChanged(String value) {
    _query.value = value;
  }

  Future<void> search() async {
    if (_query.isEmpty) {
      users.clear();
      return;
    }
    isLoading.value = true;

    final result = await searchUsers.call(_query.value);

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        users.clear();
      },
      (success) {
        users.assignAll(success);
        _errorMessage.value = '';
      },
    );

    isLoading.value = false;
  }

  String get query => _query.value;
  String get errorMessage => _errorMessage.value;
  set errorMessage(String errorMessage) => _errorMessage.value = errorMessage;
}
