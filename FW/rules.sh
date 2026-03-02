#!/bin/bash

nft flush ruleset

nft add table inet filter
nft add chain inet filter input { type filter hook input priority 0 \; policy drop \; }
nft add chain inet filter forward { type filter hook forward priority 0 \; policy drop \; }
nft add chain inet filter output { type filter hook output priority 0 \; policy accept \; }

# loopback
nft add rule inet filter input iif lo accept

# established
nft add rule inet filter input ct state established,related accept

# -------------------------
# CENTOS (Proxy)
# -------------------------

# cache-api открыт для всех
nft add rule inet filter input tcp dport 5000 accept

# valkey только локально
nft add rule inet filter input ip saddr 127.0.0.1 tcp dport 6379 accept

# -------------------------
# UBUNTU (Backend)
# -------------------------

# backend только от proxy
nft add rule inet filter input ip saddr 192.168.1.73 tcp dport 8080 accept

# postgresql только локально
nft add rule inet filter input ip saddr 127.0.0.1 tcp dport 5432 accept
