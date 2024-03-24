
#SETTINGS FOR PATHS AND SOURCES

#-----------Edit--------------
alias edit_path='vim ~/Desktop/Github/Settings/Alias/.bash_aliases'
alias update_path='source ~/Desktop/Github/Settings/Alias/.bash_aliases'

alias edit_alias='vim ~/Desktop/Github/Settings/Alias/.alias'
alias update_alias='source ~/Desktop/Github/Settings/Alias/.alias'

alias edit_library='vim ~/Desktop/Github/Settings/Alias/.libraries'
alias update_library='source ~/Desktop/Github/Settings/Alias/.libraries'

#-----------PATHS-------------
source ~/Desktop/Github/Settings/Alias/.alias
source ~/Desktop/Github/Settings/Alias/.libraries

#----------Scripts------------
source ~/Desktop/Github/Settings/Scripts/MakefileRunner.sh

if [ -f ~/Desktop/Github/Settings/Alias/.alias ]; then
. ~/Desktop/Github/Settings/Alias/.alias
fi

#--------Francinette----------
alias francinette='~/francinette/tester.sh'
alias paco='~/francinette/tester.sh'

#--------Enviorment-----------
#export PATH=$PATH:/Users/ludvigrieff/.venv/bin
#alias env='source ~/Desktop/Enviorments/enviorments/base_env/bin/activate'
#I don't have the enviorment setup in this machine

#---------Homebrew------------
#export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# No Homebrew setup
#-----------Pipx--------------
#export PATH="$PATH:/Users/ludvigrieff/.local/bin"
# No Pipx installed
