---
id: verificar-circuito-ssh-antes-de-sincronizar
titulo: "Verificar circuito SSH antes de sincronizar remoto a partir de uma máquina nova"
trigger: "quando tentar sincronizar o cofre via ssh/scp a partir de uma máquina não configurada"
action: "conferir antes: ~/.ssh/config existe? chave id_ed25519 autorizada no destino? known_hosts com o host? Caso contrário, usar git push/pull (offline é mais confiável) ou autorizar a chave antes"
domain: "ssh"
confidence: 0.5
scope: "vault"
evidencia:
  - "2026-09-13: tentativa de sync no Alienware falhou — ACER sem ~/.ssh/config, chave não autorizada no destino, host ausente do known_hosts"
  - "2026-09-13: mesmo circuito bloqueado para GEEKOM (sem authorized_keys na ACER)"
status: "novo"
criado_em: "2026-09-13"
atualizado_em: "2026-09-13"
skill_criada: ""
---