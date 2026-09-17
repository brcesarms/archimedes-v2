"""Testes do validador de links Markdown (scripts/python).

Rodar com:  python3 -m pytest tests/ -v
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import validar_links


def test_extrai_links_markdown():
    conteudo = "[link](nota-a.md) e ![imagem](fig.png)"
    links = validar_links.extrair_links_markdown(conteudo)
    assert len(links) == 2
    assert links[0]["texto"] == "link"
    assert links[0]["destino"] == "nota-a.md"
    assert links[1]["texto"] == "imagem"


def test_ignora_definicao_de_link():
    conteudo = "[1]: https://exemplo.com\nVeja [nota](nota-a.md)"
    links = validar_links.extrair_links_markdown(conteudo)
    assert len(links) == 1
    assert links[0]["destino"] == "nota-a.md"


def test_externo_ignorado():
    assert validar_links.resolver_destino("https://exemplo.com", "/tmp/a.md", "/tmp") is None
    assert validar_links.resolver_destino("www.google.com", "/tmp/a.md", "/tmp") is None
    assert validar_links.resolver_destino("mailto:x@y.com", "/tmp/a.md", "/tmp") is None


def test_ancora_ignorada():
    assert validar_links.resolver_destino("#secao", "/tmp/a.md", "/tmp") is None


def test_link_valido_existe(tmp_path):
    (tmp_path / "alvo.md").write_text("ok", encoding="utf-8")
    origem = tmp_path / "origem.md"
    origem.write_text("[alvo](alvo.md)", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 1
    assert len(quebrados) == 0


def test_link_quebrado_detectado(tmp_path):
    origem = tmp_path / "origem.md"
    origem.write_text("[sumido](nao-existe.md)", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 0
    assert len(quebrados) == 1
    assert quebrados[0][0]["destino"] == "nao-existe.md"


def test_link_com_fragmento(tmp_path):
    (tmp_path / "alvo.md").write_text("# Titulo", encoding="utf-8")
    origem = tmp_path / "origem.md"
    origem.write_text("[secao](alvo.md#titulo)", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 1
    assert len(quebrados) == 0


def test_ignora_link_dentro_de_code_block(tmp_path):
    origem = tmp_path / "origem.md"
    origem.write_text(
        "```bash\n[link](falso.md)\n```\n\n[real](alvo.md)",
        encoding="utf-8",
    )
    (tmp_path / "alvo.md").write_text("ok", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 1
    assert len(quebrados) == 0


def test_ignora_link_dentro_de_code_inline(tmp_path):
    origem = tmp_path / "origem.md"
    origem.write_text("`[falso](nao-existe.md)` e [real](alvo.md)", encoding="utf-8")
    (tmp_path / "alvo.md").write_text("ok", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 1
    assert len(quebrados) == 0


def test_link_para_diretorio_valido(tmp_path):
    (tmp_path / "docs").mkdir()
    origem = tmp_path / "origem.md"
    origem.write_text("[docs](docs)", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 1
    assert len(quebrados) == 0


def test_links_absolutos_usam_raiz(tmp_path):
    (tmp_path / "alvo.md").write_text("ok", encoding="utf-8")
    origem = tmp_path / "origem.md"
    origem.write_text("[abs](/alvo.md)", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 1
    assert len(quebrados) == 0


def test_caminho_com_espaco(tmp_path):
    (tmp_path / "minha nota.md").write_text("ok", encoding="utf-8")
    origem = tmp_path / "origem.md"
    origem.write_text("[nota](minha%20nota.md)", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 1
    assert len(quebrados) == 0


def test_ignora_node_modules(tmp_path):
    (tmp_path / "node_modules" / "lib").mkdir(parents=True)
    (tmp_path / "node_modules" / "lib" / "README.md").write_text("x", encoding="utf-8")
    (tmp_path / "nota.md").write_text("ok", encoding="utf-8")
    arquivos = validar_links.carregar_markdowns(str(tmp_path))
    relativos = [os.path.relpath(a, str(tmp_path)) for a in arquivos]
    assert not any(r.startswith("node_modules") for r in relativos)
    assert "nota.md" in relativos


def test_ignora_link_com_curinga(tmp_path):
    origem = tmp_path / "origem.md"
    origem.write_text("[exemplo](./.*\\.md) e [outro](../?/x.md)", encoding="utf-8")
    validos, quebrados = validar_links.validar_arquivo(str(origem), str(tmp_path))
    assert len(validos) == 0
    assert len(quebrados) == 0


def test_ignora_link_com_curinga_no_resolver(tmp_path):
    assert validar_links.resolver_destino("./.*\\.md", str(tmp_path), str(tmp_path)) is None
    assert validar_links.resolver_destino("../?/x.md", str(tmp_path), str(tmp_path)) is None