#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_event_ledger info
PYTHONPATH=src python -m gbt_event_ledger check --payload '{}'
PYTHONPATH=src python -m gbt_event_ledger run   --payload '{}'
