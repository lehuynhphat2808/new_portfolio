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
  bool isAnimating = false;

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
    if (isAnimating) return;

    isAnimating = true;

    // Xác định hướng cuối cùng sau khi hoàn thành animation
    final newOrientation = currentOrientation == Orientation.portrait
        ? Orientation.landscape
        : Orientation.portrait;

    if (newOrientation == Orientation.landscape) {
      // Xoay từ dọc sang ngang (0 -> 0.25)
      _controller.reset();
      _controller.forward().then((_) {
        setState(() {
          currentOrientation = newOrientation;
          isAnimating = false;
        });
      });
    } else {
      // Xoay từ ngang sang dọc (0.25 -> 0)
      _controller.reset();
      _controller.forward().then((_) {
        setState(() {
          currentOrientation = newOrientation;
          isAnimating = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
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
        Text('currentOrientation: ${currentOrientation.name}'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: devices.map((device) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                child: Text(device.name),
                onPressed: () => changeDevice(device),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          child: Text('Toggle Orientation'),
          onPressed: toggleOrientation,
        ),
        SizedBox(height: 20),
        Expanded(
          child: Container(
            color: Colors.grey[300],
            width: 600,
            height: 400,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Tính toán góc xoay dựa trên hướng hiện tại và mục tiêu
                double angle;
                if (currentOrientation == Orientation.portrait) {
                  // Đang ở chế độ dọc, đang xoay sang ngang
                  angle = _controller.value * (math.pi / 2);
                } else {
                  // Đang ở chế độ ngang, đang xoay sang dọc
                  angle = (1 - _controller.value) * (math.pi / 2);
                }

                return Transform.rotate(
                  angle: angle,
                  child: DeviceFrame(
                    device: currentDevice,
                    isFrameVisible: true,
                    // orientation: isAnimating
                    //     ? (currentOrientation == Orientation.portrait
                    //     ? Orientation.portrait
                    //     : Orientation.landscape)
                    //     : currentOrientation,
                    screen: YourActualApp(),
                  ),
                );
              },
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