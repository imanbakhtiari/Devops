#!/bin/bash
# Directory containing the files
source $1
directory=$CONF_DIR
vpn-edit(){


source $1
ask_question() {

    local question=$1
    local answer

    read -p "$question " answer
    echo "$answer"
}
operation=$(ask_question """
choose operation:
 n|-n|--name        for rename config and account
 l|-l|--local       for change local gateway for vpn routing
 g|-g|--gateway     for change tunnel default gateway for system default routing its depend on your vpn dhcp server range
 i|-i|--ip          for change host address only
 p|-p|--port        for change port address only
 h|-h|--hub         for change destination hub address only
 u|-u|--user        for change vpn username
 w|-w|--password    for change vpn username
---> """)
CMD="$CLIENT_DIR/vpncmd /CLIENT localhost /CMD"
case $operation in
    n|-n|--name)
        vpn_name=$(ask_question "Choose name your vpn configs?")
        $CMD  AccountDisconnect $ACCOUNT_NAME
        $CMD  AccountRename $ACCOUNT_NAME /NEW:$vpn_name
        $CMD  NicDelete $NIC_NAME
        NIC_NAME=${vpn_name,,}
        $CMD NicCreate $NIC_NAME
        $CMD AccountNicSet $vpn_name /NICNAME:$NIC_NAME
        sed -i "s/NIC_NAME=\"[^\"]*\"/NIC_NAME=\"$NIC_NAME\"/g" $1
        sed -i "s/ACCOUNT_NAME=\"[^\"]*\"/ACCOUNT_NAME=\"$vpn_name\"/g" $1
        mv $1  $CONF_DIR/$vpn_name'_config'
    ;;
    g|-g|--gateway)
         vpn_gate=$(ask_question "Enter Your Gateway Choice: ")
        sed -i "s/DEFAULT_GW=\"[^\"]*\"/DEFAULT_GW=\"$vpn_gate\"/g" $1
        /bin/vpn start $1
    ;;
    l|-l|--local)
        vpn_gate=$(ask_question "Enter Your Gateway Choice: ")
        sed -i "s/LOCAL_GATEWAY=\"[^\"]*\"/LOCAL_GATEWAY=\"$vpn_gate\"/g" $1
        /bin/vpn start $1
    ;;
    i|-i|--ip)
        vpn_host=$(ask_question "What is your vpn host?")
        $CMD AccountSet $ACCOUNT_NAME /SERVER:$vpn_host:$VPN_PORT /HUB:$DESTINATION_HUB
        sed -i "s/VPN_HOST_IPv4=\"[^\"]*\"/VPN_HOST_IPv4=\"$vpn_host\"/g" $1
    ;;
    p|-p|--port)
        vpn_port=$(ask_question "What is your vpn port?")
        $CMD AccountSet $ACCOUNT_NAME /SERVER:$VPN_HOST_IPv4:$vpn_port /HUB:$DESTINATION_HUB
            sed -i "s/VPN_PORT=\"[^\"]*\"/VPN_PORT=\"$vpn_port\"/g" $1
        echo $1
    ;;
    h|-h|--hub)
        vpn_hub=$(ask_question "What is your vpn destination hub?")
        $CMD AccountSet $ACCOUNT_NAME /SERVER:$VPN_HOST_IPv4:$VPN_PORT /HUB:$vpn_hub
        sed -i "s/DESTINATION_HUB=\"[^\"]*\"/DESTINATION_HUB=\"$vpn_hub\"/g" $1
    ;;
    u|-u|--user)
        vpn_user=$(ask_question "What is your vpn username?")
        $CMD AccountUsernameSet $ACCOUNT_NAME /USERNAME:$vpn_user
    ;;
    w|-w|--password)
        vpn_password=$(ask_question "What is your vpn password?")
        while true;do
            vpn_pass_type=$(ask_question "What is your vpn password? s for standard r for radius [ default is standard ]: ")
            case $vpn_pass_type in
                s|-s|"")
                    vpn_pass_type="standard"
                    $CMD AccountPasswordSet $ACCOUNT_NAME /PASSWORD:vpn_password /TYPE:$vpn_pass_type
                    break
                ;;
                r|-r)
                    vpn_pass_type="radius"
                    CMD AccountPasswordSet $ACCOUNT_NAME /PASSWORD:vpn_password /TYPE:$vpn_pass_type
                    break
                ;;
                *)
                    echo "only r or s can be use"
                ;;
            esac
        done

    ;;
    *)
        echo "why?"
    ;;
esac

}

export -f vpn-edit
$CLIENT_DIR/vpn-list.sh $1 vpn-edit $CLIENT_DIR/vpn-edit.sh

