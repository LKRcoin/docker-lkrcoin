#!/bin/bash
set -e

if [[ "$1" == "LKRcoind" ]]; then
	mkdir -p "$LKRCOIN_DATA"

	if [[ ! -s "$LKRCOIN_DATA/LKRcoin.conf" ]]; then
		cat <<-EOF > "$LKRCOIN_DATA/LKRcoin.conf"
		bind=127.0.0.1:34957
		rpcbind=0.0.0.0:34958
		printtoconsole=1
		rpcallowip=::/0
		rpcpassword=${LKRCOIN_RPC_PASSWORD:-password}
		rpcuser=${LKRCOIN_RPC_USER:-bitcoin}
		addnode=109.94.110.42
		addnode=131.100.90.98
		addnode=181.17.101.202
		addnode=181.17.38.160
		addnode=181.18.20.147
		addnode=181.18.23.123
		addnode=181.18.84.173
		addnode=181.34.37.96
		addnode=181.34.70.18
		addnode=186.167.243.184
		addnode=186.167.248.61
		addnode=186.91.94.58
		addnode=186.93.163.94
		addnode=186.93.218.239
		addnode=186.94.113.15
		addnode=186.95.238.241
		addnode=190.103.30.206
		addnode=190.161.241.157
		addnode=190.163.213.17
		addnode=190.198.212.16
		addnode=190.199.249.246
		addnode=190.202.24.126
		addnode=190.206.92.60
		addnode=190.217.14.98
		addnode=190.237.19.135
		addnode=190.36.54.169
		addnode=190.37.220.1
		addnode=190.75.169.165
		addnode=190.94.247.34
		addnode=200.82.141.143
		addnode=201.238.31.137
		addnode=201.242.213.251
		addnode=201.248.251.119
		addnode=212.95.5.102
		addnode=31.40.218.121
		addnode=45.184.103.99
		addnode=45.236.31.62
		addnode=91.92.128.71
		addnode=93.82.95.28
		addnode=94.156.189.84
		addnode=94.23.201.20
		addnode=95.217.145.114
		EOF
		chown lkrcoin:lkrcoin "$LKRCOIN_DATA/LKRcoin.conf"
	fi

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R lkrcoin "$LKRCOIN_DATA"
	ln -sfn "$LKRCOIN_DATA" /home/lkrcoin/.LKRcoin
	chown -h lkrcoin:lkrcoin /home/lkrcoin/.LKRcoin

	exec  "$@"
fi

exec "$@"