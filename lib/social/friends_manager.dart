import '../core/id_generator.dart';

class Friend {
  Friend({
    required this.playerId,
    required this.nickname,
    this.online = false,
    this.lastSeen,
    this.serverId,
  });

  PlayerId playerId;
  String nickname;
  bool online;
  DateTime? lastSeen;
  String? serverId;
}

class FriendsManager {
  final List<Friend> _friends = [];

  List<Friend> get all => List.unmodifiable(_friends);

  bool add(PlayerId id, {String? nickname}) {
    if (_friends.any((f) => f.playerId == id)) return false;
    _friends.add(Friend(
      playerId: id,
      nickname: nickname ?? id.handle,
      lastSeen: DateTime.now(),
    ));
    return true;
  }

  bool remove(PlayerId id) {
    final i = _friends.indexWhere((f) => f.playerId == id);
    if (i == -1) return false;
    _friends.removeAt(i);
    return true;
  }

  void updatePresence(PlayerId id,
      {bool? online, String? serverId, DateTime? lastSeen}) {
    final f = _friends.firstWhere(
      (f) => f.playerId == id,
      orElse: () => Friend(playerId: id, nickname: id.handle),
    );
    if (online != null) f.online = online;
    if (serverId != null) f.serverId = serverId;
    if (lastSeen != null) f.lastSeen = lastSeen;
  }
}
