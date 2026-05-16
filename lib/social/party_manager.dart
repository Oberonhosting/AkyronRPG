import '../core/constants.dart';
import '../core/id_generator.dart';

class PartyMember {
  PartyMember({required this.id, required this.name, this.leader = false});
  PlayerId id;
  String name;
  bool leader;
}

class PartyManager {
  PartyManager({PlayerId? leaderId, String? leaderName}) {
    if (leaderId != null) {
      members.add(PartyMember(
          id: leaderId, name: leaderName ?? leaderId.handle, leader: true));
    }
  }

  final List<PartyMember> members = [];

  bool get isFull => members.length >= AkyronK.maxPartySize;
  bool get isEmpty => members.isEmpty;

  /// Convida — em produção dispara packet partyInvite ao servidor.
  bool invite(PlayerId id, String name) {
    if (isFull) return false;
    if (members.any((m) => m.id == id)) return false;
    members.add(PartyMember(id: id, name: name));
    return true;
  }

  void leave(PlayerId id) {
    members.removeWhere((m) => m.id == id);
    if (members.isNotEmpty && !members.any((m) => m.leader)) {
      members.first.leader = true; // promove o próximo.
    }
  }
}
