import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:igl_outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:igl_outage_app/features/ReportOutage/CreateAlertForm/presentation/create_alert_form_page.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetGasValueGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineGisModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetPipelineNetworkModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/GetTFGISModel.dart';
import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/presentation/widget/alert_dialog_widget.dart';
import 'package:igl_outage_app/service/Apis.dart';
import 'package:igl_outage_app/service/api_server_dio.dart';

class ReportAlertHelper{
  static Future<void> clearCache() async {
    Directory path = Directory("/data/user/0/unistal.igloutage.app/cache/");

    if (await path.exists()) {
      List<FileSystemEntity> files = path.listSync();
      for (FileSystemEntity f in files) {
        if (f is File) {
          await f.delete();
        }
      }
    }

    Directory path2 = Directory("/data/user/0/unistal.igloutage.app/cache/file_picker/");

    if (await path2.exists()) {
      path2.deleteSync(recursive: true);
    }

    Directory path3 = Directory("/data/user/0/unistal.igloutage.app/cache/diskcache/");

    if (await path3.exists()) {
      path3.deleteSync(recursive: true);
    }
  }
  static Future<GetPipelineGisModel?> getPipelineGisApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getPipelineGis, context: context);
      GetPipelineGisModel response = GetPipelineGisModel.fromJson(res);
      return response;
    } catch (e) {
      log("getPipelineGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getGasValueGisApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getGasValueGis, context: context);
      GetTfGisModel response = GetTfGisModel.fromJson(res);
      return response;
    } catch (e) {
      log("getGasValueGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetGasValueGISModel?> getFittingGisApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getFittingGis, context: context);
      GetGasValueGISModel response = GetGasValueGISModel.fromJson(res);
      return response;
    } catch (e) {
      log("getFittingGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetTfGisModel?> getTFGisApi({required BuildContext context}) async {
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getTFGis, context: context);
      GetTfGisModel response = GetTfGisModel.fromJson(res);
      if(response.data != null){
        return response;
      }
    } catch (e) {
      log("getTFGis-->${e.toString()}");
    }
    return null;
  }

  static Future<GetPipelineNetworkModel?> getPipelineNetworkApi({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    Map<String, String> para = {
      "latitude": latitude,
      "longitude": longitude,
      "buffer": "1.5",
    };
    String json = Uri(queryParameters: para).query;
    try {
      var res = await ApiHelper.getData(urlEndPoint: Apis.getPipelineNetwork + json, context: context);
      GetPipelineNetworkModel response = GetPipelineNetworkModel.fromJson(res);
      return response;
    } catch (e) {
      log("getPipelineNetwork-->${e.toString()}");
    }
    return null;
  }

  static Future<dynamic> createMarker({
    required List<LatLng> latlngList,
    required BuildContext context,
    required BitmapDescriptor markerIcon,
  }) async {
    Set<Marker> markersPointList = {};
     try{
       int i = 0;
       for(var latLngData in latlngList){
         markersPointList .add(Marker(
           markerId: MarkerId(i.toString()),
           infoWindow: InfoWindow(
               title: "${latLngData.latitude.toString()}, " "${latLngData.longitude.toString()}",
           ),
           position: LatLng(latLngData.latitude, latLngData.longitude),
           onTap: () async {
             await SharedPref.setString(key: PrefsValue.markerLat,value: latLngData.latitude.toString());
             await SharedPref.setString(key: PrefsValue.markerLong,value: latLngData.longitude.toString());
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const CreateAlertFormView()),
               );
               /* showBottomSheet(context: context, builder: (BuildContext context){
               return AlertDialogTwoBtnWidget();
             });*/
          //   }

           },
           icon: markerIcon,
         ));
       }
     }catch(_) {};
    return markersPointList;
  }

  static Future<dynamic> createPolyLine({
    required List<LatLng> latlngList,
    required Color color,
    required BuildContext context}) async {
    Set<Polyline> polylineList = {};
    try{
      if(latlngList.isNotEmpty){
        polylineList.add(Polyline(
            polylineId: PolylineId(latlngList.toString()),
            visible: true,
            width: 6,
            points: latlngList,
            color: color,
            jointType: JointType. mitered,
            geodesic: false,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            onTap: (){
              print("Hello Polyline");
            }
        ));
      }
    }catch(_){}
    return polylineList;
  }

  static  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}