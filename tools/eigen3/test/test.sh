set -u
set -o pipefail

cmake . || exit 127
