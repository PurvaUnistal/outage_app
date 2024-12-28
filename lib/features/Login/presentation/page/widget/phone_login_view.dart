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

class PhoneLoginView extends StatefulWidget {
  const PhoneLoginView({Key? key}) : super(key: key);

  @override
  State<PhoneLoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<PhoneLoginView> {
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
                return _buildPhoneLayout(dataState: state);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
    );
  }

  Widget _buildPhoneLayout({required LoginFetchDataState dataState}) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Stack(
      children: [
        _buildGradientBackground(),
        Positioned(
          top: height * 0.1,
          left: 0,
          right: 0,
          child: _logoWidget(width, height),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildFormContainer(height, dataState),
        ),
      ],
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade400],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildFormContainer(double height, LoginFetchDataState dataState) {
    return Container(
      height: height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(80),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          /*  crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,*/
          children: [
            Spacer(),
            Text(
              "Login",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            _emailWidget(dataState: dataState),
            const SizedBox(height: 20),
            _passwordWidget(dataState: dataState),
            const SizedBox(height: 20),
            _loginBtnWidget(dataState: dataState),
            Spacer(),
            Spacer(),
          ],
        ),
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
