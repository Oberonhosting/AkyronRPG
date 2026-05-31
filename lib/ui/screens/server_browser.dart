import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../models/enums.dart';
import '../../network/server_manager.dart';
import '../../network/server_types.dart';

class ServerBrowser extends StatefulWidget {
  const ServerBrowser({super.key});

  @override
  State<ServerBrowser> createState() => _ServerBrowserState();
}

class _ServerBrowserState extends State<ServerBrowser> {
  final _manager = ServerManager();
  List<ServerDescriptor> _servers = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final list = await _manager.refresh();
    setState(() => _servers = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servidores'),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.public_off, color: AkyronTheme.goldEon),
            title: Text('Modo Offline'),
            subtitle: Text('Campanha completa, dungeons e progressão local. Save em SQLite.'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(height: 1),
          ..._servers.map(_serverTile),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(
              icon: const Icon(Icons.lock),
              label: const Text('Criar servidor privado com senha'),
              onPressed: _showCreatePrivate,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _serverTile(ServerDescriptor s) {
    final pingColor = s.ping < 60
        ? AkyronTheme.cyanSpirit
        : s.ping < 130
            ? AkyronTheme.goldEon
            : AkyronTheme.crimsonAura;
    return ListTile(
      title: Row(
        children: [
          Text(s.badge, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(child: Text(s.name)),
        ],
      ),
      subtitle: Row(
        children: [
          Icon(Icons.person, size: 12, color: AkyronTheme.paperBeige.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text('${s.players}/${s.maxPlayers}'),
          const SizedBox(width: 16),
          Text('${s.ping}ms', style: TextStyle(color: pingColor)),
          if (s.antiCheat) ...[
            const SizedBox(width: 12),
            const Icon(Icons.shield, size: 12, color: AkyronTheme.cyanSpirit),
          ],
        ],
      ),
      trailing: s.kind == ServerKind.privateRoom
          ? const Icon(Icons.lock, size: 16)
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Em produção: abre Connection.open() e navega para GameScreen
        // com o avatar selecionado.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Conectando em ${s.name}...')),
        );
      },
    );
  }

  void _showCreatePrivate() {
    final nameCtrl = TextEditingController(text: 'Sala do meu clã');
    final hostCtrl = TextEditingController(text: 'mygamehost.example');
    final passCtrl = TextEditingController(text: 'akyron123');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Servidor privado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: hostCtrl, decoration: const InputDecoration(labelText: 'Host')),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              _manager.createPrivate(
                name: nameCtrl.text,
                host: hostCtrl.text,
                password: passCtrl.text,
              );
              Navigator.pop(ctx);
              _refresh();
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }
}
