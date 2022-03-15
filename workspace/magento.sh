
#! /bin/bash

# Magento auto completion

export MAGENTO_CMDS_FILE="./var/cmds.txt"

function _mage() {
    COMP_WORDBREAKS=${COMP_WORDBREAKS//:}

    if [ -f "$MAGENTO_CMDS_FILE" ]; then
        COMMANDS=$(cat "$MAGENTO_CMDS_FILE")
    else
        COMMANDS=`php bin/magento --raw --no-ansi list | sed "s/[[:space:]].*//g"`
    fi

    COMPREPLY=(`compgen -W "$COMMANDS" -- "${COMP_WORDS[COMP_CWORD]}"`)

    return 0
}

function mage_cache() {
    if [[ "$1" == "clear" ]]; then
        echo -n "Removing commands cache file..."
        rm -f "$MAGENTO_CMDS_FILE"
        echo "done."
    else
        php bin/magento --raw --no-ansi list | awk '{print $1}' > "$MAGENTO_CMDS_FILE"
        echo $(wc -l "$MAGENTO_CMDS_FILE" | awk '{print $1}')" Magento commands cached."
    fi
}

complete -F _mage bin/magento
