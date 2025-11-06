
import 'package:flutter/material.dart';
import 'package:pain_scale_app/data/models/user_model.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';

enum ViewState { loading, content, error }

class UserViewModel extends ChangeNotifier {
  final UserRepository userRepository = UserRepository();

  List<UserModel> users = [];

  ViewState state = ViewState.loading;

  Future<void> fetchUsers() async {
    try {
      showLoading();
      users = await userRepository.fetchUsers();
      showContent();
    } catch (e) {
      showError();
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      showLoading();
      await userRepository.updateUser(user);
      await fetchUsers();
    } catch (e) {
      showError();
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      showLoading();
      await userRepository.addUser(user);
      await fetchUsers();
    } catch (e) {
      showError();
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      showLoading();
      await userRepository.deleteUser(id);
      await fetchUsers();
    } catch (e) {
      showError();
    }
  }

  void showLoading() {
    state = ViewState.loading;
    notifyListeners();
  }

  void showContent() {
    state = ViewState.content;
    notifyListeners();
  }

  void showError() {
    state = ViewState.error;
    notifyListeners();
  }
}