import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:convert/convert.dart';
import 'package:phone_connect/pages/service/tethering_on.dart';

import '../drawer.dart';
import 'service/get_battery.dart';

class BleDetailPage extends StatefulWidget {
  final ScanResult scanResult;
  static const String roxuteName = '/detail';

  const BleDetailPage({Key? key, required this.scanResult}) : super(key: key);

  @override
  State<BleDetailPage> createState() => _BleDetailPage();
}

class _BleDetailPage extends State<BleDetailPage> {
  String _password = '';

  void _handlePasswordText(String e) {
    setState(() {
      _password = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BleDetailPage(${widget.scanResult.device.name})'),
        ),
        drawer: const AppDrawer(),
        body: Column(children: <Widget>[
          Card(
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
          ),
          TextField(
            enabled: true,
            maxLength: 30,
            maxLengthEnforced: false,
            style: const TextStyle(color: Colors.red),
            obscureText: false,
            maxLines: 1,
            onChanged: _handlePasswordText,
          ),
          ElevatedButton(
            child: const Text('バッテリー残高'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => GetBatteryPage(
                    bluetoothDevice: widget.scanResult.device,
                  ),
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('テザリング　オン'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => TetheringOnPage(
                    bluetoothDevice: widget.scanResult.device,
                  ),
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
          ElevatedButton(
            child: const Text('テザリング　オフ'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
            ),
            onPressed: () {},
          ),
          ElevatedButton(
            child: const Text('Test1'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
            onPressed: () {
              print('start');
              const text = "test";
              List<int> bytes = text.codeUnits;
              print(bytes);
              // print(hex.decode('test'));
              // for (int i = 0; i <= text.length - 8; i += 8) {
              //   final hex = text.substring(i, i + 8);
              //
              //   final number = int.parse(hex, radix: 16);
              //   print(number);
              // }
            },
          ),
          ElevatedButton(
            child: const Text('Test2'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
            onPressed: () {},
          ),
        ]));
  }
}
