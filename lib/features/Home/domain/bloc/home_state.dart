import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';

abstract class HomeState extends Equatable {}

class HomeInitialState extends HomeState {
  @override
  List<Object> get props => [];
}

class HomePageLoadState extends HomeState {
  @override
  List<Object> get props => [];
}


class FetchHomeDataState extends HomeState {
  final bool isLoader;
  final String role;
  final String baseUrl;
  List<Accessright> listOFAccessRight;
  final List<String> paths;
  final List<String> iconText;
  final List<Widget> navigatorView;


  FetchHomeDataState({
    required this.isLoader,
    required this.baseUrl,
    required this.role,
    required this.listOFAccessRight,
    required this.paths,
    required this.iconText,
    required this.navigatorView,
  });
  @override
  List<Object> get props => [
    isLoader,
    role,
    baseUrl,
    listOFAccessRight,
    paths,
    iconText,
    navigatorView,
  ];
}