class ModelCode {
  final String modelCodeId;
  final String modelName;

  ModelCode({required this.modelCodeId, required this.modelName});

  // Method untuk membuat instance dari JSON dengan pemeriksaan null
  factory ModelCode.fromJson(Map<String, dynamic> json) {
    return ModelCode(
      modelCodeId: json['modelCodeId'] ?? '',  
      modelName: json['modelNumber'] ?? '',    
    );
  }
}
