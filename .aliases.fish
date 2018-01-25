# Quickly change to dev directory
# alias dev="cd ~/dev"
set DEV $HOME/dev

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D."; and date; and time cat; and date'

# Weather
alias weather='curl wttr.in'

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update'

# IP addresses
alias exip="curl myipv4.millnert.se"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)  3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print}'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'wlp4s0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Enable/Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
alias spoton="sudo mdutil -a -i on"

# Lock the screen (when going AFK)
alias afk="gnome-screensaver-command -l"
# alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Speed Test
alias speedtest='echo "scale=2; (curl  --progress-bar -w "%{speed_download}" http://speedtest.wdc01.softlayer.com/downloads/test10.zip -o /dev/null) / 131072" | bc | xargs -I  {} echo  {} mbps'

alias pypiup='python setup.py sdist upload'


function tmux
    set TERM xterm-256color
    command tmux $argv
end

function workin
    cd "$DEV/$argv"
end
function workgo
    cd "$DEV/go/src/$argv"
end
function lsdev
    ls $DEV
end
function mkdev
    mkdir "$DEV/$argv"
    workin "$argv"
end

function gic
    echo "Making dev directory: $2";
    mkdev $2;
    cd "$DEV/$2";
    git init;
    git remote add origin $1;
    git fetch;
    git checkout -t origin/master
end

function ssh-remote-add
    cat ~/.ssh/id_rsa.pub | ssh "$argv" 'cat > .tmp.pubkey; mkdir -p ~/.ssh; touch ~/.ssh/authorized_keys; cat .tmp.pubkey >> ~/.ssh/authorized_keys; rm .tmp.pubkey' 
end

alias catmd="pandoc -f markdown -t plain"

function workdev  
    if [ -z "$argv[1]" ]
        echo "No session specified, starting in main dev"
        cd "$DEV"
        tmux new-session -d
    else
        if [ -d "$DEV/$argv[1]" ]
            echo "Starting in $argv[1]"
            cd "$DEV/$argv[1]"
            set sessionName (echo $argv[1] | rev | cut -d'/' -f 1 | rev | sed 's/\.//g')
            echo "Session name: $sessionName"
            tmux new-session -d -s "$sessionName"
        else
            echo "Well, that dir don't exist."
            return
        end
    end
    tmux rename-window "Dev"
    tmux new-window -n "Test"
    tmux split-window -v
    tmux select-window -n
    tmux -2 attach-session -d
end

alias vi=vim

function venv  
    set SDIR (pwd)
    while true
        if [ -d .venv ]
            echo "Sourcing env from (pwd)/.venv"
            source ".venv/bin/activate.fish"
            break
        end
        if [ -d virtualenv ]
            echo "Sourcing env from (pwd)/virtualenv"
            source "virtualenv/bin/activate.fish"
            break
        end
        cd ../
        if [ (PWD) = "/" ]
            echo "No virtual environments found."
            break
        end
    end
    cd $SDIR
    set -e SDIR
end

function synk  
    # I built this and then found out about vagrant rsync. I leave it here so
    # you can admire my understanding of regex and sed.
    #
    #
    # VAGRANT_SSH_CONFIG=$(vagrant ssh-config)
    # VAGRANT_IP=$(echo $VAGRANT_SSH_CONFIG | sed -rn 's/\s*HostName\s*([0-9.a-Z]+)/\1/p')
    # VAGRANT_PORT=$(echo $VAGRANT_SSH_CONFIG | sed -rn 's/\s*Port\s*([0-9]+)/\1/p')
    # FOLDERS=$(cat Vagrantfile | grep synced_folder | grep -v -e "#" | sed -r 's/\s*config.vm.synced_folder\s*"([~/a-Z0-9_-.]*)",\s*"([!/a-Z0-9_-.]*)".*/\1 \2/g')
    # while read -A entry; do
    #     echo "rsync -rvh ${entry[1]} vagrant@$VAGRANT_IP:${entry[2]} --delete --links --port=$VAGRANT_PORT"
    #     rsync -rvh ${entry[1]} vagrant@$VAGRANT_IP:${entry[2]} --delete --links -e "ssh -p $VAGRANT_PORT"
    # done <<< $FOLDERS
    vagrant rsync
end

alias t='$DEV/todo.txt-cli/todo.sh'

function genpw 
    if [ -z $1 ]
        len=32;
    else
        len=$1
    end
    
    date +%s | sha256sum | base64 | head -c $len; echo
end

function today
    echo "\
___________________________ _______  _______ 
\\__   __/\\__   __/\\__   __/(  ___  )(  ____ \\
   ) (      ) (      ) (   | (   ) || (    \\/
   | |      | |      | |   | |   | || (__    
   | |      | |      | |   | |   | ||  __)   
   | |      | |      | |   | |   | || (      
___) (___   | |   ___) (___| (___) || )      
\\_______/   )_(   \\_______/(_______)|/       
                                             
        \
    "
    dig +short txt istheinternetonfire.com
    echo ""
    echo ""
    echo ""
    echo "\
          _______  _______ _________          _______  _______ 
|\\     /|(  ____ \\(  ___  )\\__   __/|\\     /|(  ____ \\(  ____ )
| )   ( || (    \\/| (   ) |   ) (   | )   ( || (    \\/| (    )|
| | _ | || (__    | (___) |   | |   | (___) || (__    | (____)|
| |( )| ||  __)   |  ___  |   | |   |  ___  ||  __)   |     __)
| || || || (      | (   ) |   | |   | (   ) || (      | (\\ (   
| () () || (____/\\| )   ( |   | |   | )   ( || (____/\\| ) \\ \\__
(_______)(_______/|/     \\|   )_(   |/     \\|(_______/|/   \\__/
        \
    "
    weather
end
