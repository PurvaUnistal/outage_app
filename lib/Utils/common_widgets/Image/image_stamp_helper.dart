import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Sirf ek kaam: photo par Latitude, Longitude, Address, Date-Time draw karna.
class ImageStampHelper {
  static Future<File> stamp({
    required File file,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    final now = DateTime.now();
    final cleanAddress = _cleanAddress(address);

    final lines = [
      'Latitude: ${latitude.toStringAsFixed(6)}, '
          'Longitude: ${longitude.toStringAsFixed(6)}',
      if (cleanAddress.isNotEmpty) 'Address: $cleanAddress',
      DateFormat('dd-MM-yyyy  hh:mm:ss a').format(now),
    ];

    final bytes = await file.readAsBytes();
    final stamped = await compute(_drawStamp, {'bytes': bytes, 'lines': lines});

    final dir = await getTemporaryDirectory();
    final out =
    File(p.join(dir.path, 'stamped_${now.millisecondsSinceEpoch}.jpg'));
    await out.writeAsBytes(stamped);
    return out;
  }

  /// Address se "null", khaali parts aur non-English characters hatao.
  static String _cleanAddress(String? address) {
    if (address == null) return '';
    return address
        .replaceAll(RegExp(r'[^\x20-\x7E]'), '') // font sirf English draw karta hai
        .split(RegExp(r'[,]'))
        .map((e) => e.replaceAll('null', '').trim())
        .where((e) => e.isNotEmpty)
        .join(', ');
  }
}

/// Top-level hona zaroori hai, compute() ke liye.
Uint8List _drawStamp(Map<String, dynamic> args) {
  final Uint8List bytes = args['bytes'];
  final List<String> rawLines = List<String>.from(args['lines']);

  img.Image? image = img.decodeImage(bytes);
  if (image == null) throw Exception('Could not read image');

  image = img.bakeOrientation(image);

  final font = image.width > 1500 ? img.arial48 : img.arial24;
  const padding = 14;
  final maxWidth = image.width - padding * 2;

  int textWidth(String text) {
    var w = 0;
    for (final c in text.codeUnits) {
      w += font.characters[c]?.xAdvance ?? font.size ~/ 2;
    }
    return w;
  }

  final lines = <String>[];
  for (final line in rawLines) {
    var current = '';
    for (final word in line.split(' ')) {
      final test = current.isEmpty ? word : '$current $word';
      if (textWidth(test) > maxWidth && current.isNotEmpty) {
        lines.add(current);
        current = word;
      } else {
        current = test;
      }
    }
    if (current.isNotEmpty) lines.add(current);
  }

  final lineHeight = font.lineHeight + 6;
  final boxHeight = lines.length * lineHeight + padding * 2;
  final top = image.height - boxHeight;

  img.fillRect(
    image,
    x1: 0,
    y1: top,
    x2: image.width,
    y2: image.height,
    color: img.ColorRgba8(0, 0, 0, 160),
  );

  for (var i = 0; i < lines.length; i++) {
    img.drawString(
      image,
      lines[i],
      font: font,
      x: padding,
      y: top + padding + i * lineHeight,
      color: img.ColorRgb8(255, 255, 255),
    );
  }

  return Uint8List.fromList(img.encodeJpg(image, quality: 85));
}