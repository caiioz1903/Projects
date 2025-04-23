import 'dart:io';
import 'dart:math';

void main() {
  Jogador jogador = Jogador("Héroi", 100, 3);
  Inimigo inimigo = Inimigo("Vilão", 100);

  print("Começou a batalha entre ${jogador.nome} e ${inimigo.nome}!\n");

  while (jogador.vida > 0 && inimigo.vida > 0) {
    print("Vida do ${jogador.nome}: ${jogador.mostrarBarraVida()} - ${jogador.vida}");
    print("Vida do ${inimigo.nome}: ${inimigo.mostrarBarraVida()} - ${inimigo.vida}");

    print("\nEscolha sua ação:");
    print("1. Ataque leve (80% de chance, 10 de dano)");
    print("2. Ataque médio (60% de chance, 20 de dano)");
    print("3. Ataque forte (40% de chance, 30 de dano)");
    print("4. Usar poção (cura 20 de vida, você tem ${jogador.pocoes} poções");
    stdout.write(">> ");
    String? entrada = stdin.readLineSync();

    int acao = int.tryParse(entrada ?? '') ?? 0;
    if (acao == 4) {
      jogador.usarPocao();
    } else {
    jogador.atacar(inimigo, acao);
    }
    
    if (inimigo.vida <= 0) break;

    inimigo.atacar(jogador);
    print("\n--------------------------\n");
  }

  if (jogador.vida <= 0) {
    print("${jogador.nome} foi derrotado! Fim de jogo.");
  } else {
    print("${inimigo.nome} foi derrotado! Você venceu!");
  }
}

class Personagem {
  String nome;
  int vida;

  Personagem(this.nome, this.vida);

  void levarDano(int dano) {
    vida -= dano;
    if (vida < 0) vida = 0;
  }
  String mostrarBarraVida() {
    int totalBlocos = 20; 
    int blocosCheios = (vida / 100 * totalBlocos).toInt();
    int blocosVazios = totalBlocos - blocosCheios;

    String barra = "█" * blocosCheios + "░" * blocosVazios;
    return barra;
  }
}

class Jogador extends Personagem {
  int pocoes;
  
  Jogador(String nome, int vida, this.pocoes) : super(nome, vida);

  void atacar(Inimigo inimigo, int escolha) {
    int chance = Random().nextInt(100);
    int dano = 0;
    String tipo = "";

    switch (escolha) {
      case 1:
        tipo = "leve";
        if (chance < 80) dano = 10;
        break;
      case 2:
        tipo = "médio";
        if (chance < 60) dano = 20;
        break;
      case 3:
        tipo = "forte";
        if (chance < 40) dano = 30;
        break;
      default:
        print("Ação inválida. Você perdeu o turno.");
        return;
    }

    if (dano > 0) {
      inimigo.levarDano(dano);
      print("Você acertou um ataque $tipo e causou $dano de dano!");
    } else {
      print("Seu ataque $tipo falhou!");
    }
  }
  void usarPocao() {
    if (pocoes > 0) {
      vida += 20;
      if (vida > 100) vida = 100; 
      pocoes--;
      print("Você usou uma poção e curou 20 de vida! Você tem ${pocoes} poções restantes.");
    } else {
      print("Você não tem poções restantes!");
    }
  }
}

class Inimigo extends Personagem {
  Inimigo(String nome, int vida) : super(nome, vida);

  void atacar(Jogador jogador) {
    int escolha = Random().nextInt(3) + 1;
    int chance = Random().nextInt(100);
    int dano = 0;
    String tipo = "";

    switch (escolha) {
      case 1:
        tipo = "leve";
        if (chance < 80) dano = 10;
        break;
      case 2:
        tipo = "médio";
        if (chance < 60) dano = 20;
        break;
      case 3:
        tipo = "forte";
        if (chance < 40) dano = 30;
        break;
    }

    if (dano > 0) {
      jogador.levarDano(dano);
      print("${nome} acertou um ataque $tipo e causou $dano de dano!");
    } else {
      print("${nome} errou o ataque.");
    }
  }
}
