# 🔌 Dotfiles — Archimedes V2 (Gerenciado via Chezmoi)

Os dotfiles do Archimedes V2 são gerenciados pelo [**`chezmoi`**](https://github.com/twpayne/chezmoi) (+16.000 ⭐), o padrão da indústria para gerenciamento seguro e versionado de configurações de usuário.

> Configurações de shell e ambiente versionadas para **sobreviver a formatação**. Copiadas para `~` pelo `bootstrap.sh` ou pelo `chezmoi apply`.

---

## 📄 O que mora aqui

| Arquivo | Destino | Para que serve | Contém segredo? |
| :--- | :--- | :--- | :---: |
| `dot_bashrc` | `~/.bashrc` | Shell principal: PATH, histórico, funções `cofre`/`cofre-status` | ❌ Não |
| `dot_aliases` | `~/.bash_aliases` | Aliases do Archimedes V2 (v2, docker, ollama, lychee…) | ❌ Não |
| `dot_prompt` | *(source)* | Prompt Jarvis customizado (PS1) | ❌ Não |
| `dot_ssh/config` | `~/.ssh/config` | Template de aliases de hosts SSH | ❌ Não |
| `README.md` | *(este arquivo)* | Documentação da pasta | ❌ Não |

> ⚠️ **Nunca** coloque chaves privadas, tokens ou senhas nesta pasta — vão para o repositório!
> Restaure segredos pelo Bitwarden ou gere novos na máquina.

---

## 🚀 Como Aplicar em Nova Máquina

1. **Garantir chezmoi instalado:**
   ```bash
   brew install chezmoi
   ```

2. **Aplicar os dotfiles do repositório:**
   ```bash
   chezmoi apply --source "$HOME/archimedes-v2/dotfiles"
   ```

3. **Verificar diferenças antes de aplicar (dry-run):**
   ```bash
   chezmoi diff --source "$HOME/archimedes-v2/dotfiles"
   ```

### Alternativa rápida (sem chezmoi)

```bash
cd ~/archimedes-v2 && ./scripts/bootstrap.sh

# Manual — copiar o SSH config
cp dotfiles/dot_ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config
```

---

## 🔒 Atualizar um host (ex: IP mudou)

1. Edite `dot_ssh/config`
2. Commit + push (segue convenções git)
3. Rode `chezmoi apply` ou `./scripts/bootstrap.sh` na(s) máquina(s) afetada(s)

---

## 🔗 Fontes

- 🔌 Convenção SSH: [`convencoes-ssh.md`](../docs/convencoes/convencoes-ssh.md)
- 🏛️ Bootstrap: [`bootstrap.sh`](../scripts/bootstrap.sh)
