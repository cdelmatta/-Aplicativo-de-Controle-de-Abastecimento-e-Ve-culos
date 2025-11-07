class Veiculo {
  String id;
  String modelo;
  String marca;
  String placa;
  int ano;
  String tipoCombustivel;

  Veiculo({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.tipoCombustivel,
  });

  Map<String, dynamic> toMap() => {
    'modelo': modelo,
    'marca': marca,
    'placa': placa,
    'ano': ano,
    'tipoCombustivel': tipoCombustivel,
  };

  factory Veiculo.fromMap(String id, Map<String, dynamic> data) => Veiculo(
    id: id,
    modelo: (data['modelo'] ?? '') as String,
    marca: (data['marca'] ?? '') as String,
    placa: (data['placa'] ?? '') as String,
    ano: (data['ano'] ?? 0) as int,
    tipoCombustivel: (data['tipoCombustivel'] ?? '') as String,
  );
}
