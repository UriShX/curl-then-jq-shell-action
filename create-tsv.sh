#!/bin/sh

curl --silent "https://api.nordvpn.com/v1/servers" >dump.json

curl --silent "https://api.nordvpn.com/v1/servers/groups" | jq --raw-output '.[]  | [.id, .identifier, .title] | @tsv' >server-groups.tsv

curl --silent "https://api.nordvpn.com/v1/servers/countries" | jq --raw-output '.[] | [.id, .code, .name] | @tsv' >countries.tsv
sed -i 's/\ /_/g' countries.tsv
