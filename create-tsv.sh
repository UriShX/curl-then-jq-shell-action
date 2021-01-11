#!/bin/sh

curl --silent "https://api.nordvpn.com/v1/servers" >dump.json

echo 'ID Identifier Title' | sed 's/\ /\t/g' >server-groups.tsv
curl --silent "https://api.nordvpn.com/v1/servers/groups" | jq --raw-output '.[]  | [.id, .identifier, .title] | @tsv' | sed 's/\ /_/g' >>server-groups.tsv

echo 'ID Code Name' | sed 's/\ /\t/g' >countries.tsv
curl --silent "https://api.nordvpn.com/v1/servers/countries" | jq --raw-output '.[] | [.id, .code, .name] | @tsv' | sed 's/\ /_/g' >>countries.tsv
