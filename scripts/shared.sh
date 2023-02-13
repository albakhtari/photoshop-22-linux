print_important() {
  echo -e "\n    ${yellow}[+]${reset} ${bold}$1${reset} \n"
}

yellow=$'\e[1;93m'
bold=$'\e[1m'
reset=$'\e[0m'
red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
white=$'\e[0m'
norm=$'\e[21m'