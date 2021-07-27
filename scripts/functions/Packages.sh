#!/bin/bash

dependency_file="/opt/Pi-security/dependency.txt"

command_exists() {
    # check if command exists and fail otherwise
    command -v "$1" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "I require $1 but it's not installed. Abort."
        package=$1
        sed -e 's/$package=*/$package=false/' $dependency_file
    fi
}

install_dependencies() {
    while read -r line; do
        if [[ "$line" =~ "=false" ]]; then
            dependency=$(echo $line | cut -b -6)
            sudo apt install $dependency
            sed -e 's/$dependency=false/$dependency=true/' $dependency_file
        fi
    done <$dependency_file
}
