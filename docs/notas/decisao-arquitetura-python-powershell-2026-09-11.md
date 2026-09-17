# ⚖️ Decisão de Arquitetura — Python no Orquestrador, PowerShell no Cliente

> **Data:** 2026-09-11 · **Status:** Decidido ✅ · **Tipo:** Decisão de arquitetura (ADR)

## 🎯 Resumo

**Decisão:** NÃO instalar Python nas máquinas dos clientes. Manter o split **orquestrador em Python (lado do Archimedes)** + **agentes em PowerShell (lado do cliente)**.

Essa é a arquitetura padrão de mercado (padrão "controller + agent" — igual Ansible: Python no controller, comandos nativos no alvo).

---

## ❓ Contexto e Pergunta

O Bruno perguntou: *"as máquinas dos clientes deveriam ter Python? Os scripts ficariam mais robustos em Python?"*

Análise concluída junto com o Archimedes (Validador de Boas Práticas).

---

## ⚖️ Por que Python no cliente é ANTI-PADRÃO

| Motivo | Detalhe |
| :--- | :--- |
| 🐘 **Dependência nova** | Python NÃO vem no Windows. Cada máquina precisaria de instalação (+50-100MB), PATH, versão, pip... vira software a manter na vida útil da máquina |
| 🎯 **PowerShell é nativo** | Todo Windows (7/8/10/11) tem PowerShell 5.1 embutido, atualizado via Windows Update. **Zero instalação, zero dependência** |
| 🔒 **Superfície de ataque** | Interpretador Python de terceiros numa máquina de cliente = vetor a mais. PowerShell tem `ExecutionPolicy`, assinatura e políticas controláveis |
| 🧼 **Política de execução** | Já é chato liberar `.ps1`; com Python seria liberar outro interpretador + dependências |
| 🔄 **Manutenção** | Quem atualiza o Python do cliente depois da entrega? PowerShell recebe update sozinho |

---

## ✅ O padrão correto (arquitetura atual do projeto)

```text
🧠 Archimedes (Python/paramiko)  →  🖥️ Máquina do cliente (PowerShell)
    Lógica pesada, orquestração        Scripts simples, descartáveis, nativos
    roda onde VOCÊ controla            rodam uma vez e somem
```

| Camada | Linguagem | Onde roda | Função |
| :--- | :--- | :--- | :--- |
| **Orquestrador** | 🐍 Python + paramiko | Máquina do Archimedes (GEEKOM/VM) | Conecta SSH/SFTP, envia scripts, parseia JSON, gera manifesto |
| **Agente** | 🪟 PowerShell 5.1 | Máquina do cliente | Inventário, backup robocopy, setup SSH, ajustes — roda on-demand e some |

---

## 🧠 Quando valeria repensar (e o que fazer em vez disso)

| Cenário | Decisão |
| :--- | :--- |
| Scripts PS virando **monstros complexos** (>300 linhas) | Quebrar em módulos PS ou **subir a complexidade para o orquestrador Python** — não trocar a linguagem |
| Precisar de **lógica de negócio pesada** no cliente (APIs, processamento) | Raro na bancada; script PS bem feito resolve. Avaliar caso a caso |
| Cliente **JÁ tem Python** (dev/analista) | Aproveitar — sem instalar nada novo |

---

## 🎯 Como aumentar a robustez (sem trocar linguagem)

1. 🩺 **Validação de saída rígida** nos `.ps1` — JSON + exit codes (já implementado)
2. 📦 **Versionamento e testes** dos scripts (skill `revisar-scripts` cobre)
3. 🔒 **Python restrito ao orquestrador** — como está hoje

---

## 🔗 Fontes

- [Projeto bancada no GitHub](https://github.com/brcesarms/archimedes-operator)
- [Nota: Proxmox GEEKOM — Setup e Acesso SSH à VM Windows](./proxmox-geekom-vm-windows.md)