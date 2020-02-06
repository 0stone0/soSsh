#!/bin/bash
set -e

# Statics
red=`tput setaf 1`; green=`tput setaf 2`; yellow=`tput setaf 3`; blue=`tput setaf 4`; magenta=`tput setaf 5`; bow=`tput setaf 0;tput setab 7`; reset=`tput sgr0`; hk="${blue})${reset}"; undl=`tput smul`; bold=`tput bold`;

#
#       exitByError
#       Shows error and dies
#       $! --> 1
#
function exitByError() {
    echo -e "\n${red}\n\t${@}${reset}\n"
    exit 1
}

#
#       _jq
#       Decodes and search for json key/value
#       $1 --> json
#       $2 --> key
#
function _jq() {
    echo ${1} | base64 --decode | jq -r ${2}
}

# Ensure json file exists


# Read JSON & Get some basics
raw=`jq . wCn.json`
b_port=$(echo $raw | jq -r '.default.port // 22')
b_user=$(echo $raw | jq -r '.default.user // "root"')
b_rsub=$(echo $raw | jq -r '.default.rsub // false')

# Ask for servers until we've reached the end
depth=1
reached_end=false
last_while_obj="$raw"
while [[ $reached_end == false ]]; do

    # Prefix
    prefin=$(( 4 * ${depth}))
    prefix=`printf %\ ${prefin}s|tr \  \ `

    # G
    has_g=$(echo "$last_while_obj " | jq ".g")
    if [[ "$has_g" != 'null' ]]; then

        # Show id & name of each group
        echo -e "\n${prefix}${green}Select${reset} ${undl}group${reset}:\n"
        for row in $(echo "$last_while_obj" | jq -r '.g[] | @base64'); do
            echo -e "${prefix}    $(_jq $row '.id')${hk}  $(_jq $row '.name')"
        done

        # Read input && search for matching group id
        read -sn1 input
        last_while_obj=`echo ${last_while_obj} | jq ".g[]  | select(.id == ${input})"`
        ((depth++)) && continue
    fi

    # S
    has_s=$(echo "$last_while_obj " | jq ".s")
    if [[ "$has_s" != 'null' ]]; then

        # Show id & name of each server
        echo -e "\n${prefix}${green}Select${reset} ${bold}$(echo "$last_while_obj" | jq -r ".name ")${reset} ${undl}server${reset}:\n"
        for row in $(echo "$last_while_obj" | jq -r '.s[] | @base64'); do
            echo -e "${prefix}    $(_jq $row '.id')${hk} $(_jq $row '.name')"
        done

        # Read input & get matching server
        read -sn1 input
        f_tmp=$(echo "$last_while_obj" | jq -r ".s[] | select(.id == ${input})")
        [[ -z $f_tmp ]] && exitByError 'Server not found!'

        # T
        has_t=$(echo "${f_tmp}" | jq ".t")
        if [[ ! -z $has_t && "$has_t" != '' && "$has_t" != null ]]; then

            # Remember base_name and base_user
            g_b_name=$(echo $f_tmp | jq '.name')
            g_b_ip="$(echo $f_tmp | jq '.ip')"

            # Create clean group name
            g_b_name_c="${g_b_name%\"}" && g_b_name_c="${g_b_name_c#\"}"
            g_b_name_c=$(echo ${g_b_name_c/\?\?/${red}X${reset}})

            # For .t times
            echo -e "\n${prefix}${green}Select${reset} ${bold}${g_b_name_c}${reset} ${undl}server${reset}:\n"
            for (( i = 0; i < has_t; i++ )); do

                # Create h_i (++)
                t_i=$i
                h_i=$(expr $t_i \+ 1)

                # Remove quotes
                t_ip="${g_b_ip%\"}" && t_ip="${t_ip#\"}"
                t_name="${g_b_name%\"}" && t_name="${t_name#\"}"

                # Replace '??' --> $i
                t_ip=$(echo ${t_ip/\?\?/$h_i})
                t_name=$(echo ${t_name/\?\?/$h_i})
                echo -e "${prefix}            ${h_i}${hk} ${t_name} ($t_ip)"
            done

            # Read and validate input
            read -sn1 input
            if [[ "$input" -lt "0" ]] || [[ "$input" -gt "$has_t" ]]; then
                exitByError "Server #${input} not found!"
            fi

            # Replace ?? with number
            f_ip=$(echo ${g_b_ip/\?\?/$i})
            f_name=$(echo ${g_b_name/\?\?/$input})

            # Set $f_s to custom object
            f_s="{ \"id\": ${has_t}, \"user\": $(echo $f_tmp | jq '.user'), \"name\": ${f_name}, \"ip\": ${f_ip}, \"rsub\": \"false\" }"
            reached_end=true
            ((depth++)) && continue
        fi

        # Ssh-server
        f_s="$f_tmp" && reached_end=true
    fi
done

# echo -e "\n\n${f_s}\n\n"

# Get server data, use default by null
to_ip=$(echo "$f_s" | jq -r ".ip")
to_port=$(echo "$f_s" | jq -r ".port // ${b_port}")
to_user=$(echo "$f_s" | jq -r ".user // \"${b_user}\"")
to_rsub=$(echo "$f_s" | jq -r "select(.rsub != false) | .rsub // \"${b_rsub}\"")

# Ensure ip is found
[[ "$to_ip" == '' ]] && exitByError 'Invalid ip'

# Create cmd, start with rsub
[[ ! -z $to_rsub && "$to_rsub" != false ]] && TO_CMD="-R ${to_rsub}:localhost:${to_rsub} ${TO_CMD}"
TO_CMD="ssh -A ${TO_CMD} -p ${to_port} ${to_user}@${to_ip}"

# Print
# echo -e "\n\n${TO_CMD}"
echo -e "\n-----------------\n\n${green}Trying to connect to:${reset} ${red}${to_user}${magenta}@${yellow}${to_ip}${magenta}:${green}${to_port} ${reset}\n"
