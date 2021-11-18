import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:phone_connect/pages/detail.dart';

import '../drawer.dart';

class BluetoothPage extends StatefulWidget {
  static const String roxuteName = '/setting';

  const BluetoothPage({Key? key}) : super(key: key);

  @override
  State<BluetoothPage> createState() => _BluetoothPage();
}

class _BluetoothPage extends State<BluetoothPage> {
  @override
  void initState() {
    super.initState();
    // Start scanning
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));

// Stop scanning
//     FlutterBlue.instance.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bluetooth"),
        ),
        drawer: const AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => FlutterBlue.instance
              .startScan(timeout: const Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Card(
                  elevation: 4,
                  child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Center(child: Text('Title'))),
                ),
                StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ScanResult>> snapshot) {
                      if (!snapshot.hasData) {
                        return Column(
                          children: const [Text('no data')],
                        );
                      }
                      if (snapshot.hasError) {
                        return Column(
                          children: const [Text('Error')],
                        );
                      }
                      return Column(
                        children: snapshot.data!
                            .map<Widget>((e) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          BleDetailPage(
                                        scanResult: e,
                                      ),
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.bluetooth),
                                    title: Text(e.device.name),
                                    subtitle: Text(
                                      'MacAddress: ${e.device.id}\n'
                                      'Type: ${e.device.type}\n'
                                      'RSSI: ${e.rssi}dBm\n',
                                    ),
                                  ),
                                )
                                // Text('${e.device.name}')
                                ))
                            .toList(),
                      );
                    })
              ],
            ),
          ), // ListView(
        ));
  }
}
