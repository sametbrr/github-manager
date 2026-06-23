# Profile Bio Standard (account fields)

GitHub hesap profil alanları (`PATCH /user` + `/user/social_accounts`).
**Kural: değer UYDURMA** — eksik alanı raporla, kullanıcıya sor; atlarsa boş kalır.

## Alanlar

| Alan | API | Durum | Not |
|---|---|---|---|
| `name` | PATCH /user | **zorunlu** | gerçek ad |
| `bio` | PATCH /user | **zorunlu** | ≤160 char; rol token'ları `·` ile ayrılır |
| `location` | PATCH /user | önerilen | şehir |
| `blog` | PATCH /user | önerilen | kişisel site/portföy URL |
| `company` | PATCH /user | opsiyonel | boş kalabilir |
| `twitter_username` | PATCH /user | opsiyonel | social ile çakışabilir |
| `email`, `hireable` | PATCH /user | opsiyonel | gizlilik tercihi |
| social accounts | POST/DELETE /user/social_accounts | önerilen ≥2 | linkedin, x, npm, nuget(generic)… |

## bio formatı

Rol/teknoloji token'ları orta-nokta `·` ile; tek satır, ≤160 char.
Örnek (mevcut): `Full Stack Developer · .NET & C# · Angular/React · LLM tools, AI Skills & MCPs`

## API ile AYARLANAMAZ (manuel — audit not düşer, dokunmaz)

- **Pronouns**
- **Display PRO badge**
- **Display current local time**

## Kurallar

1. Eksik **zorunlu** alan (name/bio) → kullanıcıya sor, asla uydurma.
2. Eksik **önerilen** alan → bildir, kullanıcı isterse doldur.
3. social accounts: en az LinkedIn + X önerilir; mevcut olanı silme.
4. Yazma = `PATCH /user` → **dışa-dönük**, uygulamadan önce onay.

## Checklist (account-analyzer / profile-bio bunu kullanır)

- [ ] name dolu
- [ ] bio dolu, ≤160 char
- [ ] location dolu (önerilen)
- [ ] blog dolu (önerilen)
- [ ] ≥2 social account
- [ ] company durumu kullanıcıya bırakıldı (uydurulmadı)
