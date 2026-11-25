#!/usr/bin/env bash
# Re-captures test/fixtures/*.json from a running, freshly seeded FishDex backend.
#   cd fishdex-api && php artisan migrate:fresh --seed && php artisan serve
#   cd fishdex_app && API=http://127.0.0.1:8000/api/v1 bash tool/capture_fixtures.sh
# Needs curl and python3 (Git Bash on Windows works).
set -euo pipefail
API="${API:-http://127.0.0.1:8000/api/v1}"
cd "$(dirname "$0")/../test/fixtures"
J=(-H "Accept: application/json" -H "Content-Type: application/json")
STAMP=$(date +%s)

curl -sf -H "Accept: application/json" "$API/app/config" > app_config.json
curl -s "${J[@]}" -X POST "$API/auth/register" -d "{\"email\":\"fx$STAMP@fishdex.test\",\"password\":\"Fx-toman-hunter-$STAMP!\",\"display_name\":\"Fixture\",\"handle\":\"fixture_user\",\"device_name\":\"test\"}" > register.json
TOKEN=$(python3 -c "import json;print(json.load(open('register.json'))['data']['token'])")
AUTH=(-H "Accept: application/json" -H "Authorization: Bearer $TOKEN")

curl -s "${J[@]}" -X POST "$API/auth/login" -d "{\"email\":\"fx$STAMP@fishdex.test\",\"password\":\"wrong\",\"device_name\":\"t\"}" > error_invalid_credentials.json
curl -s "${J[@]}" -X POST "$API/auth/register" -d '{"email":"bad"}' > error_validation.json
curl -s "${AUTH[@]}" -X POST "$API/me/ai-consent" > consent.json
curl -s "${AUTH[@]}" "$API/me" > me.json
curl -s "${AUTH[@]}" "$API/species?limit=3" > species_list.json
ID=$(curl -s "${AUTH[@]}" "$API/species?q=toman" | python3 -c "import json,sys;print(json.load(sys.stdin)['data'][0]['id'])")
curl -s "${AUTH[@]}" -H "Accept-Language: ms" "$API/species/$ID" > species_detail.json
curl -s "${AUTH[@]}" "$API/families" > families.json

for f in *.json; do python3 -c "import json;d=json.load(open('$f'));json.dump(d,open('$f','w'),indent=2,ensure_ascii=False)"; done
echo "Fixtures updated. Run: flutter test test/unit"
