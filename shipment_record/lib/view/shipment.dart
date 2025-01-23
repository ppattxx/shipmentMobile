import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; // Import font Google Fonts
import 'package:shipment_record/api/api_shipment.dart';
import 'package:shipment_record/constants/color.dart';
import 'package:shipment_record/models/model_code.dart';

class ShipmentInputScreen extends StatefulWidget {
  @override
  _ShipmentInputScreenState createState() => _ShipmentInputScreenState();
}

class _ShipmentInputScreenState extends State<ShipmentInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  final TextEditingController _containerNoController = TextEditingController();
  final TextEditingController _sealNoController = TextEditingController();
  final TextEditingController _truckPoliceNoController = TextEditingController();

  String? _selectedModel;

  List<ModelCode> _models = [];

  @override
  void initState() {
    super.initState();
    _fetchModelCodes();
  }

  void _fetchModelCodes() async {
    try {
      List<ModelCode> modelCodes = await ApiShipment().fetchModelCodes();
      if (mounted) {
        setState(() {
          _models = modelCodes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load model codes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'Input Shipment Data',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildTextField('Date of Shipment', _dateController, Icons.calendar_today, true),
                        SizedBox(height: 16),
                        _buildDropdownField('Model', _selectedModel, _models, (value) => setState(() => _selectedModel = value)),
                        SizedBox(height: 16),
                        _buildTextField('Quantity Shipment', TextEditingController(text: '150'), Icons.production_quantity_limits, true),
                        SizedBox(height: 16),
                        _buildTextField('Container No.', _containerNoController, Icons.local_shipping, false),
                        SizedBox(height: 16),
                        _buildTextField('Seal No.', _sealNoController, Icons.lock, false),
                        SizedBox(height: 16),
                        _buildTextField('Truck Police No.', _truckPoliceNoController, Icons.directions_car, false),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    borderRadius: BorderRadius.circular(6),
                    elevation: 5,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Data berhasil disimpan')),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          child: Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool readOnly) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      style: GoogleFonts.poppins(color: Colors.black),  // Set font to Poppins
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.black),  // Set font to Poppins
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null || value.isEmpty ? '$label tidak boleh kosong' : null,
    );
  }

  Widget _buildDropdownField(String label, String? value, List<dynamic> items, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.black),  // Set font to Poppins
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((item) => DropdownMenuItem<String>(value: item.modelCodeId, child: Text(item.modelName, style: GoogleFonts.poppins()))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Pilih $label' : null,
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _containerNoController.dispose();
    _sealNoController.dispose();
    _truckPoliceNoController.dispose();
    super.dispose();
  }
}
