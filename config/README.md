# 🗂️ config/ — Configurações Centralizadas do Archimedes V2

> ⚠️ **Status:** Em planejamento — diretório de destino futuro para configurações
> centralizadas (MCP servers, hooks, linters) que hoje vivem na raiz ou nos
> dotfiles do cofre.

## 🎯 Objetivo

Centralizar configurações compartilhadas e substituíveis do ecossistema
Archimedes V2, seguindo o padrão de indústria *"config as code"*.

## 📦 Configurações atuais e seus donos

| Configuração | Local atual | Futuro |
|--------------|-------------|--------|
| OpenCode CLI | `opencode.json` (raiz) | `config/opencode/` |
| Link checker | `.lychee.toml` (raiz) | `config/lychee.toml` |
| Editor | `.editorconfig` (raiz) | `config/editor/.editorconfig` |
| Restic | `.resticignore` (raiz) | `config/restic/` |
| Docker | `docker/docker-compose.yml` | `config/docker/` |
| Dotfiles | `dotfiles/` | gerenciado via Chezmoi (não mover) |

## 🤝 Regras

1. **NUNCA** armazenar segredos aqui (tokens, chaves, senhas).
2. Alterações estruturais exigem plano antes (ver `AGENTS.md`).
3. Cada subdiretório deve ter seu próprio `README.md` explicando o propósito.