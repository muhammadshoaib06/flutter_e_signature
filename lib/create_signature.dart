import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_e_signature/preview_signature_screen.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart' as sysPath;

class CreateSignature extends StatefulWidget {
  const CreateSignature({Key? key}) : super(key: key);

  @override
  _CreateSignatureState createState() => _CreateSignatureState();
}

class _CreateSignatureState extends State<CreateSignature> {
  SignatureController _controller = SignatureController(
    penStrokeWidth: 2,

    /// signature pen color
    penColor: Colors.black,

    /// signature background color when exported!
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();

    _controller.addListener(() => print('Value changed'));
  }

  @override
  void dispose() {
    /// here dispose the controller of the signature controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Signature'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Flutter E-Signature',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Signature(
                height: 450,
                controller: _controller,
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      if (_controller.isNotEmpty) {
                        final signature = await exportSignature();

                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PreviewSignatureScreen(
                                  signature: signature!,
                                )));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(content: Text('Signature is empty.'))
                        );
                      }
                    },
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Navigate',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        )),
                  )),
                  Expanded(
                      child: InkWell(
                    onTap: () => _controller.clear(),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        )),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> exportSignature() async {
    final exportSignatureController = SignatureController(
        penStrokeWidth: 2,
        penColor: Colors.white,
        exportBackgroundColor: Colors.black,
        points: _controller.points);

    final signature = await exportSignatureController.toPngBytes();
    _controller.clear();
    return signature;
  }
}
