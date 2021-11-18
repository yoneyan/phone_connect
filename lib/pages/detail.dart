import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../drawer.dart';

class BleDetailPage extends StatefulWidget {
  final ScanResult scanResult;
  static const String roxuteName = '/detail';

  const BleDetailPage({Key? key, required this.scanResult}) : super(key: key);

  @override
  State<BleDetailPage> createState() => _BleDetailPage();
}

class _BleDetailPage extends State<BleDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BleDetailPage(${widget.scanResult.device.name})'),
        ),
        drawer: const AppDrawer(),
        body: Card(
          child: ListTile(
            leading: const Icon(Icons.bluetooth),
            title: Text(widget.scanResult.device.name),
            subtitle: Text(
              'MacAddress: ${widget.scanResult.device.id}\n'
              'Type: ${widget.scanResult.device.type}\n'
              'RSSI: ${widget.scanResult.rssi}dBm\n'
              '---Advertise---\n'
              'LocalName: ${widget.scanResult.advertisementData.localName}\n'
              'UUID: ${widget.scanResult.advertisementData.serviceUuids}\n'
              'Manufacture: ${widget.scanResult.advertisementData.manufacturerData}\n',
            ),
          ),
        ));
  }
}
