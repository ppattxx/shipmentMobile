import 'package:flutter/material.dart';
import 'package:shipment_record/constants/color.dart';

class FormsScreen extends StatelessWidget {
  final List<Map<String, String>> scannedData;
  final String modelCode;

  const FormsScreen({Key? key, required this.scannedData, required this.modelCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scannedData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Forms"),
        ),
        body: Center(
          child: Text("No data available", style: TextStyle(fontSize: 20)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forms"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      headerCell("No", flex: 1),
                      headerCell("Serial Number", flex: 2),
                      headerCell("Warranty Card", flex: 2),
                      headerCell("Case A", flex: 2),
                      headerCell("PGI Label", flex: 2),
                      headerCell("Strapping Band", flex: 2),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical, // scroll vertical untuk baris data
                    child: Column(
                      children: [
                        for (int i = 0; i < scannedData.length; i++)
                          Row(
                            children: [
                              tableCell("${i + 1}", flex: 1),
                              tableCell(scannedData[i]['serialNumber'] ?? "-", flex: 2),
                              tableCell("No folded/broken", flex: 2),
                              tableCell("No defect, no broken, no dirt", flex: 2),
                              tableCell("Valid, no broken, not mixed out", flex: 2),
                              tableCell("Not loosen", flex: 2),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerCell(String text, {int flex = 1}) {
    return Flexible(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget tableCell(String text, {int flex = 1}) {
    return Flexible(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }
}

