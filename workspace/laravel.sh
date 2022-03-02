
#! /bin/bash

# Laravel auto completion

export ARTISAN_CMDS_FILE="./bootstrap/cache/artisan.txt"

function _artisan() {
    local arg="${COMP_LINE#php }"

    case "$arg" in
        artisan*)
            COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
            if [ -f "$ARTISAN_CMDS_FILE" ]; then
                COMMANDS=$(cat "$ARTISAN_CMDS_FILE")
            else
                COMMANDS=`php artisan --raw --no-ansi list | sed "s/[[:space:]].*//g"`
            fi

            COMPREPLY=(`compgen -W "$COMMANDS" -- "${COMP_WORDS[COMP_CWORD]}"`)
            ;;
        *)
            COMPREPLY=( $(compgen -o default -- "${COMP_WORDS[COMP_CWORD]}") )
            ;;
        esac

    return 0
}

function art_cache() {
    if [[ "$1" == "clear" ]]; then
        echo -n "Removing commands cache file..."
        rm -f "$ARTISAN_CMDS_FILE"
        echo "done."
    else
        php artisan --raw --no-ansi list | awk '{print $1}' > "$ARTISAN_CMDS_FILE"
        echo $(wc -l "$ARTISAN_CMDS_FILE" | awk '{print $1}')" artisan commands cached."
    fi
}

complete -F _artisan php
