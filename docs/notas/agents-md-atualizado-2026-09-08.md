# 🦾 AGENTS.md — Atualização do Sistema Cérebro & Executor

> **Data da atualização:** 08 de setembro de 2026  
> **Status:** ✅ Concluído

## 📝 Resumo

O arquivo `AGENTS.md` foi atualizado para integrar todas as instruções do sistema **Cérebro & Executor**, anteriormente分散 em `00-sistema-cerebro.md`. O arquivo `00-sistema-cerebro.md` foi removido, simplificando a estrutura do cofre.

## ✅ Mudanças Implementadas

- **Arquivo removido:** `00-sistema-cerebro.md` — conteúdo integrado ao `AGENTS.md`
- **AGENTS.md agora tem:** 259 linhas com todas as instruções do sistema
- **Sistema Cérebro & Executor:** Documentado diretamente no arquivo principal
- **Divisão clara mantida:** 🧠 Cérebro (projeta) vs ⚡ Executor (executa)

## 📂 Estrutura Simplificada

A estrutura do cofre foi simplificada com a fusão:

```
archimedes-vault/
├── AGENTS.md               # ← Agora contém TODAS as instruções do sistema
├── opencode.json           # Config do OpenCode
└── ...
```

**Antes:**
- `AGENTS.md` + `00-sistema-cerebro.md` (arquivos separados)

**Depois:**
- `AGENTS.md` único com todo o sistema consolidado

## 🎯 Benefícios

- ✅ **Simplicidade:** Um único arquivo para todo o sistema
- ✅ **Manutenção facilitada:** Alterações em um lugar
- ✅ **Menos confusão:** Não há mais arquivos分散
- ✅ **Consistência:** Toda a lógica do sistema em um local

## 🔗 Fontes
- [AGENTS.md](../../AGENTS.md)
