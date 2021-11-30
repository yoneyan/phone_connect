import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class GetBatteryPage extends StatefulWidget {
  final BluetoothDevice bluetoothDevice;
  static const String roxuteName = '/detail';

  const GetBatteryPage({Key? key, required this.bluetoothDevice})
      : super(key: key);

  @override
  State<GetBatteryPage> createState() => _GetBatteryPage();
}

class _GetBatteryPage extends State<GetBatteryPage> {
  String _status = 'Connecting.....';

  Future<int> _getBattery() async {
    int _battery = -1;
    await widget.bluetoothDevice.connect();
    _status = 'Connected';
    List<BluetoothService> services =
        await widget.bluetoothDevice.discoverServices();
    for (var service in services) {
      print(service);
      if (service.uuid.toString() == "0000180f-0000-1000-8000-00805f9b34fb") {
        List<int> data = await service.characteristics[0].read();
        _battery = data[0];
      }
    }
    return _battery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BleDetailPage(${widget.bluetoothDevice.name})'),
        ),
        body: Column(children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.bluetooth),
              title: Text(widget.bluetoothDevice.name),
              subtitle: Text('MacAddress: ${widget.bluetoothDevice.id}\n'
                  'Type: ${widget.bluetoothDevice.type}\n'),
            ),
          ),
          FutureBuilder(
            future: _getBattery(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              // print(snapshot.data);
              if (snapshot.hasData) {
                if (snapshot.data == -1) {
                  return const Text("データが取得できません");
                } else {
                  return Text(snapshot.data.toString() + "%");
                }
              } else {
                return const Text("データの取得中です");
              }
            },
          ),
          // Text(_status),
          // Text("Battery: " + _battery.toString() + "%")
        ]));
  }
}
