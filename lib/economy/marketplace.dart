import 'package:uuid/uuid.dart';

import '../core/id_generator.dart';

/// Listing de marketplace player-to-player.
///
/// Offline: o jogador pode "postar" — entra na fila local e quando
/// conectar a um servidor premium, sincroniza pro mercado global.
/// Online: o servidor é a fonte da verdade — todas as listagens vivem lá.
class MarketListing {
  MarketListing({
    String? id,
    required this.sellerId,
    required this.sellerName,
    required this.itemId,
    required this.quantity,
    required this.pricePerUnit,
    DateTime? postedAt,
    DateTime? expiresAt,
  })  : id = id ?? const Uuid().v4(),
        postedAt = postedAt ?? DateTime.now(),
        expiresAt = expiresAt ?? DateTime.now().add(const Duration(days: 7));

  final String id;
  final PlayerId sellerId;
  final String sellerName;
  final String itemId;
  int quantity;
  final int pricePerUnit;
  final DateTime postedAt;
  final DateTime expiresAt;

  int get totalPrice => quantity * pricePerUnit;
  bool get expired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
        'id': id,
        'seller': sellerId.formatted,
        'seller_name': sellerName,
        'item': itemId,
        'qty': quantity,
        'price': pricePerUnit,
        'posted': postedAt.millisecondsSinceEpoch,
        'expires': expiresAt.millisecondsSinceEpoch,
      };

  factory MarketListing.fromJson(Map<String, dynamic> j) => MarketListing(
        id: j['id'] as String,
        sellerId: PlayerId.parse(j['seller'] as String),
        sellerName: j['seller_name'] as String,
        itemId: j['item'] as String,
        quantity: j['qty'] as int,
        pricePerUnit: j['price'] as int,
        postedAt: DateTime.fromMillisecondsSinceEpoch(j['posted'] as int),
        expiresAt: DateTime.fromMillisecondsSinceEpoch(j['expires'] as int),
      );
}

/// Gerenciador local de listings. Em produção fala com o servidor; aqui
/// mantém em memória + persistência simples.
class Marketplace {
  Marketplace._();
  static final Marketplace instance = Marketplace._();

  /// Taxa cobrada pela bolsa de Velmoria (5% do total).
  static const double brokerFeeRate = 0.05;

  final List<MarketListing> _listings = [];

  List<MarketListing> get listings =>
      List.unmodifiable(_listings.where((l) => !l.expired));

  /// Posta uma nova oferta. Retorna a listing criada.
  MarketListing post({
    required PlayerId sellerId,
    required String sellerName,
    required String itemId,
    required int quantity,
    required int pricePerUnit,
  }) {
    final l = MarketListing(
      sellerId: sellerId,
      sellerName: sellerName,
      itemId: itemId,
      quantity: quantity,
      pricePerUnit: pricePerUnit,
    );
    _listings.add(l);
    return l;
  }

  /// Cancela uma listing do próprio jogador.
  bool cancel(String listingId, PlayerId requester) {
    final i = _listings.indexWhere((l) => l.id == listingId);
    if (i == -1) return false;
    if (_listings[i].sellerId != requester) return false;
    _listings.removeAt(i);
    return true;
  }

  /// Resultado de uma tentativa de compra.
  MarketTradeResult buy({
    required String listingId,
    required int quantity,
    required int buyerCoins,
  }) {
    final l = _listings.firstWhere(
      (e) => e.id == listingId,
      orElse: () => throw StateError('Listing não encontrada'),
    );
    if (l.expired) return MarketTradeResult.fail('Listing expirou.');
    if (quantity > l.quantity) {
      return MarketTradeResult.fail('Estoque insuficiente.');
    }
    final total = quantity * l.pricePerUnit;
    final fee = (total * brokerFeeRate).round();
    if (buyerCoins < total) {
      return MarketTradeResult.fail('Lascas insuficientes.');
    }
    l.quantity -= quantity;
    if (l.quantity <= 0) _listings.remove(l);
    return MarketTradeResult.success(
      itemId: l.itemId,
      quantity: quantity,
      totalCost: total,
      brokerFee: fee,
      sellerReceives: total - fee,
      sellerId: l.sellerId,
    );
  }
}

class MarketTradeResult {
  MarketTradeResult({
    required this.success,
    this.error,
    this.itemId,
    this.quantity,
    this.totalCost,
    this.brokerFee,
    this.sellerReceives,
    this.sellerId,
  });

  final bool success;
  final String? error;
  final String? itemId;
  final int? quantity;
  final int? totalCost;
  final int? brokerFee;
  final int? sellerReceives;
  final PlayerId? sellerId;

  factory MarketTradeResult.fail(String reason) =>
      MarketTradeResult(success: false, error: reason);

  factory MarketTradeResult.success({
    required String itemId,
    required int quantity,
    required int totalCost,
    required int brokerFee,
    required int sellerReceives,
    required PlayerId sellerId,
  }) =>
      MarketTradeResult(
        success: true,
        itemId: itemId,
        quantity: quantity,
        totalCost: totalCost,
        brokerFee: brokerFee,
        sellerReceives: sellerReceives,
        sellerId: sellerId,
      );
}
