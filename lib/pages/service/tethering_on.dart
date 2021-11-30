import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:phone_connect/pages/etc/etc.dart';
import 'package:crypto/crypto.dart';

class TetheringOnPage extends StatefulWidget {
  final BluetoothDevice bluetoothDevice;
  static const String roxuteName = '/detail';

  const TetheringOnPage({Key? key, required this.bluetoothDevice})
      : super(key: key);

  @override
  State<TetheringOnPage> createState() => _TetheringOnPage();
}

class _TetheringOnPage extends State<TetheringOnPage> {
  String _status = 'Connecting.....';
  String preSharedKey = "share_key";
  Map<String, String> mapList = {};

  Future<int> _getBattery() async {
    int _battery = -1;
    await widget.bluetoothDevice.connect();
    _status = 'Connected';
    List<BluetoothService> services =
        await widget.bluetoothDevice.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == "a9d158bb-9007-4fe3-b5d2-d3696a3eb067") {
        // if (service.uuid.toString() == "52dc2801-7e98-4fc2-908a-66161b5959b0") {
        // _battery = data[0];
        print("length: " + service.characteristics.length.toString());

        var preSharedHashKey =
            sha256.convert(utf8.encode(preSharedKey)).toString();
        // phase0
        // print("bytes");
        // const text = "test";
        print("===phase0(Send)===");
        mapList['server_address'] = widget.bluetoothDevice.id.id;
        mapList['client_random'] = randomString(20);
        var sendBytes = ("!" + mapList['client_random']!).codeUnits;
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.write) {
            await characteristic.write(sendBytes);
            break;
          }
        }
        // phase 1
        print("===phase1(Receive)===");
        print(mapList['client_random']! + preSharedHashKey);
        var mixPhase1Hash = sha256
            .convert(utf8.encode(mapList['client_random']! + preSharedHashKey))
            .toString();
        print("mixPhase1Hash: " + mixPhase1Hash);

        var phase1Complete = false;

        for (var characteristic in service.characteristics) {
          if (characteristic.properties.read) {
            List<int> read = await characteristic.read();
            var decoded = utf8.decode(read);
            print("Server: " + decoded);
            if (decoded[0] == '!') {
              print(decoded.substring(1));
              var decodedArray = decoded.substring(1).split(',');
              print(decodedArray);
              print("phase1(Server) mixHash: " + decodedArray[0]);
              print("phase1(Client) mixHash: " + mixPhase1Hash);
              mapList['server_random'] = decodedArray[1];
              phase1Complete = true;
            } else {
              print("error");
            }
            // print(utf8.decode(read));
            // print(utf8.decode(read)[0]);
            break;
          }
        }
        // phase1に失敗の場合、
        if (!phase1Complete) {
          return _battery;
        }

        // phase2
        var mixPhase2Hash = sha256
            .convert(utf8.encode(mapList['server_random']! +
                mapList['client_random']! +
                preSharedHashKey))
            .toString();
        print("mixPhase2Hash: " + mixPhase2Hash);
        sendBytes = ("@" + mixPhase2Hash).codeUnits;
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.write) {
            await characteristic.write(sendBytes);
            break;
          }
        }
        // phase3
        var mixPhase3Tmp =
            mapList['server_random']! + mapList['client_random']!;
        var mixPhase3TmpHash =
            sha256.convert(utf8.encode(mixPhase3Tmp)).toString();
        var mixPhase3 = mixPhase3TmpHash + preSharedHashKey;
        var mixPhase3Hash = sha256.convert(utf8.encode(mixPhase3)).toString();
        print("AccessToken: " + mixPhase3Hash);
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
              // print(snapshot);
              // if (snapshot.hasData) {
              //   if (snapshot.data == -1) {
              //     return const Text("データが取得できません");
              //   } else {
              //     return Text(snapshot.data.toString() + "%");
              //   }
              // } else {
              //   return const Text("データの取得中です");
              // }
              return const Text("Test");
            },
          ),
          // Text(_status),
          // Text("Battery: " + _battery.toString() + "%")
        ]));
  }
}
