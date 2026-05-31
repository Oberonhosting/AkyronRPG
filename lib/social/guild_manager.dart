import '../core/constants.dart';
import '../core/id_generator.dart';

enum GuildRole { master, officer, member, recruit }

class GuildMember {
  GuildMember({required this.id, required this.name, required this.role});
  PlayerId id;
  String name;
  GuildRole role;
}

class Guild {
  Guild({
    required this.id,
    required this.name,
    required this.banner,
    required this.lore,
    required this.master,
    List<GuildMember>? members,
  }) : members = members ?? [];

  final String id;
  String name;
  String banner;       // tag visual ex.: "🜂", "✶"
  String lore;
  PlayerId master;
  List<GuildMember> members;

  bool get isFull => members.length >= AkyronK.maxGuildSize;

  bool addMember(PlayerId id, String name) {
    if (isFull) return false;
    if (members.any((m) => m.id == id)) return false;
    members.add(GuildMember(id: id, name: name, role: GuildRole.recruit));
    return true;
  }

  bool promote(PlayerId id) {
    final m = members.firstWhere(
      (m) => m.id == id,
      orElse: () => GuildMember(id: id, name: '', role: GuildRole.recruit),
    );
    if (m.name.isEmpty) return false;
    m.role = switch (m.role) {
      GuildRole.recruit => GuildRole.member,
      GuildRole.member => GuildRole.officer,
      GuildRole.officer => GuildRole.master,
      GuildRole.master => GuildRole.master,
    };
    return true;
  }
}
