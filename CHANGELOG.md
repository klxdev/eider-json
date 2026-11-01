# Changelog

eider-json's versions (semver). Before 1.0 the MAJOR.MINOR is the Eider toolchain's it goes
with (`eider` in eider.toml), the PATCH its own.

## 0.2.1

Typed JSON with derived codecs (eider-json#1), for an Eider 0.2 toolchain with attributes and
comptime reflection (eider-lang #19, #20: after eider-lang 0.2.0; it doesn't build with 0.2.0
itself). Compatible: everything before is unchanged.

- `Encode` and `Decode` traits, `to_json`, `from_json` and `from_json_with`, with impls for
  i32, i64, u8, u32, u64, usize, bool, String, str (encoding), List[T], Option[T] and
  Map[String, T] (written in key order).
- Derived codecs for records and enums: `encode_record`/`decode_record`,
  `encode_enum`/`decode_enum`, over the type's fields with comptime reflection, and
  `attr json { name, skip, default, flatten, rename_all, tag, unknown }`: renames, skipped
  fields (their Default on decoding), defaults for missing members, flattened records, name
  cases (`snake_case`, `camelCase`, `kebab-case`, `SCREAMING_SNAKE_CASE`), an enum's
  discriminator key (default `type`; variants without fields are strings), and a per-type
  policy for unknown members (`deny` by default, or `ignore`).
- Secure defaults: `limits()` (8 MiB, depth 64, strings of 1 MiB, 100,000 items, no repeated
  keys) for `from_json`, `parse_with` for any `Limits`; `parse` keeps its old behaviour.
  Decode errors carry a JSONPath (`decode_error_text`).
- A mutation fuzzer (tests/fuzz_test.ei, `sh scripts/fuzz.sh N`): mutants must decode or be
  rejected with a path, never trap, and round-trip.

## 0.2.0

For Eider 0.2 (`eider = "0.2"`): eider-lang's 0.2 builds programs only through LLVM (clang
17 or newer; U23) and bootstraps the compiler from a WebAssembly seed (seed/eiderc.wasm; U24).
scripts/env.sh recognises such a checkout (seed/eiderc.wasm, or seed/eiderc.c before).
Nothing else changed.

## 0.1.3

The scripts find the Eider toolchain through `eider` (eider-lang#133) instead of a fixed
eider-lang checkout: scripts/env.sh takes `$EIDER_TOOLCHAIN` (a toolchain directory or an
eider-lang checkout; eider-lang's scripts/check-tools.sh sets it to its checkout), else the
toolchain `eider toolchain show --json` names for this repository's `eider = "0.1"` (the
newest installed 0.1 release), else stops with exit 2 and says to install `eider`
(install.sh). eiderc and eider-pkg run through `eider` with that toolchain (`eider eiderc`,
`eider eider-pkg`), or directly when `eider` is not on the PATH. `EIDER_ROOT` and
`EIDER_LANG` no longer choose the toolchain, and `../eider-lang` is no longer the default.
The pinned `.vendor/<name>` fallback for a dependency applies when the toolchain is an
eider-lang checkout. Tested with the released Eider 0.1.0 and with eider-lang main. No
change to the library's code.

## 0.1.2

scripts/env.sh takes a dependency that has no `EIDER_<NAME>` and no sibling checkout from the
toolchain's pinned release in `$EIDER_ROOT/.vendor/<name>` when eider-lang's `vendor.lock`
pins it (its `scripts/vendor.sh fetch <name>` fetches and hash-checks it on first use), else
from its repository. The toolchain's old `vendor/` is no longer looked at (eider-lang #130 and
#124; no backwards compatibility). No change to the library itself (it has no dependencies, so env.sh overrides nothing); the README says where eider-lang's pinned copy lives now (`.vendor/json`, pinned by its vendor.lock).

Needs an Eider 0.1 toolchain; the pinned copy needs one with `vendor.lock` (eider-lang #122),
and without one a dependency comes from a sibling checkout or the network.

## 0.1.1

Imports in the dotted form (eider-lang C8.26, issue #91): `import std.bytes` and `import
json` instead of the quoted `import "std/bytes"` and `import "../json.ei"`, in the code, the
tests, the README and the program scripts/build.sh generates to check every module.

Needs an Eider 0.1 toolchain whose compiler knows dotted imports (the eider-lang commit after
the next seed); an older 0.1 compiler stops at the first dotted import (E0001).

## 0.1.0

The first release as a repository of its own, for Eider 0.1. The code is eider-lang's
`packages/json` as of the split (its history is kept): eider-lang now vendors this
release in `vendor/json` for its own tools.

- `VERSION`, `eider = "0.1"`, `scripts/build.sh` and `scripts/test.sh` against an eider-lang
  checkout (`EIDER_ROOT`), refusing a toolchain of another MAJOR.MINOR.
- `scripts/version.sh` (`check`, `sync`): eider.toml agrees with VERSION; eider-lang's
  `scripts/version.sh check-siblings` and `bump` drive it.
