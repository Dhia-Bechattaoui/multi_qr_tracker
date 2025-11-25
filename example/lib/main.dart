import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_qr_tracker/multi_qr_tracker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi QR Tracker Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _scannedCodes = <String>[];
  final MultiQrTrackerController _controller = MultiQrTrackerController();
  bool _permissionGranted = false;
  bool _permissionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToSettings() async {
    // Stop camera before navigating
    _controller.stop();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
    // Resume camera when returning
    if (mounted) {
      _controller.start();
    }
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
        _permissionChecked = true;
      });
    } else {
      final result = await Permission.camera.request();
      setState(() {
        _permissionGranted = result.isGranted;
        _permissionChecked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionChecked) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_permissionGranted) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Camera permission required',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final result = await Permission.camera.request();
                  setState(() {
                    _permissionGranted = result.isGranted;
                  });
                },
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi QR Tracker Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
            tooltip: 'Settings (Test Camera Pause)',
          ),
        ],
      ),
      body: Stack(
        children: [
          MultiQrTrackerView(
            controller: _controller,
            showScanFrame: true,
            borderColor: const Color(0xFF00FF00), // Bright green
            borderWidth: 4.0,
            scanButtonColor: Colors.green,
            torchMode: TorchMode.manual, // Try TorchMode.auto or TorchMode.off
            onQrCodeScanned: (String value) {
              setState(() {
                if (!_scannedCodes.contains(value)) {
                  _scannedCodes.insert(0, value);
                  if (_scannedCodes.length > 10) {
                    _scannedCodes.removeLast();
                  }
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Scanned: $value'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onCameraError: (String error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Camera error: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
          // Scanned codes history
          if (_scannedCodes.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Scans',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_scannedCodes.length} codes',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...(_scannedCodes
                        .take(3)
                        .map(
                          (code) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              code,
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
