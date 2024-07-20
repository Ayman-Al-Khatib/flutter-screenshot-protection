import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenshotProtectionScreen extends StatefulWidget {
  const ScreenshotProtectionScreen({super.key});

  @override
  _ScreenshotProtectionScreenState createState() => _ScreenshotProtectionScreenState();
}

class _ScreenshotProtectionScreenState extends State<ScreenshotProtectionScreen>
    with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('com.example.prevent_screenshot/screenshot');
  bool _isSecureMode = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _enableSecure();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _enableSecure() async {
    try {
      await platform.invokeMethod('enableSecure');
      setState(() {
        _isSecureMode = true;
      });
      _animationController.forward();
    } on PlatformException catch (e) {
      log("Failed to enable secure mode: ${e.message}");
    }
  }

  Future<void> _disableSecure() async {
    try {
      await platform.invokeMethod('disableSecure');
      setState(() {
        _isSecureMode = false;
      });
      _animationController.reverse();
    } on PlatformException catch (e) {
      log("Failed to disable secure mode: ${e.message}");
    }
  }

  Future<void> _toggleSecureMode() async {
    if (_isSecureMode) {
      await _disableSecure();
    } else {
      await _enableSecure();
    }
  }

  Widget _buildIcon() {
    return FadeTransition(
      opacity: _animation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _isSecureMode ? Colors.red.withOpacity(0.6) : Colors.green.withOpacity(0.6),
              blurRadius: 100,
              spreadRadius: 35,
            ),
          ],
        ),
        child: Icon(
          _isSecureMode ? Icons.lock : Icons.lock_open,
          size: 100,
          color: _isSecureMode ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  Widget _buildButton() {
    return ElevatedButton.icon(
      icon: Icon(_isSecureMode ? Icons.visibility_off : Icons.visibility),
      label: Text(
        _isSecureMode ? 'Disable Screenshot Protection' : 'Enable Screenshot Protection',
        style: const TextStyle(fontSize: 16),
      ),
      onPressed: _toggleSecureMode,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _isSecureMode ? Colors.redAccent : Colors.green,
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screenshot Protection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildIcon(),
            const SizedBox(height: 20),
            _buildButton(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ScreenshotProtectionScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
