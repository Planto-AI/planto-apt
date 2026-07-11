#!/usr/bin/env bash
# One-time enrolment of an installed PlantoOS machine into the update channel.
# Public GPG-signed feed - no tokens, no secrets on the machine.
#   curl -fsSL https://planto-ai.github.io/planto-apt/bootstrap.sh | sudo bash
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "Run me with sudo/root."; exit 1; }
FEED="https://planto-ai.github.io/planto-apt"

echo ">> Installing PlantoOS archive keyring"
curl -fsSL "$FEED/planto-archive-keyring.gpg" \
  -o /usr/share/keyrings/planto-archive-keyring.gpg
chmod 0644 /usr/share/keyrings/planto-archive-keyring.gpg

echo ">> Writing /etc/apt/sources.list.d/planto.sources"
cat > /etc/apt/sources.list.d/planto.sources <<EOF
Types: deb
URIs: $FEED
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/planto-archive-keyring.gpg
EOF

# Drop any legacy token-auth config from the old private-feed design.
rm -f /etc/apt/auth.conf.d/planto.conf

apt-get update
apt-get install -y planto-desktop
echo "Enrolled. PlantoOS updates now appear in Discover like normal Debian updates."
