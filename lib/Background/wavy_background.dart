import 'package:flutter/material.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_asset.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_color.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_string.dart';
import 'package:igl_outage_app/Utils/common_widgets/res/app_styles.dart';

class WavyBackground extends StatelessWidget {
  final Widget child;

  const WavyBackground({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetPath.pipeback),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // White overlay with opacity
        Container(
          color: Colors.white.withOpacity(0.9),
        ),
        // Header, content, and footer
        Column(
          children: [
            Flexible(child: WavyHeader()),
            Flexible(child: child),
            Flexible(child: CircleFooter()),
          ],
        ),
        // Footer text
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: FooterText(),
        ),
      ],
    );
  }
}

class WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopWaveClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.primer, AppColor.primer40],
            begin: Alignment.topLeft,
            end: Alignment.center,
          ),
        ),
      ),
    );
  }
}

class CircleFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColoredCircle(
          color: AppColor.primer,
          offset: Offset(-70, 90),
          size: 120,
        ),
        ColoredCircle(
          color: AppColor.primer1,
          offset: Offset(0, 210),
          size: 140,
        ),
      ],
    );
  }
}

class ColoredCircle extends StatelessWidget {
  final Color color;
  final Offset offset;
  final double size;

  const ColoredCircle({required this.color, required this.offset, required this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Material(
        color: color,
        shape: CircleBorder(side: BorderSide(color: AppColor.white, width: 15)),
        child: Padding(padding: EdgeInsets.all(size)),
      ),
    );
  }
}

class FooterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppString.companyName,
          style: Styles.relB,
        ),
        Text(
          AppString.version,
          style: Styles.relB,
        ),
      ],
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);

    final firstControlPoint = Offset(size.width / 7, size.height - 30);
    final firstEndPoint = Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width / 5, size.height / 4);
    final secondEndPoint = Offset(size.width / 1.5, size.height / 5);

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    final thirdControlPoint = Offset(size.width - (size.width / 9), size.height / 6);
    final thirdEndPoint = Offset(size.width, 0.0);

    path.quadraticBezierTo(
      thirdControlPoint.dx,
      thirdControlPoint.dy,
      thirdEndPoint.dx,
      thirdEndPoint.dy,
    );

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
