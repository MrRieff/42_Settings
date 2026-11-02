# Welcome banner
welcome_banner() {
  local apple=~/.config/welcome/apple.txt
  local text=~/.config/welcome/text.txt
  local pad=$(( ($(wc -l < "$apple") - $(wc -l < "$text")) / 2 + 2 ))
  printf '\e[97m'
  paste -d' ' \
    <(awk '{printf "%-42s\n", $0}' "$apple") \
    <( { for ((i=0; i<pad; i++)); do echo; done; cat "$text"; } )
  printf '\e[0m\n'
}
welcome_banner
