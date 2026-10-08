import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/Utils/common_widgets/res/app_styles.dart';

import 'environment_config.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? boolLeading;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  final Widget? tabBar;

  /// Show the logged-in user's name under the title.
  final bool showUser;

  /// Show the project / smart logos beside the title.
  final bool showLogos;

  const AppBarWidget({
    Key? key,
    this.title,
    this.leadingWidget,
    this.boolLeading,
    this.actions,
    this.tabBar,
    this.showUser = true,
    this.showLogos = true,
  }) : super(key: key);

  static const double _barHeight = 64;
  static const double _tabHeight = 46;
  static const double _radius = 20;
  static const double _logoSize = 36;

  @override
  Size get preferredSize =>
      Size.fromHeight(_barHeight + (tabBar != null ? _tabHeight : 0));

  // ---------------- Helpers ----------------

  String _toTitleCase(String? input) {
    if (input == null || input.trim().isEmpty) return '';
    return input
        .trim()
        .split(RegExp(r'\s+'))
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  String _userInfo(String? name, String? schema) {
    final n = _toTitleCase(name);
    final s = schema?.trim() ?? '';
    if (n.isNotEmpty && s.isNotEmpty) return '$n ($s)';
    return n.isNotEmpty ? n : s;
  }

  // ---------------- Build ----------------

  @override
  Widget build(BuildContext context) {
    final config = EnvironmentConfig.of(context)!;
    final primary = config.primaryTheme;
    final secondary = config.secondaryTheme;

    final user = AppConfig.instanceInit()?.loginData.user;
    final String? projectLogo = user?.projectLogo;
    final String? smartLogo = user?.smartLogo;
    final userInfo = showUser ? _userInfo(user?.name, user?.schema) : '';

    final hasProjectLogo = showLogos && (projectLogo?.isNotEmpty ?? false);
    final hasSmartLogo = showLogos && (smartLogo?.isNotEmpty ?? false);
    final anyLogo = hasProjectLogo || hasSmartLogo;

    final canPop = Navigator.of(context).canPop();
    final showBack = leadingWidget == null && (boolLeading ?? false) && canPop;

    return AppBar(
      toolbarHeight: _barHeight,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      titleSpacing: 8,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(_radius)),
      ),
      flexibleSpace: ClipRRect(
        //    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(_radius)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [secondary, primary],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -50,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                      width: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      leadingWidth: (leadingWidget != null || showBack) ? 56 : 0,
      leading: leadingWidget ??
          (showBack
              ? _BackButton(onTap: () => Navigator.maybePop(context))
              : const SizedBox.shrink()),
      title: Row(
        children: [
          // Left logo (or an equal-width gap so the title stays centred).
          if (anyLogo)
            hasProjectLogo
                ? _Logo(url: projectLogo!, size: _logoSize)
                : const SizedBox(width: _logoSize),
          const SizedBox(width: 10),

          // Title
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.appTitle,
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),
          // Right logo (or an equal-width gap).
          if (anyLogo)
            hasSmartLogo
                ? _Logo(url: smartLogo!, size: _logoSize)
                : const SizedBox(width: _logoSize),
        ],
      ),
      actions: [
        ...?actions,
        // Balance the back button so the title block stays centred.
        SizedBox(width: (showBack && (actions?.isEmpty ?? true)) ? 48 : 8),
      ],
      bottom: tabBar == null
          ? null
          : PreferredSize(
        preferredSize: const Size.fromHeight(_tabHeight),
        child: SizedBox(height: _tabHeight, child: tabBar),
      ),
    );
  }
}

// ---------------- Logo ----------------

class _Logo extends StatelessWidget {
  final String url;
  final double size;

  const _Logo({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 1.8),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.image_not_supported_outlined,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}

// ---------------- Back button ----------------

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: const SizedBox(
            width: 38,
            height: 38,
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}