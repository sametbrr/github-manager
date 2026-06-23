---
name: profile-bio
description: Claude Code skill that fills GitHub account profile fields — name, bio, company, location, blog and social accounts — via the GitHub API, asking for any missing value without inventing one.
disable-model-invocation: true
---

# profile-bio

GitHub hesap profil alanlarını interaktif doldurur (`PATCH /user` + social accounts).
**Değer uydurmaz** — eksik alanı sorar. Yazma onaylıdır.

## 0. Auth preflight
`user` scope şart:
```bash
gh auth status >/dev/null 2>&1 || echo "→ ! gh auth login --web -s repo,read:org,user"
```

## 1. Mevcut durumu oku
```bash
gh api user --jq '{name,bio,company,location,blog,twitter_username}'
gh api /user/social_accounts --jq '[.[]|{provider,url}]'
```

## 2. Standarda göre değerlendir
Oku: `${CLAUDE_PLUGIN_ROOT}/STANDARDS/profile-bio.md`.
Eksik/zayıf alanları çıkar (zorunlu: name, bio≤160; önerilen: location, blog, ≥2 social).

## 3. Eksikleri SOR (uydurma yok)
- Zorunlu eksik (name/bio) → kullanıcıya sor.
- Önerilen eksik (location/blog/company/social) → "doldurmak ister misin?" diye sor; boş bırakılabilir.
- `company` dahil hiçbir değeri tahmin etme.
- API'de olmayanları (pronouns, PRO badge, local time) **manuel** olarak not düş, dokunma.

## 4. Diff + onay
Değişecek alanları `mevcut → yeni` göster. Kullanıcı onaylamadan yazma (dışa-dönük değişiklik).

## 5. Uygula
```bash
# yalnız değişen alanlar:
gh api -X PATCH /user -f name='...' -f bio='...' -f company='...' -f location='...' -f blog='...'
# social ekle:
gh api -X POST /user/social_accounts -f "account_urls[]=https://..."
# social sil (gerekirse):
gh api -X DELETE /user/social_accounts -f "account_urls[]=https://..."
```

## Kurallar
- Değer **uydurma** (CLAUDE.md #7); kullanıcı atlarsa boş kalsın.
- Yazma **onaylı** (CLAUDE.md #8); dokunulmayan alanı gönderme (CLAUDE.md #6).
- Mevcut social hesapları silme (kullanıcı istemedikçe).
