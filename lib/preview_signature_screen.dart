import 'dart:typed_data';

import 'package:flutter/material.dart';
class PreviewSignatureScreen extends StatelessWidget {
  final Uint8List signature;
  const PreviewSignatureScreen({Key? key,
    required this.signature

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Preview Signature'),
      ),
      body: Center(
        child: Image.memory(signature),
      ),
    );
  }
}



