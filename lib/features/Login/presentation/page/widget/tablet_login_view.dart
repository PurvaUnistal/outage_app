import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igl_outage_app/Utils/common_widgets/ButtonWidget/button_widget.dart';
import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
import 'package:igl_outage_app/Utils/common_widgets/icon_button.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/text_form_widget.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_bloc.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_event.dart';
import 'package:igl_outage_app/features/Login/domain/bloc/login_state.dart';

class TabletLoginView extends StatefulWidget {
  const TabletLoginView({Key? key}) : super(key: key);

  @override
  State<TabletLoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<TabletLoginView> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginFetchDataState) {
                  return _buildTabletLayout(dataState: state); // Tablet Layout
                
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }





  Widget _buildTabletLayout({required LoginFetchDataState dataState}) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade400],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Section
          Flexible(
            child: SingleChildScrollView(
              child: _logoWidget(width,
                  height),
            ),
          ),
          // Login Form Section
          Flexible(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding:
                const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      _emailWidget(dataState: dataState),
                      const SizedBox(height: 20),
                      _passwordWidget(dataState: dataState),
                      const SizedBox(height: 20),
                      _loginBtnWidget(dataState: dataState),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _logoWidget(double width, double height) {
    // Determine dynamic scaling factor based on screen dimensions
    final double baseSize = width < height ? width : height; // Use smaller dimension
    final double logoRadius = baseSize * 0.15; // Scale radius
    final double imageSize = baseSize * 0.2;   // Scale inner image

    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.blue.shade800,
        radius: logoRadius,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: logoRadius * 0.95, // Slightly smaller than outer circle
          child: Image.asset(
            AssetPath.agclIcon,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain, // Ensure the image scales properly
          ),
        ),
      ),
    );
  }


  Widget _emailWidget({required LoginFetchDataState dataState}) {
    return TextFieldWidget(
      label: AppString.emailLabel,
      hintText: AppString.emailLabel,
      autofillHints: [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      prefixIcon: IconButtonWidget(iconData: Icons.email, onPressed: () {}),
      controller: dataState.emailController,
    );
  }

  Widget _passwordWidget({required LoginFetchDataState dataState}) {
    return TextFieldWidget(
      label: AppString.passwordLabel,
      hintText: AppString.passwordLabel,
      autofillHints: [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: IconButtonWidget(iconData: Icons.lock, onPressed: () {}),
      controller: dataState.passwordController,
      obscureText: dataState.isPassword,
      suffixIcon: IconButtonWidget(
        iconData:
        dataState.isPassword ? Icons.visibility_off : Icons.visibility,
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(
            LoginHideShowPasswordEvent(
              isHideShow: !dataState.isPassword,
            ),
          );
        },
      ),
    );
  }

  Widget _loginBtnWidget({required LoginFetchDataState dataState}) {
    return dataState.isPageLoader == false
        ? ButtonWidget(
      text: AppString.login,
      onPressed: () {
        FocusScope.of(context).unfocus();
        TextInput.finishAutofillContext();
        BlocProvider.of<LoginBloc>(context).add(
          LoginSubmitDataEvent(
            context: context,
            isLoginLoading: true,
          ),
        );
      },
    )
        : const DottedLoaderWidget();
  }
}
