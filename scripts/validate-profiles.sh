#!/bin/sh
# Validates all profiles in profiles/ to ensure required fields are set
# and ALIAS values are unique.
# Exit code 0 = all good, 1 = one or more errors found.

PROFILES_DIR="$(dirname "$0")/../profiles"
REQUIRED_FIELDS="HF_REPO MODEL_DIR MODEL_FILE ALIAS"
errors=0

# Check required fields in each profile
for profile in "$PROFILES_DIR"/.env-*; do
  name=$(basename "$profile")
  for field in $REQUIRED_FIELDS; do
    value=$(grep "^${field}=" "$profile" | cut -d'=' -f2-)
    if [ -z "$value" ]; then
      echo "ERROR: $name is missing $field"
      errors=$((errors + 1))
    fi
  done
done

# Check for duplicate ALIAS values
aliases=$(grep -h "^ALIAS=" "$PROFILES_DIR"/.env-* | cut -d'=' -f2- | sort)
duplicates=$(echo "$aliases" | uniq -d)
if [ -n "$duplicates" ]; then
  echo "WARNING: Duplicate ALIAS values found (multiple profiles share the same alias):"
  for dup in $duplicates; do
    echo "  $dup"
    grep -l "^ALIAS=$dup" "$PROFILES_DIR"/.env-* | while read -r f; do
      echo "    $(basename "$f")"
    done
  done
fi

if [ "$errors" -gt 0 ]; then
  echo ""
  echo "Found $errors error(s). Fix the profiles above before merging."
  exit 1
fi

echo "All $(ls "$PROFILES_DIR"/.env-* | wc -l | tr -d ' ') profiles are valid."
