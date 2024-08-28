#!/bin/bash
source $1
directory=$CONF_DIR
vpn-print(){
source $1
CMD="$CLIENT_DIR/vpncmd /CLIENT localhost /CMD"
echo '''
#######################################################
######                                           ######
######       Config File Parameters are:         ######
######                                           ######
#######################################################
'''
cat $1
echo '''
#######################################################
######                                           ######
######     SoftEther Serice Account Details:     ######
######                                           ######
#######################################################
'''
$CMD AccountGet $ACCOUNT_NAME

}
export -f vpn-print
$CLIENT_DIR/vpn-list.sh $1 "vpn-print" $CLIENT_DIR/vpn-show.sh

