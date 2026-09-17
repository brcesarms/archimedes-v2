---
name: bancada-execucao
description: Execução padronizada do fluxo de bancada via orquestrador Python. Use quando o usuário pedir "bancada", "executar bancada", "inventário de máquina", "backup forense", "preparar formatação", "rodar orquestrador bancada", "manifesto de cliente" ou quando precisar coletar inventário Windows, fazer backup robocopy ou gerar manifesto pré-formatação via SSH.
compatibility: opencode
metadata:
  audience: ia-local
  workflow: automacao
---

# 🏗️ Execução do Projeto Bancada

> **Objetivo:** padronizar a execução do fluxo de bancada (inventário técnico + backup robocopy + manifesto + pós-instalação) via orquestrador Python em `~/projetos/archimedes-operator/`.
> **Testado em:** 2026-09-11 — estrutura implementada e testes internos (parse JSON + manifesto + menu interativo) ✅

## 🖥️ Tela Inicial Padrão (OBRIGATÓRIA)

Sempre que o usuário acionar o Projeto Bancada (dizendo "projeto bancada", "bancada", "abrir bancada", etc.), apresente **IMEDIATAMENTE** este painel antes de qualquer outra ação:

```text
==================================================================
🏛️ PROJETO BANCADA — PAINEL DE OPERAÇÕES
==================================================================

Etapas disponíveis:

  [1] 📊 Inventário Técnico
      └── Mapeia perfis em C:\Users, softwares instalados e extrai a chave OEM da BIOS.

  [2] 💾 Backup Forense (Robocopy)
      └── Copia Desktop, Documentos, Downloads e Fotos para o storage central (com suporte a OneDrive).

  [3] 📋 Manifesto Markdown
      └── Gera o checklist para o Obsidian com status de cópia e lista de apps a reinstalar.

  [4] 🪟 Pós-Instalação Completo
      └── Aplica ajustes de energia/privacidade e instala 10 apps essenciais + 19 runtimes via winget.

  [5] 🧹 Desbloat Windows 11 (Opcional pós-formatação)
      └── Remove bloatware, telemetria e widgets usando o Win11Debloat com ponto de restauração.

==================================================================
```

Após renderizar o painel, pergunte ao usuário quais etapas deseja executar e confirme os parâmetros necessários.

## 📍 Localização do Projeto

```text
/home/brn/projetos/archimedes-operator/
├── bin/operator                         <-- CLI Global / wrapper
├── scripts/python/
│   ├── orquestrador.py                  <-- Orquestrador principal
│   └── menu.py                          <-- Menu TUI interativo
├── scripts/powershell/
│   ├── inventario.ps1                   <-- Inventário JSON (Etapa 1)
│   ├── backup-robocopy.ps1              <-- Backup por usuário (Etapa 2)
│   ├── pos-instalacao.ps1               <-- Ajustes + apps + runtimes (Etapa 4)
│   ├── Win11Debloat.ps1                 <-- Desbloat pós-formatação (Etapa 5)
│   └── Win11Debloat.zip                 <-- Pacote debloat p/ envio remoto
├── scripts/bash/                        <-- Scripts Linux (rsync, setup-ssh)
├── templates/MANIFESTO_TEMPLATE.md      <-- Modelo do manifesto
└── manifests/                           <-- Manifestos gerados (gitignored 🛡️)
```

> 📖 Detalhes completos: `docs/instrucoes.md` dentro do projeto.

## 🚦 Pré-requisitos (verificar antes de começar)

1. **Pasta `~/projetos/archimedes-operator/` existe** — se não, clonar:
   ```bash
   git clone git@github.com:brcesarms/archimedes-operator.git ~/projetos/archimedes-operator
   ```
2. **Python + paramiko** instalados:
   ```bash
   python3 -c "import paramiko" || pip install paramiko
   ```
3. **Chave SSH** configurada na máquina alvo Windows (OpenSSH Server ativo).
4. **Máquina alvo documentada/confirmada** pelo usuário (nunca conectar host desconhecido).

## 🧾 Dados necessários do usuário

| Dado | Flag | Obrigatório |
| :--- | :--- | :--- |
| IP/hostname da máquina | `--host` | ✅ |
| Usuário Windows | `--usuario` | ✅ |
| Nome do cliente | `--cliente` | ✅ |
| Storage central (UNC) | `--destino` | ⚠️ se omitir, pula backup |
| Caminho da chave | `--chave` | opt (padrão `~/.ssh/id_ed25519`) |

> Se faltar algum dado obrigatório → **PEDIR ao usuário** antes de executar (não inventar host).

## 📋 Fluxo de Execução (passos mecânicos)

### Passo 1 — Confirmar ambiente local

```bash
ls ~/projetos/archimedes-operator/scripts/python/orquestrador.py
python3 -c "import paramiko" && echo OK
```

### Passo 2 — Rodar o orquestrador

```bash
python3 ~/projetos/archimedes-operator/scripts/python/orquestrador.py \
  --host <IP> \
  --usuario <USUARIO> \
  --cliente <CLIENTE> \
  --destino '\\storage-central\Bancada\<CLIENTE>' \
  --chave ~/.ssh/id_ed25519
```

> ⚠️ **Caminho UNC:** usar aspas simples ou escape duplo (`\\\\`) — o shell interpreta contrabarras.
> ⚠️ Executar a partir de `~/projetos/archimedes-operator/` (o script resolve caminhos relativos ao projeto).

### Passo 3 — Verificar saída (não confiar só no relatório!)

- ✅ Inventário: `✔ Inventário coletado: <HOSTNAME> ...`
- ✅ Backup: `✔ Backup concluído: X pastas ok, Y com falha`
- ✅ Manifesto: `✔ Manifesto gerado: .../manifests/MANIFESTO_<CLIENTE>_<DATA>.md`

**Verificação independente (obrigatória):**
```bash
ls -la ~/projetos/archimedes-operator/manifests/MANIFESTO_<CLIENTE>_*.md
wc -l ~/projetos/archimedes-operator/manifests/MANIFESTO_<CLIENTE>_*.md
```

### Passo 4 — Reportar ao usuário

Resumo em pt-BR com emojis: hostname, nº de usuários, nº de softwares, pastas copiadas, falhas (se houver), caminho do manifesto.

## ⚠️ Armadilhas conhecidas

| ⚠️ Armadilha | ❌ Errado | ✅ Certo |
|--------------|----------|----------|
| Host não confirmado | Conectar a IP adivinhado | Pedir IP/host ao usuário |
| Caminho UNC no bash | `--destino '\\nas\Bancada\X'` com aspas erradas | Aspas simples OU `\\\\` no Python |
| Inventário vazio | Assumir que parseou | Verificar saída; reportar `#falha` se JSON vazio |
| Exit code robocopy >= 8 | Reportar sucesso | Marcar falha de cópia no manifesto |
| Manifesto com dados reais | Commitar em repo público | `manifests/` é gitignored — manter lá |
| `--destino` ausente | Esperar backup | OK — orquestrador pula backup (comportamento documentado) |

## 📌 Regras

- 🔒 **Segurança:** nunca conectar host não documentado; nunca expor chave OEM/credenciais no chat
- 🛡️ **Manifestos reais:** ficam apenas em `manifests/` local (gitignored) — NUNCA commit/push
- ✅ **Verificação independente:** conferir manifesto com `ls`/`wc` — relatório de saída não é evidência
- 🏷️ **Falha:** inventário vazio, backup com exit >= 8 sem registro → tag `#falha` + parar
- 📄 **Logs:** podem conter hostnames — não commitar (`logs/` gitignored)

---

## 🔗 Fontes

- 📖 Projeto Bancada (fora do vault): `~/projetos/archimedes-operator/docs/instrucoes.md`
- [Convenção SSH](../../convencoes/convencoes-ssh.md)
- [Convenção de Projetos](../../convencoes/convencoes-projetos.md)