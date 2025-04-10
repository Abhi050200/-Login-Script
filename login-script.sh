#!/bin/bash

clear
MAX_ATTEMPTS=3
attempts=0
log_file="$HOME/login.log"
timeout_duration=30

cols=$(tput cols)
center_text() {
    local text="$1"
    printf "%*s\n" $(( (${#text} + cols) / 2 )) "$text"
}

while [ $attempts -lt $MAX_ATTEMPTS ]; do
    clear
    echo -e "\n"
    echo -e "\e[1;36m\e[1m$(center_text "🧨 Welcome to Abhi's Warzone User🧨")\e[0m"
    echo ""

    # Prompt for username with timeout
    read -t $timeout_duration -p "$(printf "\e[1m%*s\e[0m" $(( (cols + 13) / 2 )) "👤 Username: ")" username || {
        echo -e "\n\n\e[1;31m$(center_text "⏳ Timed out due to inactivity. Goodbye!")\e[0m"
        exit 1
    }

    # Prompt for password with timeout
    read -t $timeout_duration -sp "$(printf "\e[1m%*s\e[0m" $(( (cols + 13) / 2 )) "🔒 Password: ")" password || {
        echo -e "\n\n\e[1;31m$(center_text "⏳ Timed out due to inactivity. Goodbye!")\e[0m"
        exit 1
    }
    echo ""

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    if [[ "$username" == "abhi" && "$password" == "abhi" ]]; then
        echo -e "\n\e[1;32m$(center_text "✅ Identity confirmed. The machine is all yours!")\e[0m"
        echo "$timestamp | SUCCESS | Username: $username | Password: $password" >> "$log_file"
        sleep 2
        exit 0
    else
        echo -e "\n\e[1;31m$(center_text "❌ Invalid credentials.")\e[0m"
        echo -e "\e[1;33m$(center_text "📁 Log saved to login.log. Try again.")\e[0m"
        echo "$timestamp | FAILED  | Username: $username | Password: $password" >> "$log_file"
        ((attempts++))
        sleep 2
    fi
done

# After 3 failed attempts
clear
echo -e "\n\e[1;31m$(center_text "🚫 Maximum attempts reached. Access denied.")\e[0m"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "$timestamp | LOCKED OUT after 3 failed attempts" >> "$log_file"
read -p $'\nPress Enter to exit...'
exit 1
