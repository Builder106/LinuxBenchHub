#!/usr/bin/env bash
# Distro-agnostic PTS capture body, run *inside* a distro container.
#
# Mirrors the x86 matrix job's steps (capture-benchmarks.yml) exactly, minus
# the package install (the caller runs pkg-install.sh first) so the same
# script works unmodified whether the container is started by GitHub Actions'
# `container:` key (x86) or by `docker run` over SSH on the Ampere host
# (arm64). Expects /pts-batch-config.xml to be bind-mounted in, and /output
# to be a bind-mounted host directory to drop composite.xml into.
set -euo pipefail

git clone --depth 1 https://github.com/phoronix-test-suite/phoronix-test-suite.git /tmp/pts
cd /tmp/pts
./install-sh /opt/pts
ln -sf /opt/pts/bin/phoronix-test-suite /usr/local/bin/phoronix-test-suite
phoronix-test-suite version

install -d /root/.phoronix-test-suite
cp /pts-batch-config.xml /root/.phoronix-test-suite/user-config.xml

# See capture-benchmarks.yml's "Configure batch mode" step for what each
# answer maps to — same seven yes/no prompts, same answers.
printf 'y\nn\nn\nn\nn\nn\nn\n' | phoronix-test-suite batch-setup

# Same historical c-ray args as the x86 legs (1080p, 16 rays/pixel) so the
# arm64 numbers stay comparable to the existing dataset.
printf '1\n16\n' | phoronix-test-suite batch-benchmark pts/c-ray pts/tinymembench pts/aircrack-ng

shopt -s nullglob
fails=(/var/lib/phoronix-test-suite/installed-tests/pts/*/install-failed.log)
for log in "${fails[@]}"; do
  test=$(basename "$(dirname "$log")")
  echo "warning: pts/$test failed to install — composite incomplete" >&2
  cat "$log" >&2 || true
done

composite=$(find /var/lib/phoronix-test-suite /root/.phoronix-test-suite \
             -name composite.xml -print -quit 2>/dev/null || true)
if [ -z "$composite" ]; then
  echo "error: no composite.xml produced" >&2
  exit 1
fi

cp "$composite" /output/composite.xml
echo "Saved composite.xml"
