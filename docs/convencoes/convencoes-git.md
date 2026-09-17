# 🌿 Convenções Git + GitHub

> Carregue este arquivo quando for usar git: commits, branches, push, pull, merge, submódulos, API GitHub.

## 📝 Mensagens de commit

Formato **convencional** em português:

```
feat: adiciona script de backup automático
fix: corrige link quebrado no README
docs: atualiza documentação do setup
refactor: reorganiza estrutura de pastas
chore: atualiza dependências
test: adiciona nota de validação
```

## 🏗️ Estrutura modular (IMPORTANTE!)

O projeto é **modular** — 3 repos separados:

| Caminho | Repo | Acesso |
|---------|------|--------|
| `~/archimedes-v2` (raiz) | `brcesarms/archimedes-v2` | 🌐 público |
| `~/wikisidian/t.i` (estudos pessoais) | `brcesarms/t.i` | 🌐 público |
| `~/wikisidian/concurseiro` (estudos pessoais) | `brcesarms/concurseiro` | 🔒 privado |

**Regra de ouro:** conteúdo de estudo commita **DENTRO de `~/wikisidian/`**; sistema (scripts/notas/utils de manutenção) commita **na raiz do cofre**. Estudos pessoais ficam **fora do repositório público**.

## 🔀 Estudos Pessoais (`~/wikisidian/`)

### Clonar estudos pessoais (pós-formatação / máquina nova)
```bash
mkdir -p ~/wikisidian
git clone https://github.com/brcesarms/t.i.git ~/wikisidian/t.i
git clone https://github.com/brcesarms/concurseiro.git ~/wikisidian/concurseiro
```

### Atualizar estudos pessoais para o último commit remoto
```bash
git -C ~/wikisidian/t.i pull
git -C ~/wikisidian/concurseiro pull
```

### Commitar mudanças DENTRO de um estudo pessoal (ex: t.i)
```bash
cd ~/wikisidian/t.i
git add .
git commit -m "feat: nova nota de linux"
git push
```

> ⚠️ Os estudos pessoais são **repos independentes** de `~/archimedes-v2` — não existe mais ponteiro de submódulo para atualizar na raiz.

## 🐙 API GitHub (via curl)

Sempre usar **token de variável de ambiente** — NUNCA hardcodar:

```bash
export GITHUB_TOKEN="seu_token_aqui"   # ou já configurado no shell
```

### Criar repo
```bash
curl -L -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/repos \
  -d '{"name":"nome-repo","private":true}'
```

### Verificar autenticação
```bash
curl -s -u "brcesarms:${GITHUB_TOKEN}" https://api.github.com/user
```

## 🔄 Fluxo diário (máquinas)

| Fluxo | Comando |
|-------|---------|
| **ACER → GitHub** | `git add -A && git commit -m "..." && git push` |
| **GEEKOM → GitHub** | `git add -A && git commit -m "..." && git push` |
| **Baixar atualizações** | `git pull origin main` |
| **Clonar tudo novo** | `git clone --recurse-submodules ...` |

> O GEEKOM é o cofre principal; a ACER é backup/manutenção (não roda IA local).

## 🛡️ Segurança

- **NUNCA** expor token, senha ou chave em commits, logs ou chat
- **NUNCA** rodar `echo $GH_TOKEN`, `env`, `cat ~/.git-credentials` ou qualquer comando que imprima o valor do token
- **NUNCA** usar o token no texto do comando git: `git clone https://user:TOKEN@github.com/...` **é proibido** — isso loga o token
- **SEMPRE** usar credencial já configurada no sistema (`git clone https://github.com/...` sem token na URL) ou `$GITHUB_TOKEN` apenas para chamadas curl à API
- **NUNCA** commitar `.env`, `*.key`, `*.pem`, `id_rsa`
- **SEMPRE** usar `$GITHUB_TOKEN` (variável de ambiente) em scripts e comandos
- Se um token foi exposto em chat/log → **avisar imediatamente** e recomendar revogação
- Antes de commitar, verificar: `git status` + conferir que não há credenciais
- ⚠️ **Lição 2026-09-07:** o modelo local imprimiu o token com `echo $GITHUB_TOKEN_FOR_TEST` e usou `https://user:TOKEN@github.com` no clone. **NUNCA fazer isso** — o Git já tem credenciais configuradas no GEEKOM/ACER.

## ✅ Checklist antes de commitar

1. [ ] `git status` — vejo o que vai entrar
2. [ ] Nenhum arquivo sensível (`.env`, `*.key`, token)
3. [ ] Mensagem convencional em pt-BR
4. [ ] Se mudou conteúdo de t.i/concurseiro → commit em `~/wikisidian/` (repo próprio, fora do vault)
5. [ ] `git push` no repo certo (raiz vs estudos pessoais)

---

## 🔗 Fontes
- [Conventional Commits](https://www.conventionalcommits.org/pt-br/)
- [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub REST API](https://docs.github.com/en/rest)