# event_ledger

**One capability bit from GBT V8, packaged standalone.** No. 215 of 341,
`security` domain (Security).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 签名事件账（蒸馏自 2026-09-28 主人给的周榜卡 buzz block/buzz 34,934★，只取**账本纪律**「每条消息都是签名记录」，不引 Nostr 中继/网络面——出网归门与它自己的闸；人机同室协作已有 collab_gateway）：哈希链 + HMAC 签名，`hash=sha256(prev+规范化body)`、`sig=HMAC(key,hash)` ⇒ **改任意一条，它之后每一条都对不上，定位到第一条被改的**；钥匙随机生成 **DPAPI 落盘无明文**（复用仓内 deepseek_key 帮手），DPAPI 不可用 ⇒ fail-closed；**只增不删**（作废走 append retract）。op=append/verify/tail/status/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-event-ledger.git
cd gbt-event-ledger
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_event_ledger info                  # capability card
python -m gbt_event_ledger spec --json           # machine-readable contract
python -m gbt_event_ledger check --payload '{}'
python -m gbt_event_ledger run   --payload '{}'
```

Real `info` output from this machine:

```text
event_ledger  (security)  v1.0.0
----------------------------------------
签名事件账（蒸馏自 2026-09-28 主人给的周榜卡 buzz block/buzz 34,934★，只取**账本纪律**「每条消息都是签名记录」，不引 Nostr 中继/网络面——出网归门与它自己的闸；人机同室协作已有 collab_gateway）：哈希链 + HMAC 签名，`hash=sha256(prev+规范化body)`、`sig=HMAC(key,hash)` ⇒ **改任意一条，它之后每一条都对不上，定位到第一条被改的**；钥匙随机生成 **DPAPI 落盘无明文**（复用仓内 deepseek_key 帮手），DPAPI 不可用 ⇒ fail-closed；**只增不删**（作废走 append retract）。op=append/verify/tail/status/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : append, verify, tail, status, where
```

Wire a real implementation:

```python
from gbt_event_ledger import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（5 个）**：`append`、`verify`、`tail`、`status`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `event_ledger` |
| domain | `security` |
| handler | `event_ledger` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [security/event_ledger](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/security/event_ledger.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
