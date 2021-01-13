#!/bin/bash

GROUPS_DATA=$(curl --silent "https://api.nordvpn.com/v1/servers/groups" | jq --raw-output '.[]  | [.id, .identifier, .title] | @tsv' | sed 's/[,\ ]/_/g')
COUNTRIES_DATA=$(curl --silent "https://api.nordvpn.com/v1/servers/countries" | jq --raw-output '.[] | [.id, .code, .name] | @tsv' | sed 's/\ /_/g')

function identifiers() {
    echo "$1" | while read y; do
        echo $(awk '{print $2}')
    done
}

### RUN ###
rm group-countries.tsv server-groups.tsv countries.tsv
touch group-countries.tsv server-groups.tsv countries.tsv
IDS=$(identifiers "$GROUPS_DATA")
printf "ID\tIdentifier\tTitle\n" >>server-groups.tsv
printf "ID\tCode\tName\n" >>countries.tsv
printf "Group Identifier\tCountries\n" >>group-countries.tsv
for X in $IDS; do
    COUNTRIES=$(curl --silent "https://api.nordvpn.com/v1/servers?filters\[servers_groups\]\[identifier\]=$X&filters\[servers_technologies\]\[identifier\]=openvpn_tcp" | jq --raw-output '[.[] | .locations | .[].country.code] | unique | @tsv' | sed 's/\t/,\ /g')
    if [ ! -z "$COUNTRIES" ]; then
        printf "$X\t$COUNTRIES\n" >>group-countries.tsv
        echo "$GROUPS_DATA" | grep "$X" >>server-groups.tsv
    fi
done

CODES=$(identifiers "$COUNTRIES_DATA")

for X in $CODES; do
    N=$(grep -w "$X" group-countries.tsv)
    if [ ! -z "$N" ]; then
        echo "$COUNTRIES_DATA" | grep "$X" >>countries.tsv
    fi
done
