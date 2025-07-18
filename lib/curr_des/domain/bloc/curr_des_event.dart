import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CurrDesEvent extends Equatable{}

class CurrDesPageLoadEvent extends CurrDesEvent {
  final BuildContext context;
  CurrDesPageLoadEvent({required this.context});
  @override
  // TODO: implement props
  List<Object> get props => [context];
}
