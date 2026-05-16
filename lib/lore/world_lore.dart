// Akyron RPG — Códex do Universo
//
// Lore original construído sobre influências de Black Clover, Bleach,
// Naruto, Demon Slayer, HxH, Fairy Tail, MHA e Jujutsu Kaisen, mas com
// nomes, geografia, mitologia e linha do tempo próprios. Este arquivo é
// a "bíblia" do jogo — UIs e diálogos leem daqui.

class LoreEntry {
  const LoreEntry({
    required this.id,
    required this.title,
    required this.body,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String body;
  final List<String> tags;
}

class WorldLore {
  WorldLore._();

  static const String worldName = 'Akyron';
  static const String calendarEra = 'Pós-Fratura (PF)';
  static const int currentYear = 412; // 412 anos depois da Fratura do Éon.

  // ───────────────────────────────────────────────────────────────────
  // GÊNESE
  // ───────────────────────────────────────────────────────────────────
  static const LoreEntry origin = LoreEntry(
    id: 'lore.origin',
    title: 'A Fratura do Éon',
    body: '''
Antes da Fratura, todo poder em Akyron vinha de uma só fonte: o Éon, um
rio invisível que circulava entre os vivos como sangue circula num corpo.
Quem aprendia a "ouvir" o rio podia desviar suas correntes — era assim
que os antigos faziam mágica, profecia e cura.

Há 412 anos, durante o Eclipse Triplo, o Éon partiu. Ninguém sabe se foi
intervenção divina, sabotagem dos Reis-Sacerdotes ou simplesmente o peso
de ter sido esticado demais. O fato é que o rio se quebrou em SEIS
correntes distintas, cada uma com regras próprias, e essas correntes
afundaram em regiões diferentes do continente.

Onde uma corrente caiu, uma cultura inteira se reorganizou em volta dela.
Hoje, cada nação domina uma — e teme as outras cinco.
''',
    tags: ['origem', 'éon', 'fratura'],
  );

  // ───────────────────────────────────────────────────────────────────
  // AS SEIS CORRENTES
  // ───────────────────────────────────────────────────────────────────
  static const List<LoreEntry> currents = [
    LoreEntry(
      id: 'current.grimoire',
      title: 'Corrente do Verbo — Velmoria',
      body: '''
A primeira corrente caiu sobre as torres-bibliotecas de Velmoria. Em
contato com pergaminho e tinta, virou linguagem: cada mago aprende a
"ler" um Grimório que escolhe ele, não o contrário.

Grimórios variam de 1 a 5 folhas. Quanto mais folhas, mais espaço para
magias — e mais raro o livro. Existem registros confiáveis de apenas 9
Grimórios de 5 folhas em toda história de Akyron.
''',
      tags: ['grimório', 'velmoria'],
    ),
    LoreEntry(
      id: 'current.spirit_steel',
      title: 'Corrente do Aço-Espírito — Shirogane',
      body: '''
Na ilha-fortaleza de Shirogane, a corrente se prendeu ao metal. Cada arma
forjada lá nasce com um espírito dentro — uma personalidade própria que
precisa ser conquistada. Conversar com o espírito desbloqueia a forma
liberada (Shikai), e dominá-lo desbloqueia a forma suprema (Bankai).

Diz a lenda que nenhum Bankai existe sem que o portador tenha,
literalmente, perdido algo de si para conquistar a confiança da arma.
''',
      tags: ['zanpakutō', 'shirogane'],
    ),
    LoreEntry(
      id: 'current.chakra',
      title: 'Corrente do Sopro Vital — Konsho',
      body: '''
Em Konsho a corrente penetrou os corpos: o povo aprendeu a misturar
energia física e espiritual em uma única reserva — o Sopro, chamado
internamente de chakra. Selos manuais antigos modulam essa reserva em
técnicas chamadas Jutsus.

Konsho é dividida em vilas (Folha-do-Lago, Areia-do-Sul, Trovão-do-Norte,
Névoa-do-Mar, Pedra-da-Borda), e cada uma desenvolveu seus próprios
elementos dominantes.
''',
      tags: ['chakra', 'konsho', 'jutsu'],
    ),
    LoreEntry(
      id: 'current.breathing',
      title: 'Corrente do Hálito Elemental — Karasuho',
      body: '''
Na floresta-cordilheira de Karasuho a corrente assumiu forma de ar — mas
só responde quando o usuário coordena respiração, postura e lâmina ao
mesmo tempo. Cada estilo de Respiração (Água, Chama, Trovão, Pedra,
Vento, Bruma, Sol) tem dez Formas numeradas, e as Formas Superiores são
guardadas em pergaminhos selados.

Os praticantes são caçadores oficiais dos Devoradores, criaturas que
nasceram justamente das partes corrompidas do Éon na Fratura.
''',
      tags: ['respiração', 'karasuho', 'devoradores'],
    ),
    LoreEntry(
      id: 'current.nen',
      title: 'Corrente da Aura — Yorokai',
      body: '''
Em Yorokai a corrente virou aura visível: uma camada de energia que cada
ser vivo carrega ao redor do corpo. A aura tem seis afinidades —
Reforço, Emissão, Manipulação, Materialização, Transmutação e Conjuração
— e o despertar revela a sua.

Quem domina o Nen pode construir uma habilidade pessoal sob regras
auto-impostas: quanto mais rígido o juramento, mais forte o poder.
''',
      tags: ['nen', 'yorokai', 'aura'],
    ),
    LoreEntry(
      id: 'current.cursed',
      title: 'Corrente da Marca Amaldiçoada — Sukhenna',
      body: '''
A última corrente foi a mais escura. Caiu nos pântanos de Sukhenna e
contaminou os sentimentos negativos da população. Hoje, todos em
Sukhenna nascem com uma Marca, e a maioria nunca aprende a controlar a
energia que sai dela.

Os poucos que aprendem viram Feiticeiros Amaldiçoados — capazes de
abrir uma "Expansão de Território", uma arena alternativa onde sua
técnica nunca erra. O preço: cada Expansão deixa cicatrizes
psicológicas no usuário.
''',
      tags: ['energia amaldiçoada', 'sukhenna'],
    ),
  ];

  // ───────────────────────────────────────────────────────────────────
  // FACÇÕES & ORDENS
  // ───────────────────────────────────────────────────────────────────
  static const List<LoreEntry> factions = [
    LoreEntry(
      id: 'faction.golden_quill',
      title: 'Ordem da Pena Dourada',
      body: '''
Ordem internacional de magos de Grimório que tenta unir as nações por
contrato — em vez de guerra. Sede em Velmoria, embaixadas nas seis
capitais. Lema: "A tinta que escreveu o mundo pode reescrevê-lo."
''',
    ),
    LoreEntry(
      id: 'faction.silver_hilt',
      title: 'Punhos de Prata',
      body: '''
Sociedade fechada de Shirogane: cada membro é dono de um zanpaku-tō
liberado pelo menos em Shikai. Patrulham a fronteira marítima e caçam
piratas-fantasma.
''',
    ),
    LoreEntry(
      id: 'faction.crow_hunters',
      title: 'Esquadrão Asa de Corvo',
      body: '''
Caçadores de Devoradores baseados em Karasuho. Estrutura militar com
Patentes do Sol, da Lua e da Bruma. Não fazem prisioneiros.
''',
    ),
    LoreEntry(
      id: 'faction.broken_seal',
      title: 'Os do Selo Quebrado',
      body: '''
Antagonistas principais. Acreditam que a única forma de "consertar" o
Éon é destruir o que sobrou dele — derretendo as Seis Correntes de volta
em uma só, mesmo que isso custe Akyron inteiro.
''',
    ),
  ];

  // ───────────────────────────────────────────────────────────────────
  // GEOGRAFIA
  // ───────────────────────────────────────────────────────────────────
  static const List<LoreEntry> regions = [
    LoreEntry(
      id: 'region.starthorn',
      title: 'Vila de Espinho-de-Estrela',
      body: 'Vila de origem do jogador. Pequena, na orla da Floresta Arcana, '
          'em rota das caravanas de Velmoria. Aqui você desperta sua corrente.',
    ),
    LoreEntry(
      id: 'region.arcane_forest',
      title: 'Floresta Arcana',
      body: 'Árvores que registram em suas cascas todo feitiço já lançado '
          'sob seus galhos. Bestas espirituais e cogumelos rúnicos. Primeira '
          'região de exploração livre.',
    ),
    LoreEntry(
      id: 'region.mage_tower',
      title: 'Torre dos Magos',
      body: 'Espiral de 99 andares em Velmoria. Cada andar é uma prova. Quem '
          'chega ao 99º recebe acesso ao Arquivo Proibido.',
    ),
    LoreEntry(
      id: 'region.spirit_plane',
      title: 'Plano Espiritual',
      body: 'Dimensão paralela onde os espíritos das zanpaku-tō vivem. '
          'Acessível por meditação ou por morte temporária.',
    ),
    LoreEntry(
      id: 'region.cursed_lands',
      title: 'Terras Amaldiçoadas',
      body: 'Antigo território de Sukhenna engolido pela própria corrente. '
          'Atmosfera densa, encontros aleatórios brutais, recompensas '
          'lendárias.',
    ),
    LoreEntry(
      id: 'region.demon_keep',
      title: 'Masmorra do Rei Demônio',
      body: 'O esconderijo do líder dos do Selo Quebrado. Endgame. Boss '
          'final da história principal.',
    ),
  ];

  // ───────────────────────────────────────────────────────────────────
  // MITOLOGIA EXTRA
  // ───────────────────────────────────────────────────────────────────
  static const LoreEntry transcendents = LoreEntry(
    id: 'lore.transcendents',
    title: 'Os Transcendentes',
    body: '''
Existem rumores de seres raríssimos que dominam DUAS correntes ao mesmo
tempo. Em toda a história de Akyron, apenas três Transcendentes
confirmados:

- Iyari de Velmoria — Grimório + Energia Amaldiçoada
- Tenshi do Aço Branco — Zanpaku-tō + Respiração
- "O Sem-Nome" — corrente desconhecida + qualquer outra

Quem completa o post-game pode, talvez, virar o quarto.
''',
  );

  // Helper para UI do códex.
  static List<LoreEntry> all() => [
        origin,
        ...currents,
        ...factions,
        ...regions,
        transcendents,
      ];

  static LoreEntry? byId(String id) =>
      all().where((e) => e.id == id).cast<LoreEntry?>().firstOrNull;
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
