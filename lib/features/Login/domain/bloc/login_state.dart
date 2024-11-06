import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginState extends Equatable {}

class LoginInitState extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginFetchDataState extends LoginInitState {
  final bool isPageLoader;
  final bool isPassword;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginFetchDataState({
    required this.isPageLoader,
    required this.isPassword,
    required this.emailController,
    required this.passwordController,
  });
  @override
  List<Object> get props => [
    isPageLoader,
    isPassword,
    emailController,
    passwordController,
  ];
}
