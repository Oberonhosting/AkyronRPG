import 'package:uuid/uuid.dart';

/// Armazenamento simples de listagens de marketplace.
///
/// MVP em memória: para produção, plugar Postgres / SQLite / Redis.
class MarketplaceStore {
  final Map<String, Map<String, dynamic>> _listings = {};

  String add(Map<String, dynamic> data) {
    final id = const Uuid().v4();
    _listings[id] = {
      'id': id,
      'seller': data['seller'],
      'seller_name': data['seller_name'],
      'item': data['item'],
      'qty': data['qty'],
      'price': data['price'],
      'posted': DateTime.now().millisecondsSinceEpoch,
      'expires': DateTime.now()
          .add(const Duration(days: 7))
          .millisecondsSinceEpoch,
    };
    return id;
  }

  List<Map<String, dynamic>> listAll() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _listings.removeWhere((_, v) => (v['expires'] as int) < now);
    return _listings.values.toList();
  }

  bool cancel(String id, String seller) {
    final l = _listings[id];
    if (l == null) return false;
    if (l['seller'] != seller) return false;
    _listings.remove(id);
    return true;
  }
}
