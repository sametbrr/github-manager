# Repo Topics / Tags Standard

GitHub repo `topics` için kanonik setler. Çekirdek = **öneri tabanı** (dayatma değil);
audit sapmayı işaretler, kullanıcı onaylar.

## Aileler ve çekirdek setler

| Aile | Çekirdek topics (önerilen, zorunlu değil) | Ek |
|---|---|---|
| **Claude Code skill** | `agent-skills, ai, claude, claude-code, llm` | `python` (script bundle ederse) + 2–4 domain |
| **.NET package** | `csharp, dotnet, nuget` | 3–5 domain (ör. dependency-injection, configuration) |
| **MCP / npm** | `mcp, model-context-protocol, nodejs, javascript` | domain (ör. openapi, rest-api) |
| **CLI tool** | `cli` | domain (ör. encryption, git, dotenv) |

> Aile tespiti: `gh api repos/<r>` `language` + dosya sinyalleri (SKILL.md → skill, .csproj → .NET,
> package.json+mcp → MCP, kök binary/bin → CLI).

## Kurallar

1. **kebab-case**, küçük harf.
2. ≤ **20** topic (GitHub üst sınırı).
3. **Boş bırakma** — her public repo ≥3 topic.
4. Repo adını topic olarak tekrarlama.
5. Redundant düşür: `anthropic` varsa ve `claude` da varsa `anthropic` gereksiz (yumuşak öneri).
6. Domain etiketleri spesifik olsun (`prompt-engineering` > genel `tool`).

## Mevcut durum örnekleri

- İmza çekirdek (7/7 skill+hub'da var): `agent-skills, ai, claude, claude-code, llm` ✓
- `prompt-architect`: fazladan `anthropic` (claude ile redundant) → audit işaretler.
- `awesome-agent-skills`: **topics BOŞ** → audit işaretler (öncelikli).

## Checklist (tag-analyzer / gh-audit bunu kullanır)

- [ ] ≥3 topic (boş değil)
- [ ] kebab-case, küçük harf
- [ ] ≤20 adet
- [ ] Aile çekirdeği büyük ölçüde mevcut
- [ ] Repo-adı tekrarı yok
- [ ] Redundant tag yok (anthropic+claude gibi)
