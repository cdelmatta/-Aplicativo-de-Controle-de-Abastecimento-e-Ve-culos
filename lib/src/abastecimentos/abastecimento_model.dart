import 'package:cloud_firestore/cloud_firestore.dart';

class Abastecimento {
  final String id;
  final DateTime data;
  final double quantidadeLitros;
  final double valorPago;
  final int quilometragem;
  final String tipoCombustivel;
  final String? veiculoId;
  final String? observacao;
  final double? consumo;

  Abastecimento({
    required this.id,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    this.veiculoId,
    this.observacao,
    this.consumo,
  });

  factory Abastecimento.fromMap(String id, Map<String, dynamic> m) {
    DateTime parseData(dynamic raw) {
      if (raw is Timestamp) return raw.toDate();
      if (raw is DateTime) return raw;
      if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
      return DateTime.now();
    }

    return Abastecimento(
      id: id,
      data: parseData(m['data']),
      quantidadeLitros: (m['quantidadeLitros'] as num?)?.toDouble() ?? 0.0,
      valorPago: (m['valorPago'] as num?)?.toDouble() ?? 0.0,
      quilometragem: (m['quilometragem'] as num?)?.toInt() ?? 0,
      tipoCombustivel: (m['tipoCombustivel'] as String?) ?? 'Gasolina',
      veiculoId: m['veiculoId'] as String?,
      observacao: m['observacao'] as String?,
      consumo: (m['consumo'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'data': data,
        'quantidadeLitros': quantidadeLitros,
        'valorPago': valorPago,
        'quilometragem': quilometragem,
        'tipoCombustivel': tipoCombustivel,
        'veiculoId': veiculoId,
        'observacao': observacao,
        'consumo': consumo,
      };
}
