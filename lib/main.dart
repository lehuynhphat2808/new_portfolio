import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Frame Demo',
      home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 800) {
            return Scaffold(
              backgroundColor: Colors.grey[200],
              body: Center(
                child: DeviceFrameWrapper(),
              ),
            );
          } else {
            return YourActualApp();
          }
        },
      ),
    );
  }
}

class DeviceFrameWrapper extends StatefulWidget {
  @override
  _DeviceFrameWrapperState createState() => _DeviceFrameWrapperState();
}

class _DeviceFrameWrapperState extends State<DeviceFrameWrapper>
    with SingleTickerProviderStateMixin {
  DeviceInfo currentDevice = Devices.ios.iPadPro11Inches;
  Orientation currentOrientation = Orientation.landscape;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  List<DeviceInfo> devices = [
    Devices.ios.iPadPro11Inches,
    Devices.ios.iPhone12,
    Devices.ios.iPhoneSE,
    Devices.android.samsungGalaxyA50,
    Devices.android.samsungGalaxyNote20,
  ];

  void changeDevice(DeviceInfo device) {
    setState(() {
      currentDevice = device;
    });
  }

  void toggleOrientation() {
    // Xác định hướng mới
    Orientation newOrientation = (currentOrientation == Orientation.portrait)
        ? Orientation.landscape
        : Orientation.portrait;

    // Tính giá trị turns mục tiêu: 0.0 cho portrait, 0.25 cho landscape
    double targetTurns = (newOrientation == Orientation.portrait) ? 0.0 : 0.25;

    // Lấy giá trị turns hiện tại
    double currentTurns = (currentOrientation == Orientation.portrait) ? 0.0 : 0.25;

    // Tạo animation từ turns hiện tại đến turns mục tiêu
    _rotationAnimation = Tween<double>(begin: currentTurns, end: targetTurns)
        .animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            currentOrientation = newOrientation;
          });
        }
      });

    // Khởi động animation
    _controller.reset();
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Khởi tạo _rotationAnimation với giá trị mặc định
    _rotationAnimation = AlwaysStoppedAnimation(0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: devices.map((device) {
            return ElevatedButton(
              child: Text(device.name),
              onPressed: () => changeDevice(device),
            );
          }).toList(),
        ),
        ElevatedButton(
          child: Text('Toggle Orientation'),
          onPressed: toggleOrientation,
        ),
        Expanded(
          child: RotationTransition(
            turns: _rotationAnimation,
            child: DeviceFrame(
              device: currentDevice,
              isFrameVisible: true,
              orientation: currentOrientation,
              screen: YourActualApp(),
            ),
          ),
        ),
      ],
    );
  }
}

class YourActualApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your App')),
      body: Center(child: Text('App Content')),
    );
  }
}