import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

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
        builder: (context, constraints) {
          // Kiểm tra nếu đang ở desktop (màn hình lớn)
          if (constraints.maxWidth > 800) {
            // Hiển thị ứng dụng trong một khung thiết bị
            return Scaffold(
              backgroundColor: Colors.grey[200],
              body: Center(
                child: DeviceFrame(
                  device: Devices.ios.iPhone13, // Hoặc bất kỳ thiết bị nào từ Devices
                  isFrameVisible: true,
                  orientation: Orientation.portrait,
                  screen: YourActualApp(),
                ),
              ),
            );
          } else {
            // Hiển thị ứng dụng bình thường nếu đang ở mobile
            return YourActualApp();
          }
        },
      ),
    );
  }
}

class YourActualApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ứng dụng của tôi')),
      body: Center(child: Text('Nội dung ứng dụng')),
    );
  }
}