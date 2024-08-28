#!/bin/bash
# Directory containing the files
source $1
directory=$CONF_DIR
vpn-choose(){
    vpn_main_conf="$CONF_DIR/vpn_config"
    echo "$vpn_main_conf"
    file=$(printf '%s\n' "$1" | sed 's/[\/&]/\\&/g')
    sed -i "s/MAIN_CLIENT_CONFIG=\"[^\"]*\"/MAIN_CLIENT_CONFIG=\"$file\"/g" $vpn_main_conf
    echo $1
}
export -f vpn-choose
$CLIENT_DIR/vpn-list.sh $1 vpn-choose $CLIENT_DIR/vpn-choice.sh

