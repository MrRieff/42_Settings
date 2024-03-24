
#SETTINGS FOR PATHS AND SOURCES

#-----------Edit--------------
alias edit_path='vim ~/.zshrc'
alias update_path='source ~/.zshrc'

alias edit_alias='vim ~/.alias'
alias update_alias='source ~/.alias'

#----------Scripts------------
source ~/Desktop/42/Settings/Scripts/MakefileRunner.sh
source ~/Desktop/42/Settings/Alias/.alias

if [ -f ~/.alias ]; then
. ~/.alias
fi

#--------Francinette----------
#alias francinette= (path)

#--------Enviorment-----------
export PATH=$PATH:/Users/ludvigrieff/.venv/bin
alias env='source ~/Desktop/Enviorments/enviorments/base_env/bin/activate'

#---------Homebrew------------
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

#-----------Pipx--------------
export PATH="$PATH:/Users/ludvigrieff/.local/bin"
