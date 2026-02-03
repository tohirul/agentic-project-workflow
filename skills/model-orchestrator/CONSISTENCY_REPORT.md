# Model Orchestrator Consistency Report (Manual)

This document defines a repeatable, manual checklist for validating
model and intent consistency across orchestrator docs.

## Scope

Files covered:

- skills/model-orchestrator/intent-classifier.md
- skills/model-orchestrator/selection.md
- skills/model-orchestrator/configuration.md
- skills/model-orchestrator/SKILL.md
- skills/model-orchestrator/telemetry.md

## Intent Consistency Check

Run:

```bash
extract_intents() {
  local file="$1" start="$2" end="$3"
  awk -v s="$start" -v e="$end" '
    $0 ~ s {inside=1; next}
    inside && $0 ~ e {inside=0}
    inside {print}
  ' "$file" | rg -o '`[a-z_]+' | tr -d '`' | sort -u
}

ic=$(extract_intents skills/model-orchestrator/intent-classifier.md '^## Canonical Intent Set' '^## ')
sel=$(extract_intents skills/model-orchestrator/selection.md '^## Canonical Intent Vocabulary' '^## ')
sk=$(extract_intents skills/model-orchestrator/SKILL.md '^Valid intents only:' '^Intent is')

printf '=== Intent Scan Results ===\n'

printf 'Intent sets by file:\n'
printf '- intent-classifier.md:\n%s\n' "$ic"
printf '- selection.md:\n%s\n' "$sel"
printf '- SKILL.md:\n%s\n' "$sk"

intent_diffs() {
  local b="$1" label="$2"
  printf '\nIntent differences vs intent-classifier for %s:\n' "$label"
  comm -23 <(printf "%s\n" "$ic") <(printf "%s\n" "$b") | sed 's/^/  missing: /'
  comm -13 <(printf "%s\n" "$ic") <(printf "%s\n" "$b") | sed 's/^/  extra:   /'
}

intent_diffs "$sel" 'selection.md'
intent_diffs "$sk" 'SKILL.md'

printf '\nUnified intent list:\n'
printf '%s\n' "$ic" "$sel" "$sk" | sort -u
```

Pass condition:
- No missing or extra entries in selection.md or SKILL.md.

## Model ID Consistency Check (Strict)

Run:

```bash
extract_models() {
  rg -o -I "\b(gemini-[a-z0-9.-]+|mistral-[a-z0-9.-]+|gpt-[a-z0-9.-]+|kimi-[a-z0-9.-]+|minimax-[a-z0-9.-]+|codestral-[a-z0-9.-]+|big-pickle|qwen-[a-z0-9.-]+|deepseek-[a-z0-9.-]+|glm-[a-z0-9.-]+)\b" "$1" | sort -u
}

sel=$(extract_models skills/model-orchestrator/selection.md)
conf=$(extract_models skills/model-orchestrator/configuration.md)
tel=$(extract_models skills/model-orchestrator/telemetry.md)
sk=$(extract_models skills/model-orchestrator/SKILL.md)

printf '=== Model Scan Results ===\n'

printf 'Models by file (ID-style only):\n'
printf '- selection.md:\n%s\n' "$sel"
printf '- configuration.md:\n%s\n' "$conf"
printf '- telemetry.md:\n%s\n' "$tel"
printf '- SKILL.md:\n%s\n' "$sk"

model_diffs() {
  local b="$1" label="$2"
  printf '\nModel ID differences vs configuration.md for %s:\n' "$label"
  comm -23 <(printf "%s\n" "$conf") <(printf "%s\n" "$b") | sed 's/^/  missing: /'
  comm -13 <(printf "%s\n" "$conf") <(printf "%s\n" "$b") | sed 's/^/  extra:   /'
}

model_diffs "$sel" 'selection.md'
model_diffs "$tel" 'telemetry.md'
model_diffs "$sk" 'SKILL.md'

printf '\nUnified model list (ID-style only):\n'
printf '%s\n' "$sel" "$conf" "$tel" "$sk" | sort -u

if [[ -z "$(comm -23 <(printf "%s\n" "$ic") <(printf "%s\n" "$sel"))" ]] && \
   [[ -z "$(comm -13 <(printf "%s\n" "$ic") <(printf "%s\n" "$sel"))" ]] && \
   [[ -z "$(comm -23 <(printf "%s\n" "$ic") <(printf "%s\n" "$sk"))" ]] && \
   [[ -z "$(comm -13 <(printf "%s\n" "$ic") <(printf "%s\n" "$sk"))" ]] && \
   [[ -z "$(comm -23 <(printf "%s\n" "$conf") <(printf "%s\n" "$sel"))" ]] && \
   [[ -z "$(comm -13 <(printf "%s\n" "$conf") <(printf "%s\n" "$sel"))" ]] && \
   [[ -z "$(comm -23 <(printf "%s\n" "$conf") <(printf "%s\n" "$tel"))" ]] && \
   [[ -z "$(comm -13 <(printf "%s\n" "$conf") <(printf "%s\n" "$tel"))" ]] && \
   [[ -z "$(comm -23 <(printf "%s\n" "$conf") <(printf "%s\n" "$sk"))" ]] && \
   [[ -z "$(comm -13 <(printf "%s\n" "$conf") <(printf "%s\n" "$sk"))" ]]; then
  printf '\n=== CONSISTENCY RESULT: PASS ===\n'
else
  printf '\n=== CONSISTENCY RESULT: FAIL ===\n'
fi
```

Pass condition:
- No missing or extra entries in selection.md, telemetry.md, or SKILL.md.

## Notes

- This checklist assumes model names include IDs in parentheses.
- If IDs are removed, the strict model scan will not be reliable.
