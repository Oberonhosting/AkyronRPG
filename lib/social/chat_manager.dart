import 'dart:async';

import '../core/id_generator.dart';

enum ChatChannel { global, server, party, guild, whisper, system }

class ChatMessage {
  ChatMessage({
    required this.channel,
    required this.senderId,
    required this.senderName,
    required this.text,
    DateTime? ts,
  }) : ts = ts ?? DateTime.now();

  final ChatChannel channel;
  final PlayerId senderId;
  final String senderName;
  final String text;
  final DateTime ts;
}

class ChatManager {
  final _ctrl = StreamController<ChatMessage>.broadcast();
  final List<ChatMessage> _history = [];

  Stream<ChatMessage> get stream => _ctrl.stream;
  List<ChatMessage> get history => List.unmodifiable(_history);

  void post(ChatMessage m) {
    _history.add(m);
    if (_history.length > 500) _history.removeAt(0);
    _ctrl.add(m);
  }

  /// Emite mensagem do sistema (NPC, anúncio).
  void system(String text) {
    final pid = PlayerId('Sistema', '0000');
    post(ChatMessage(
      channel: ChatChannel.system,
      senderId: pid,
      senderName: 'Akyron',
      text: text,
    ));
  }

  void dispose() => _ctrl.close();
}
