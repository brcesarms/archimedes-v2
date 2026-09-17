# 🐧🪟 Convenções de Scripts

> Carregue este arquivo quando for criar ou editar scripts (bash ou PowerShell).

## 🐧 Scripts Linux

- Usar `#!/bin/bash` ou `#!/usr/bin/env bash` como shebang
- Incluir set flags: `set -euo pipefail`
- Incluir comentários descritivos no início
- Usar `chmod +x` para tornar executável após criação
- Verificar exit code após execução

```bash
#!/bin/bash
set -euo pipefail
# Descrição do script

if [ $? -ne 0 ]; then
    echo "✖ Operação falhou. Erro: $?"
fi
```

## 🪟 Scripts Windows (PowerShell)

- Usar `#Requires -Version 5.1` quando aplicável
- Incluir comentários de help base
- Usar verbos cmdlet aprovados (Get, Set, New, Remove, etc.)

## 🔄 Scripts Multiplataforma

- **Windows**: PowerShell (`.ps1`) e Batch (`.bat`)
- **Linux**: Bash (`.sh`), Shell Script e Python (`.py`)
- Scripts limpos, comentados e otimizados
- Usar emojis nos logs (✅ sucesso, ⚠️ aviso, ❌ falha)

---

## 🔗 Fontes
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
