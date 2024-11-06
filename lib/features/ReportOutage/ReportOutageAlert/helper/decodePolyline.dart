// import 'package:igl_outage_app/features/ReportOutage/ReportOutageAlert/domain/model/PointLatLngModel.dart';
//
// class DecodePolyline{
//   static List<PointLatLngModel> decodePolyline(String polyline,
//
//       {int accuracyExponent = 5}) {
//
//     final accuracyMultiplier = math.pow(10, accuracyExponent);
//
//     List<PointLatLngModel> coordinates = [];
//
//     int index = 0;
//
//     int lat = 0;
//
//     int lng = 0;
//
//     while (index < polyline.length) {
//
//       int char;
//
//       int shift = 0;
//
//       int result = 0;
//
//
//
//       int getCoordinate() {
//
//         do {
//
//           char = polyline.codeUnitAt(index++) - 63;
//
//           result |= (char & 0x1f) << shift;
//
//           shift += 5;
//
//         } while (char >= 0x20);
//
//         final value = result >> 1;
//
//         final coordinateChange =
//
//         (result & 1) != 0 ? (~BigInt.from(value)).toInt() : value;
//
//
//
//         shift = result = 0;
//
//         return coordinateChange;
//
//       }
//
//       lat += getCoordinate();
//
//       lng += getCoordinate();
//
//       coordinates.add(
//
//           PointLatLngModel(latitude:  lat / accuracyMultiplier,longitude:  lng / accuracyMultiplier));
//
//     }
//
//     return coordinates;
//
//   }
// }