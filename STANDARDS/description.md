# Repo Description Standard

Bir GitHub repo'sunun `description` alanı için kanonik kurallar.
Kaynak: sametbrr'ın mevcut repolarından çıkarılan örtük desen.

## Gramer

```
<Artifact-Type> that|for <core function> — <2–4 concrete specifics>.
```

- **Artifact-Type** (serbest, hedefe göre — tek forma ZORLANMAZ):
  `Claude Code skill` · `.NET library` · `ASP.NET Core package` · `MCP server` · `CLI tool`
  > Claude'a özel skill → "Claude Code skill…"; çok-AI/araç → tip adı (".NET library…", "MCP server…").
- **core function**: ne yaptığı, fiille; tek ana iş.
- **specifics**: em-dash `—` sonrası 2–4 somut özellik; mümkünse ≥1 sayı ("23 rules", "0–100", "8 modes").

## Kurallar

1. Tek cümle, **İngilizce**, nokta ile biter.
2. Detay ayırıcı **em-dash `—`** (mevcut "with …" formları da kabul ama tercih `—`).
3. **≤ 160 karakter** (GitHub description görünür sınırı).
4. ≥1 somut özellik/sayı içer.
5. Repo adını başta tekrar etme (gereksizse).
6. "Claude" markasını yalnız gerçekten Claude'a özelse kullan; çok-AI aracında kullanma.

## İyi örnekler (mevcut repolardan)

- `Claude Code skill that enforces a consistent README.md + README.tr.md structure — create, audit, fix, and keep the Turkish mirror in sync across 23 rules.`
- `.NET library that auto-registers services via marker interfaces and attributes — supports all lifetimes and open generics.`
- `MCP server that wraps any OpenAPI/Swagger REST API with CRUD, discovery, fuzzy search, and multi-scheme auth.`

## Bilinen sapmalar (audit işaretler, kullanıcı onaylar)

- Prefix tutarsızlığı **sapma değildir** — hedefe göre serbest (karar kilitli).
- `awesome-agent-skills`: description var ama em-dash/somut özellik zayıf → zenginleştir.
- Repo description ↔ profil README description farkı: **repo = kısa kanonik**, profil genişletebilir.

## Checklist (description-analyzer / gh-audit bunu kullanır)

- [ ] Boş değil
- [ ] Tek cümle, nokta ile biter
- [ ] İngilizce
- [ ] ≤160 char
- [ ] Em-dash `—` ile detay (veya kabul edilebilir "with")
- [ ] ≥1 somut özellik/sayı
- [ ] Artifact-type prefix bağlama uygun
