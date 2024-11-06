import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {}

class LoginPageLoadingEvent extends LoginEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class LoginHideShowPasswordEvent extends LoginEvent {
  final bool isHideShow;
  LoginHideShowPasswordEvent({required this.isHideShow});
  @override
  // TODO: implement props
  List<Object> get props => [isHideShow];
}

class LoginSubmitDataEvent extends LoginEvent {
  final BuildContext context;
  final bool isLoginLoading;

  LoginSubmitDataEvent({required this.context, required this.isLoginLoading});
  @override
  // TODO: implement props
  List<Object> get props => [context, isLoginLoading];
}
