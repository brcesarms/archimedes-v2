#!/usr/bin/env python3
"""Validador de links Markdown do Archimedes Vault.

Uso:
    python3 validar_links.py <arquivo_ou_pasta> [--raiz DIR_BASE]

Verifica se os destinos dos links relativos existem e reporta quebrados.
- Links externos (http/https/ftp/mailto/www) são ignorados.
- Âncoras (#...) e definicoes de link ([label]: url) são ignoradas.
- Blocos de codigo (fenced) e codigo inline sao ignorados.

Exit code: 0 = tudo ok (ou apenas ignorados), 1 = ha links quebrados.
"""
import argparse
import os
import posixpath
import re
import sys
import urllib.parse

EXTERNOS_RE = re.compile(
    r"^(https?://|ftp://|mailto:|tel:|www\.|file://|data:)", re.IGNORECASE
)
LINK_RE = re.compile(r"!?\[([^\]]*)\]\(([^)\s]+(?:\s+[^)]*)?)\)")
FENCED_BLOCK_RE = re.compile(
    r"```.*?```|~~~.*?~~~", re.DOTALL
)
INLINE_CODE_RE = re.compile(r"`[^`]+`")
DEFINICAO_LINK_RE = re.compile(r"^\s*\[[^\]]+\]:\s*\S+")

# Diretórios que nunca devem ser varridos (dependências, caches, git)
EXCLUIR_DIRS = {
    "node_modules",
    ".git",
    ".venv",
    "__pycache__",
    ".pytest_cache",
    "dist",
    "build",
    ".next",
    ".cache",
}


def remover_blocos_codigo(conteudo: str) -> str:
    """Remove blocos de codigo fenced para nao validar links dentro deles."""
    return FENCED_BLOCK_RE.sub("", conteudo)


def remover_code_inline(conteudo: str) -> str:
    """Remove trechos de codigo inline (entre crases)."""
    return INLINE_CODE_RE.sub("", conteudo)


def eh_externo(destino: str) -> bool:
    """True para URLs externas que nao devem ser validadas localmente."""
    return bool(EXTERNOS_RE.match(destino.strip()))


def extrair_links_markdown(conteudo: str):
    """Extrai links [texto](destino) e imagens ![alt](destino).

    Ignora definicoes de link ([label]: url) que aparecem na linha.
    Retorna lista de dicts: {texto, destino, linha}.
    """
    conteudo_limpo = remover_code_inline(remover_blocos_codigo(conteudo))
    links = []
    for m in LINK_RE.finditer(conteudo_limpo):
        inicio_linha = conteudo_limpo.rfind("\n", 0, m.start()) + 1
        linha = conteudo_limpo.count("\n", 0, m.start()) + 1
        if DEFINICAO_LINK_RE.match(conteudo_limpo[inicio_linha:inicio_linha + 100]):
            continue  # linha de definicao de link, não uso do link
        links.append(
            {"texto": m.group(1), "destino": m.group(2).strip(), "linha": linha}
        )
    return links


def resolver_destino(destino: str, arquivo_atual: str, raiz: str):
    """Resolve o destino de um link para caminho absoluto (ou None se ignorado).

    - Externo -> None (ignorado)
    - Ancora pura (#...) -> None (ignorado)
    - Absoluto do repo (/...) -> base na raiz
    - Relativo -> base no diretorio do arquivo atual
    """
    destino_limpo = destino.split("#", 1)[0].strip()
    if not destino_limpo or eh_externo(destino_limpo):
        return None
    if "*" in destino_limpo or "?" in destino_limpo:
        return None  # curinga/placeholder — não é link navegável
    if destino_limpo.startswith("/"):
        # Absoluto do repo: resolve contra a raiz (lstrip evita que
        # os.path.join descarte a base em POSIX)
        base = raiz
        caminho = destino_limpo.lstrip("/")
    else:
        base = os.path.dirname(os.path.abspath(arquivo_atual))
        caminho = destino_limpo
    caminho = urllib.parse.unquote(caminho)
    return os.path.normpath(os.path.join(base, caminho))


def validar_arquivo(caminho: str, raiz: str):
    """Valida links de um arquivo markdown. Retorna (validos, quebrados)."""
    validos, quebrados = [], []
    with open(caminho, encoding="utf-8", errors="replace") as fh:
        conteudo = fh.read()
    for link in extrair_links_markdown(conteudo):
        alvo = resolver_destino(link["destino"], caminho, raiz)
        if alvo is None:
            continue  # ignorado (externo, ancora, etc.)
        if os.path.exists(alvo):
            validos.append((link, alvo))
        else:
            quebrados.append((link, alvo))
    return validos, quebrados


def carregar_markdowns(caminho: str):
    """Retorna lista de arquivos .md/.mdx de um arquivo ou pasta (recursivo)."""
    if os.path.isfile(caminho):
        return [caminho]
    arquivos = []
    for raiz_atual, dirs, arquivos_local in os.walk(caminho):
        dirs[:] = [d for d in dirs if d not in EXCLUIR_DIRS]
        for nome in arquivos_local:
            if nome.endswith((".md", ".mdx")):
                arquivos.append(os.path.join(raiz_atual, nome))
    return sorted(arquivos)


def main():
    parser = argparse.ArgumentParser(description="Validador de links Markdown do vault")
    parser.add_argument("caminho", help="Arquivo .md ou pasta a varrer")
    parser.add_argument(
        "--raiz",
        default=os.getcwd(),
        help="Diretorio raiz p/ links absolutos do repo (default: cwd)",
    )
    args = parser.parse_args()

    if not os.path.exists(args.caminho):
        print(f"✖ Caminho nao encontrado: {args.caminho}")
        sys.exit(2)

    total_links = 0
    total_quebrados = 0

    for md in carregar_markdowns(args.caminho):
        validos, quebrados = validar_arquivo(md, args.raiz)
        rel = os.path.relpath(md, args.raiz)
        total_links += len(validos) + len(quebrados)
        if quebrados:
            print(f"\n📄 {rel}")
            for link, alvo in quebrados:
                print(f"   ❌ linha {link['linha']:<4} [{link['texto']}] → {alvo}")
                total_quebrados += 1
        elif validos:
            print(f"✅ {rel} — {len(validos)} links ok")

    print("\n────────────── RESUMO ──────────────")
    print(f"✅ Links validos:  {total_links - total_quebrados}")
    print(f"❌ Links quebrados: {total_quebrados}")

    if total_quebrados:
        print("✖ Ação necessária: corrija os links quebrados acima.")
        sys.exit(1)
    print("✔ Nenhum link quebrado encontrado.")
    sys.exit(0)


if __name__ == "__main__":
    main()