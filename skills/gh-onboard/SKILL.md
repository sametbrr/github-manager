---
name: gh-onboard
description: Claude Code skill that sets up or cleans a GitHub account end-to-end — interactively audits and fixes profile fields, profile README, repo descriptions, topics and project READMEs.
disable-model-invocation: true
---

# gh-onboard

Boş/dağınık bir GitHub hesabını uçtan uca kuran interaktif orkestratör.
Diğer skill/agent'ları sırayla çağırır; her yazma adımı onaylıdır.

## 0. Auth bootstrap (tam scope, tek sefer)
```bash
command -v gh >/dev/null || { echo "→ brew install gh"; exit 1; }
gh auth status >/dev/null 2>&1 || echo "→ ! gh auth login --web -s repo,read:org,user"
```

## 1. Kapsam seç
`--scope public|private|all` verilmemişse **SOR** (public/private/all).

## 2. Tara (read-only)
`gh-audit` çalıştır → önceliklendirilmiş sağlık raporu (profil + repolar).
Kullanıcıya raporu göster; hangi bölümleri düzeltmek istediğini sor.

## 3. Profil kimliği
Eksik hesap alanı varsa → `profile-bio` (interaktif, sorar, onaylı yazar).

## 4. Profil README
`<login>/<login>` README yok/zayıfsa → `profile-readme` (üret, diff, onaylı push).

## 5. Repo metadata
Seçilen kapsamdaki repolarda → `gh-normalize` (desc + topics, batch + repo-başına onay).

## 6. Proje README'leri
README'si eksik/zayıf repolarda → `readme-standard` (create/fix/tr-sync).

## 7. Özet + kalan
Yapılanları + API ile yapılamayanları (pronouns, PRO badge, local time) + manuel işleri listele.

## Akış kuralları
- Sıra: kimlik → public repo metadata → public README → (opsiyonel) private.
- Her aşama **opt-in**: kullanıcı atlayabilir.
- Read önce, write sonra; hiçbir dışa-dönük adım onaysız (CLAUDE.md #8).
- Hesabı genel okur (`gh api user`) — kullanıcıya özel hardcode yok; başka hesapta da çalışır.
