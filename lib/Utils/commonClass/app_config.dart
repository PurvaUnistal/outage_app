// import 'package:flutter/cupertino.dart';
// class AppConfig {
//
//   static AppConfig? instance;
//   RoleType? roleType;
//   Client? client;
//
//   static AppConfig? instanceInit(){
//     instance ??= AppConfig();
//     return instance;
//   }
//
//   setClient({required Client client}){
//     this.client =  client;
//   }
//
//   static DeviceType getDeviceType({BuildContext? context}) {
//     var isPortrait =  true;
//     if(context != null){
//           isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//       }
//
//     final MediaQueryData data = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);
//    return data.size.shortestSide <= 600
//         ? DeviceType.phone
//         : DeviceType.tablet;
//
//
//     return isPortrait == true
//         ? DeviceType.phone
//         : DeviceType.tablet;
//
//   }
//
// }
