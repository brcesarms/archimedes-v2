# 🔌 Dotfiles — Archimedes V2 (Gerenciado via Chezmoi)

Os dotfiles do Archimedes V2 são gerenciados pelo [**`chezmoi`**](https://github.com/twpayne/chezmoi) (+16.000 ⭐), o padrão da indústria para gerenciamento seguro e versionado de configurações de usuário.

---

## 🚀 Como Aplicar em Nova Máquina

1. **Garantir chezmoi instalado:**
   ```bash
   brew install chezmoi
   ```

2. **Aplicar os dotfiles do repositório:**
   ```bash
   chezmoi apply --source /home/brn/archimedes-v2/dotfiles
   ```

3. **Verificar diferenças antes de aplicar (dry-run):**
   ```bash
   chezmoi diff --source /home/brn/archimedes-v2/dotfiles
   ```
