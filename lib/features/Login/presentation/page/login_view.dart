// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:igl_outage_app/Background/wavy_background.dart';
// import 'package:igl_outage_app/Utils/common_widgets/ButtonWidget/button_widget.dart';
// import 'package:igl_outage_app/Utils/common_widgets/Loader/DottedLoader.dart';
// import 'package:igl_outage_app/Utils/common_widgets/WidgetStyles/common_style.dart';
// import 'package:igl_outage_app/Utils/common_widgets/icon_button.dart';
// import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
// import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
// import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';
// import 'package:igl_outage_app/Utils/common_widgets/text_form_widget.dart';
// import 'package:igl_outage_app/features/Login/domain/bloc/login_bloc.dart';
// import 'package:igl_outage_app/features/Login/domain/bloc/login_event.dart';
// import 'package:igl_outage_app/features/Login/domain/bloc/login_state.dart';
//
// class LoginView extends StatefulWidget {
//   const LoginView({Key? key}) : super(key: key);
//
//   @override
//   State<LoginView> createState() => _LoginViewState();
// }
//
// class _LoginViewState extends State<LoginView> {
//   FocusNode emailFocusNode = FocusNode();
//   FocusNode passwordFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     BlocProvider.of<LoginBloc>(context).add(LoginPageLoadingEvent());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<LoginBloc, LoginState>(
//         builder: (context, state) {
//           if (state is LoginFetchDataState) {
//             return WavyBackground(
//               child: _buildLayout(dataState: state),
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildLayout({required LoginFetchDataState dataState}) {
//     final media = MediaQuery.of(context);
//     final isTablet = media.size.width > 600;
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final height = constraints.maxHeight;
//         final width = constraints.maxWidth;
//
//         return SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: isTablet ? 50 : 20),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Card(
//                   elevation: 8,
//                   margin: EdgeInsets.symmetric(vertical: 0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(isTablet ? 32 : 16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//   Text(
//                           "Login",
//                           style: Styles.count.copyWith(
//                             fontSize: isTablet ? 28 : 22,
//                           ),
//                         ),
//
//                         SizedBox(height: isTablet ? 40 : 20),
//                         _emailWidget(dataState: dataState),
//                         const SizedBox(height: 16),
//                         _passwordWidget(dataState: dataState),
//                         SizedBox(height: isTablet ? 30 : 16),
//                         _loginBtnWidget(dataState: dataState),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                     left: 0,
//                     right: 0,
//                     top: -30, // Position to create overflow
//                     child: _logoWidget(width, height)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _logoWidget(double width, double height) {
//     return  Image.asset(
//       AssetPath.agclIcon,
//       width: width * 0.9, // Adjust logo size for devices
//       height: height * 0.19,
//     );
//  return CircleAvatar(
//       radius: 30,
//       backgroundImage: AssetImage(
//         AssetPath.agclIcon,
//       ),
//
//  child: Image.asset(
//         AssetPath.agclIcon,
//         width: width * 0.9, // Adjust logo size for devices
//         height: height * 0.19,
//       ),
//     );
//
//   }
//
//   Widget _emailWidget({required LoginFetchDataState dataState}) {
//     return TextFieldWidget(
//       label: AppString.emailLabel,
//       hintText: AppString.emailLabel,
//       autofillHints: [AutofillHints.email],
//       keyboardType: TextInputType.emailAddress,
//       prefixIcon: IconButtonWidget(iconData: Icons.email, onPressed: () {}),
//       controller: dataState.emailController,
//     );
//   }
//
//   Widget _passwordWidget({required LoginFetchDataState dataState}) {
//     return TextFieldWidget(
//       label: AppString.passwordLabel,
//       hintText: AppString.passwordLabel,
//       autofillHints: [AutofillHints.password],
//       keyboardType: TextInputType.visiblePassword,
//       prefixIcon: IconButtonWidget(iconData: Icons.lock, onPressed: () {}),
//       controller: dataState.passwordController,
//       obscureText: dataState.isPassword,
//       suffixIcon: IconButtonWidget(
//         iconData: dataState.isPassword ? Icons.visibility_off : Icons.visibility,
//         onPressed: () {
//           BlocProvider.of<LoginBloc>(context).add(
//             LoginHideShowPasswordEvent(
//               isHideShow: !dataState.isPassword,
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _loginBtnWidget({required LoginFetchDataState dataState}) {
//     return dataState.isPageLoader
//         ? const DottedLoaderWidget()
//         : Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: ButtonWidget(
//         text: AppString.login,
//         onPressed: () {
//           FocusScope.of(context).unfocus();
//           TextInput.finishAutofillContext();
//           BlocProvider.of<LoginBloc>(context).add(
//             LoginSubmitDataEvent(
//               context: context,
//               isLoginLoading: true,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
