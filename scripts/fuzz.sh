#!/bin/sh
# A longer run of the mutation fuzzer (tests/fuzz_test.ei): parsing and the derived decoders
# on N mutants per seed document (default 100000); every mutant must decode or be rejected
# with a path, never trap, and what decodes must round-trip. Prints the counts; a trap is a
# non-zero exit, a broken round trip a line naming it.
#
#   sh scripts/fuzz.sh [N]
here=$(cd "$(dirname "$0")/.." && pwd -P)
. "$here/scripts/env.sh"
cd "$here" || exit 1
mkdir -p target
ei build tests/fuzz_test.ei -o target/fuzz_json > target/fuzz.log 2>&1 || { cat target/fuzz.log; exit 1; }
FUZZ_ITERS=${1:-100000} ./target/fuzz_json > target/fuzz.out
rc=$?
grep -v '^{' target/fuzz.out
[ $rc = 0 ] && ! grep -q 'round trip\|without a path' target/fuzz.out
