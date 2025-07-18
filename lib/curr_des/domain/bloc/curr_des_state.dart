import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outage_app/features/Login/domain/model/login_model.dart';

abstract class CurrDesState extends Equatable {}

class CurrDesInitialState extends CurrDesState {
  @override
  List<Object> get props => [];
}

class CurrDesPageLoadState extends CurrDesState {
  @override
  List<Object> get props => [];
}

class FetchCurrDesDataState extends CurrDesState {
  final bool isPageLoader;


  FetchCurrDesDataState({
    required this.isPageLoader,

  });

  @override
  List<Object> get props => [isPageLoader];
}
