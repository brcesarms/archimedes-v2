---
name: revisar-scripts
description: Revisão de scripts bash do Archimedes para encontrar erros antes de entregar. Use ao revisar, auditar, refatorar ou procurar bugs em qualquer script .sh ou .ps1 — aplica varredura de sintaxe, shellcheck, distros, idempotência, healthcheck, referências e boas práticas. Dispara ao ouvir "revisar script", "procurar erros no script", "auditar script", "varredura de erros", "refatorar script".
compatibility: opencode
metadata:
  audience: ia-local
  workflow: scripts
---

# 🩺 Revisão de Scripts do Archimedes

Ao revisar ou refatorar qualquer script do cofre, siga esta varredura estruturada para **NÃO repetir os erros que já encontramos**.

## 🔍 Ordem de varredura (sempre nesta ordem)

### 1. 📝 Sintaxe básica e ShellCheck (Obrigatório)
```bash
bash -n script.sh && echo "✅ Sintaxe OK"
shellcheck -S warning script.sh
```

### 2. 🎨 Formatação automática com shfmt
```bash
# Verificar diferenças de formatação (dry-run):
shfmt -i 4 -d script.sh

# Aplicar formatação oficial:
shfmt -i 4 -w script.sh
```

### 3. 🛡️ Auditoria de Segredos com Gitleaks
```bash
# Garantir que nenhum token, senha ou chave foi exposta:
gitleaks detect --source . --verbose --no-banner
```

#### 📚 Como lidar com achados do ShellCheck (regra de ouro)

> **NUNCA ignore um aviso do shellcheck — ou corrija, ou documente com `# shellcheck disable=`**

| Código | Significado | Ação |
|--------|-------------|------|
| `SC2034` | Variável declarada mas nunca usada (código morto) | 🔧 **Corrigir**: remover a variável ou usá-la |
| `SC2016` | Expressão em aspas simples que parece não expandir | 🧾 **Suprimir** se intencional: `# shellcheck disable=SC2016 # comentário explicando por quê` |
| `SC1091` | `. arquivo-externo` não seguido pelo shellcheck | 🧾 **Suprimir** (é padrão válido): `# shellcheck disable=SC1091` |

**Exemplo real do cofre** (aspas simples deliberadas — queremos `$HOME` literal no `.bashrc`):
```bash
# shellcheck disable=SC2016 # intencional: $HOME expande quando .bashrc rodar
echo 'export PATH="$HOME/.opencode/bin:$PATH"' >> "$HOME/.bashrc"
```

**Por que suprimir com comentário (e não deletar)?**
- ✅ Documenta a intenção para futuros editores
- ✅ Mantém o objetivo de "0 avisos" do shellcheck
- ❌ Deletar o aviso do arquivo não existe — o certo é sempre deixar rastro

### 3. 🏷️ Case de distros — ERRO Nº 1 (já quebrou 2x)
- ⚠️ **NUNCA agrupar `omarchy` com Ubuntu/apt** — Omarchy é **Arch-based** (`ID_LIKE=arch`)
- ✅ Verificar sempre com `/etc/os-release` → `ID_LIKE` antes de assumir o gerenciador de pacotes
- ✅ Grupo correto: `arch|manjaro|omarchy` → `pacman`
- ✅ Grupo Ubuntu: `ubuntu|linuxmint|pop` → `apt`
- ✅ Grupo Fedora: `fedora|rhel|centos` → `dnf`

### 4. 📝 Strings e aspas
- ⚠️ **NUNCA aninhar aspas duplas** dentro de aspas duplas: `echo "texto "inner" texto"`
- ✅ Escapar: `echo "texto \"inner\" texto"` ou usar aspas simples quando não houver variáveis

### 5. 🚦 Validação de entrada/argumentos
- ⚠️ **NUNCA aceitar argumento inválido sem erro** — scripts devem falhar com exit ≠ 0
- ✅ Validar com `case` e mostrar `--help` no modo inválido

### 6. 🔁 Idempotência (rodar 2x = mesmo resultado)
- ⚠️ **NUNCA escrever em arquivos (.bashrc, configs) sem verificar se já existe**
- ✅ Usar `grep -qF "padrão" arquivo` antes de `>>`
- ✅ Backups com timestamp completo: `.backup.$(date +%Y%m%d%H%M%S)`

### 7. 🎯 Match exato vs parcial
- ⚠️ **NUNCA** `grep -q "$item"` para verificar existência — pode casar prefixo/sufixo (`qwen3:8b` colide com `qwen3:8b-xxx`)
- ✅ Usar exato: `ollama list | awk '{print $1}' | grep -qxF "$item"`

### 8. ⏳ Espera cega vs healthcheck
- ⚠️ **NUNCA** `sleep 2` fixo para esperar serviço subir
- ✅ Loop com healthcheck real (ex: `curl http://127.0.0.1:11434/api/tags`) com timeout

### 9. 🧾 Referências cruzadas com arquivos reais
- ⚠️ **NUNCA** citar nomes de arquivos/comandos que não existem (mensagens finais, help)
- ✅ Conferir com `ls`/`glob` que os arquivos citados existem (ex: `usar-coder-v1.1.sh`, não `usar-coder`)

### 10. 📦 Versões de ferramentas
- ⚠️ Verificar se a versão instalada corresponde ao uso: docker-compose **v1 (standalone)** vs **v2 (plugin)**
- ✅ `docker-compose.yml` que usa `docker compose` precisa do plugin v2 (`docker-compose-v2` no apt)

### 11. 💾 Caminhos configuráveis
- ⚠️ **NUNCA** hardcodar `$HOME/archimedes` quando o script tem variável configurável (ex: `COFRE_DIR`)
- ✅ Usar a variável real no heredoc/conteúdo gerado

### 12. ⚡ Verificação automática em massa
> **Ao terminar a varredura manual, rode o verificador do cofre para garantir que nada quebrou.**

```bash
./scripts/linux/verificar-scripts.sh
```

- ✅ Roda `bash -n` + `shellcheck` em **todos** os `.sh` do cofre de uma vez
- ✅ Detecta o shellcheck até em `~/.local/bin` (fallback sem sudo)
- ✅ Exit code 0 = tudo limpo | 1 = há falhas para corrigir
- ⚠️ Se o script de verificação **não existir**, crie-o seguindo [`script-linux`](../script-linux/SKILL.md) e a skill [`backup-cofre`](../backup-cofre/SKILL.md)

## 📋 Checklist rápido pós-revisão

1. [ ] `bash -n` passou
2. [ ] shellcheck **100% limpo** — erros reais corrigidos, falsos positivos suprimidos com comentário (ou avisado que falta instalar)
3. [ ] Distros agrupadas por `ID_LIKE` (omarchy = Arch!)
4. [ ] Aspas corretas (sem aninhamento)
5. [ ] Argumentos validados (modo inválido → erro + help)
6. [ ] Idempotente (nada de duplicação em .bashrc/configs)
7. [ ] Matches exatos (sem colisão de prefixo)
8. [ ] Healthcheck em vez de sleep cego
9. [ ] Referências existem de verdade (nomes de arquivos reais)
10. [ ] Versão da ferramenta casa com o uso declarado
11. [ ] Caminhos usam variável configurável, não hardcode
12. [ ] `chmod +x` aplicado
13. [ ] `./scripts/linux/verificar-scripts.sh` rodou com exit 0

---

## 🔗 Fontes

- 🐚 Verificador automático: [`scripts/linux/verificar-scripts.sh`](../../../scripts/linux/verificar-scripts.sh)
- 📄 Convenções de scripts: [`script-linux`](../script-linux/SKILL.md)
- 📄 Convenções definidas em: [`AGENTS.md`](../../../AGENTS.md)
- 🐚 Documentação oficial: [ShellCheck](https://www.shellcheck.net/)