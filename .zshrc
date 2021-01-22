#color
autoload -Uz colors
colors

# git branch method
function prompt-branch {
  local branch_name st branch_status
  if [ ! -e  ".git" ]; then
    return
  fi

  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    branch_status="%K{green} "
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    branch_status="%K{red} ?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    branch_status="%K{red} +"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    branch_status="%K{yellow} !"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    echo "%K{red}!(no branch)"
    return
  else
    branch_status="%K{blue} "
  fi
  echo "${branch_status} Git $branch_name"
}

PROMPT='%B%K{057} %c %n %k%K{008} %D{%T} %k'`prompt-branch`' %k%F{057} >>> %b%f '

# auto start tmux
if [[ ! -n $TMUX && $- == *l* ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | peco | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :  # Start terminal normally
  fi
fi

# Learge and small
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# completion
zstyle ':completion:*:default' menu select=1


