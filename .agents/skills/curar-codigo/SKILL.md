---
name: curar-codigo
description: Geração autônoma de testes unitários pytest e loop de auto-cura (self-healing) via archimedes-doctor. Use quando o usuário pedir "testar código", "gerar testes", "curar código", "consertar testes", "rodar doctor", "self-healing" ou após modificar arquivos Python.
---

# 🩺 Skill: curar-codigo

## Hospital de Código Autônomo com Loop de Auto-Cura (Self-Healing)

O Archimedes utiliza o motor [`archimedes-doctor`](https://github.com/brcesarms/archimedes-doctor) para analisar arquivos modificados, identificar funções sem cobertura de testes, gerar suítes `pytest` isoladas e auto-corrigir falhas até ficarem 100% verdes.

## 📂 Localização do Motor

| Item | Caminho |
| :--- | :--- |
| CLI Global | `~/.local/bin/doctor` ou `~/.local/bin/archimedes-doctor` |
| Repositório | `~/projetos/archimedes-doctor` |
| Venv | `~/projetos/archimedes-doctor/.venv` |

## 📋 Como usar

1. **Diagnóstico e Cura Geral (Arquivos modificados no Git):**
   ```bash
   doctor run
   ```

2. **Diagnóstico e Cura em Arquivo Específico:**
   ```bash
   doctor run src/meu_modulo.py
   ```

3. **Apenas Escanear Cobertura (Sem gerar código):**
   ```bash
   doctor scan
   ```

4. **Verificar Ambiente e Ferramentas:**
   ```bash
   doctor info
   ```

## 🛡️ Diretrizes de Funcionamento
- 🔒 **Isolamento:** Os testes são executados em Sandbox local com `PYTHONDONTWRITEBYTECODE=1` e timeout rígido de segurança.
- 🩺 **Extração Cirúrgica:** Apenas o traceback real do erro é enviado para o modelo no ciclo de cura, economizando mais de 90% de tokens.
- 🔁 **Limite de Iterações:** Por padrão realiza até 3 tentativas de auto-cura por arquivo antes de pausar e alertar o usuário.

---

## 🔗 Fontes

- [Repositório archimedes-doctor](https://github.com/brcesarms/archimedes-doctor)
- [Convenções de Projetos](../../convencoes/convencoes-projetos.md)
- [AGENTS.md](../../../AGENTS.md)
