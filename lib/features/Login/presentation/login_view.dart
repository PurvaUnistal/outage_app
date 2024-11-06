import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Background/wavy_background.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/common_style.dart';
import 'package:igl_outage_app/Utils/common_widgets/button_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/icon_button.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
import 'package:igl_outage_app/Utils/common_widgets/text_form_widget.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_bloc.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_event.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    BlocProvider.of<LoginBloc>(context).add(LoginPageLoadingEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarWidget(
      //   title: AppString.tpaApp,
      //   boolLeading: false,
      // ),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginFetchDataState) {
            return WavyBackground(
            child: _buildLayout(dataState: state)
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildLayout({required LoginFetchDataState dataState}) {
    var h = MediaQuery.of(context).size.height;
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Card(
          elevation: 8,
          color: Colors.white,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.symmetric(horizontal:23),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Login",style: Styles.count,),
                Spacer(),
                _emailWidget(dataState: dataState),
                CommonStyle.vertical(context: context),
                _passwordWidget(dataState: dataState),
                Spacer(),
               // _loginBtnWidget(dataState: dataState),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child:  _loginBtnWidget(dataState: dataState),
        ),
        Positioned(
          top: -h * 0.18,
          left: 0,
          right: 0,
          child: _logoWidget(),
        ),

      ],
    );
  }

  Widget _logoWidget() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Image.asset(
      AssetPath.iglLogo,
      width: w * 0.9,
      height: h * 0.19,
    );
  }

  Widget _emailWidget({required LoginFetchDataState dataState}) {
    return TextFieldWidget(
      label: AppString.emailLabel,
      hintText: AppString.emailLabel,
      autofillHints: [AutofillHints.email, AutofillHints.password],
      keyboardType: TextInputType.emailAddress,
      prefixIcon: IconButtonWidget(iconData: Icons.email, onPressed: () {}),
      controller: dataState.emailController,
    );
  }

  Widget _passwordWidget({required LoginFetchDataState dataState}) {
    return TextFieldWidget(
      label: AppString.passwordLabel,
      hintText: AppString.passwordLabel,
      autofillHints: const [AutofillHints.password, AutofillHints.email],
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: IconButtonWidget(iconData: Icons.password, onPressed: () {}),
      controller: dataState.passwordController,
      suffixIcon: IconButtonWidget(
          iconData: dataState.isPassword ? Icons.visibility_off : Icons.visibility,
          onPressed: () {
            BlocProvider.of<LoginBloc>(context).add(LoginHideShowPasswordEvent(isHideShow: dataState.isPassword == true ? false : true));
          }),
      obscureText: dataState.isPassword,
    );
  }

  Widget _loginBtnWidget({required LoginFetchDataState dataState}) {
    return dataState.isPageLoader == false
        ? Container(
      margin: EdgeInsets.symmetric(horizontal: 80),
          child: ButtonWidget(
              text: AppString.login,
              onPressed: () {
                FocusScope.of(context).unfocus();
                TextInput.finishAutofillContext();
                BlocProvider.of<LoginBloc>(context).add(LoginSubmitDataEvent(context: context, isLoginLoading: true));
              }),
        )
        : DottedLoaderWidget();
  }
}
