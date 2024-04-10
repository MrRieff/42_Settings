# 42_Settings

This repository was made with the idea of making it easier to switch between machines without to much hassle and still be able to use some personalized scripts that I made for workflow sake, and some other small conviniences.

---

Please add this to you alias file if you wish to separate into different files:

source ~/.bash_aliases (Or name of your new alias file after the '/')

if [ -f ~/.bash_aliases (Or name of your new alias file after the '/')]; then
. ~/.bash_aliases (Or name of your new alias file after the '/')
fi

---

PS: This will not have any further support, altough it might have some updates
Author: Ludvig Johannes Rieff

In case of being in a mac os here is what you'll need to do in case of the code command doesn't work:

Step 1: Go to vscode, and press cmd + Shift + P
Step 2: Write the word 'code' and press Enter

If that gives you a permission error:
Step 3: Enter this on your terminal

sudo ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/

Step 4: Enter this on your terminal

sudo chmod o+w /usr/local/bin

Finished, everything should work after a terminal restart