import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shipment_record/models/model_code.dart';

class ApiShipment {
  final String baseUrl = 'http://10.83.34.43/ShipApi/api/Shipment'; 

  // Method untuk mengambil model codes dari API
  Future<List<ModelCode>> fetchModelCodes() async {
    final response = await http.get(Uri.parse('$baseUrl/GetAllModelCode'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      // Pastikan key 'value' ada dan bukan null
      if (data['value'] != null) {
        List<dynamic> modelData = data['value']; 
        
        // Konversi data list menjadi List<ModelCode>
        return modelData.map((json) => ModelCode.fromJson(json)).toList();
      } else {
        throw Exception('No model data found');
      }
    } else {
      throw Exception('Failed to load model codes');
    }
  }
}

