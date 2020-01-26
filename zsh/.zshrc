# ZSH config


# Enable colours
autoload -U colors && colors

# Preload VCS
autoload -Uz vcs_info
precmd() { vcs_info }

# Format VCS info
zstyle ':vcs_info:git:*' formats '%b'

# Prompt
setopt PROMPT_SUBST
PROMPT='[%n@%M ${PWD/#$HOME/~}] vcs:${vcs_info_msg_0_} $ '

# History in cache directory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete, gives tab completion menu
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # include hidden files

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Vi bindings for complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Edit cmd with vim, with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Vi cursor change mode dependent
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] ||
	   [[ $1 = 'block' ]]; then
		echo -ne '\e[1 q'
	elif [[ ${KEYMAP} ==  viins ]] ||
             [[ ${KEYMAP} == '' ]] ||
	     [[ $1 = 'beam' ]]; then
		echo -ne '\e[5 q'
	fi
}
zle -N zle-keymap-select
zle-line-init(){
	zle -K viins  # instantiate `vi insert` as keymap 
	echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -n '\e[5 q'  # Use beam shape cursor on startup
preexec() { echo -ne '\e[5 q' ;}  # Use beam cursor for each new prompt

# LF to switch dirs, bind to ctrl-o
lfcd () {
	tmp="$(mktemp)"
	lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then 
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		[ -d "$dir" ] && [ "$dir" !="$(pwd)" ] && cd "$dir"
	fi
}
bindkey -s '^o' 'lfcd\n'

# Load aliases if exist
[ -f "$HOME/.aliasrc" ] && source "$HOME/.aliasrc"

# Syntax highlighting (should be last)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2> /dev/null

