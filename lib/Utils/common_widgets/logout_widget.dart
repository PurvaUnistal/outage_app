import 'package:flutter/material.dart';
import 'package:outage_app/Utils/common_widgets/HiveDatabase/hive_database.dart';
import 'package:outage_app/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:outage_app/Utils/common_widgets/res/app_config.dart';
import 'package:outage_app/features/Login/presentation/page/login_page.dart';
import 'package:path_provider/path_provider.dart';

/// Step callback: message + progress (0.0 - 1.0)
typedef LogoutStepCallback = void Function(String message, double progress);

class LogoutWidget extends StatefulWidget {
  const LogoutWidget({super.key});

  @override
  State<LogoutWidget> createState() => _LogoutWidgetState();

  /// Logout dialog kholne ke liye: `LogoutWidget.show(context);`
  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Logout',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => const LogoutWidget(),
      transitionBuilder: (context, anim, _, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Logout pe saara user data clear karta hai.
  /// `onStep` optional hai — splash se bina argument ke call kar sakte ho.
  static Future<void> logout({LogoutStepCallback? onStep}) async {
    onStep?.call("Please wait...", 0.25);
    await _safe("Hive", HiveDataBase.clearAllHiveData);

    onStep?.call("Please wait...", 0.55);
    await _safe("SharedPreferences", SharedPref.clearAll);

    onStep?.call("Please wait...", 0.8);
    await _safe("Cache", deleteCacheDir);

    AppConfig.reset();
    onStep?.call("Done", 1.0);
    debugPrint("Logout: saara data clear ho gaya");
  }

  static Future<void> _safe(String name, Future<void> Function() task) async {
    try {
      await task();
    } catch (e) {
      debugPrint("Logout [$name] failed: $e");
    }
  }

  /// Cache clear karta hai: memory ka image cache + temp folder ki files.
  static Future<void> deleteCacheDir() async {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    final tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) return;

    await for (final entity in tempDir.list()) {
      try {
        await entity.delete(recursive: true);
      } catch (e) {
        debugPrint("Cache delete skip: ${entity.path} -> $e");
      }
    }
  }
}

class _LogoutWidgetState extends State<LogoutWidget> {
  static const Color _danger = Color(0xFFD32F2F);

  bool _isLoggingOut = false;
  double _progress = 0;
  String _stepText = "";

  Future<void> _onLogout() async {
    // Double tap se do baar logout na chale
    if (_isLoggingOut) return;
    setState(() {
      _isLoggingOut = true;
      _stepText = "Please wait...";
    });

    await LogoutWidget.logout(
      onStep: (message, progress) {
        if (!mounted) return;
        setState(() {
          _stepText = message;
          _progress = progress;
        });
      },
    );

    // "Done" thodi der dikhane ke liye
    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      // Logout chalte waqt back button / bahar tap se band na ho
      canPop: !_isLoggingOut,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // Card
                  Container(
                    margin: const EdgeInsets.only(top: 44),
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isLoggingOut ? "Logging out..." : "Logout",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Are you sure you want to logout?",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.65),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: _isLoggingOut
                                ? _buildProgressBar()
                                : _buildLogoutButton(),
                          ),
                          const SizedBox(height: 4),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: _isLoggingOut ? 0 : 1,
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: TextButton(
                                onPressed: _isLoggingOut
                                    ? null
                                    : () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Card ke upar aadha bahar nikla hua icon
                  Positioned(top: 0, child: _buildBadge(theme)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(ThemeData theme) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _danger,
        border: Border.all(color: theme.cardColor, width: 6),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          _progress >= 1 ? Icons.check_rounded : Icons.logout_rounded,
          key: ValueKey(_progress >= 1),
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      key: const ValueKey("button"),
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _onLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: _danger,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }

  /// Button hi progress bar ban jata hai aur left se right bharta hai
  Widget _buildProgressBar() {
    return ClipRRect(
      key: const ValueKey("progress"),
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: _danger.withOpacity(0.12)),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              builder: (_, value, __) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                heightFactor: 1,
                child: Container(color: _danger),
              ),
            ),
            Center(
              child: Text(
                _stepText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _progress >= 0.5 ? Colors.white : _danger,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}