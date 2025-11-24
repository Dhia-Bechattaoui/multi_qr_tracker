import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_qr_tracker/multi_qr_tracker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool _permissionGranted = false;
  bool _permissionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
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
      body: MultiQrTrackerView(
        showScanFrame: true,
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
    );
  }
}
