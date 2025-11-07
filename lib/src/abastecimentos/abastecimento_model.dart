class Abastecimento {
  String id;
  DateTime data;
  double quantidadeLitros;
  double valorPago;
  int quilometragem;
  String tipoCombustivel;
  String veiculoId;
  String? observacao;
  double? consumo;

  Abastecimento({
    required this.id,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.veiculoId,
    this.observacao,
    this.consumo,
  });

  Map<String, dynamic> toMap() => {
    'data': data.toIso8601String(),
    'quantidadeLitros': quantidadeLitros,
    'valorPago': valorPago,
    'quilometragem': quilometragem,
    'tipoCombustivel': tipoCombustivel,
    'veiculoId': veiculoId,
    'observacao': observacao,
    'consumo': consumo,
  };

  factory Abastecimento.fromMap(String id, Map<String, dynamic> d) => Abastecimento(
    id: id,
    data: DateTime.tryParse(d['data'] ?? '') ?? DateTime.now(),
    quantidadeLitros: (d['quantidadeLitros'] ?? 0).toDouble(),
    valorPago: (d['valorPago'] ?? 0).toDouble(),
    quilometragem: (d['quilometragem'] ?? 0) as int,
    tipoCombustivel: (d['tipoCombustivel'] ?? '') as String,
    veiculoId: (d['veiculoId'] ?? '') as String,
    observacao: d['observacao'] as String?,
    consumo: (d['consumo'] as num?)?.toDouble(),
  );
}
