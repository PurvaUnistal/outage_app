import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outage_app/features/Login/domain/bloc/login_bloc.dart';
import 'package:outage_app/features/Login/domain/bloc/login_event.dart';
import 'package:outage_app/features/Login/domain/bloc/login_state.dart';
import 'widget/phone_login_view.dart';
import 'widget/tablet_login_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginPage> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    BlocProvider.of<LoginBloc>(context).add(LoginPageLoadingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginFetchDataState) {
            if (constraints.maxWidth < 600) {
              return PhoneLoginView(); // Phone Layout
            } else {
              return TabletLoginView(); // Tablet Layout
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    });
  }
}
