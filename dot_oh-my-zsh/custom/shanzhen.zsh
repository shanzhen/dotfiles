# ---- Combined: plugins + fast completion + host on LEFT ----

# --- Plugins loaded post-theme (no .zshrc edits needed) ---
# Try to source; ignore if missing (keeps startup robust)
ZC="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ZOH="${ZSH:-$HOME/.oh-my-zsh}"

# autosuggestions (fish-like inline)
[[ -r "$ZC/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
  && source "$ZC/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# syntax highlighting
[[ -r "$ZC/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
  && source "$ZC/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# fzf-tab (fuzzy <TAB>)
[[ -r "$ZC/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] \
  && source "$ZC/plugins/fzf-tab/fzf-tab.plugin.zsh"
# history substring search (↑/↓)
[[ -r "$ZOH/plugins/history-substring-search/history-substring-search.plugin.zsh" ]] \
  && source "$ZOH/plugins/history-substring-search/history-substring-search.plugin.zsh"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- Fast, cached completion ---
zmodload zsh/complist
: ${XDG_CACHE_HOME:="$HOME/.cache"}
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump-$ZSH_VERSION"
mkdir -p "${ZSH_COMPDUMP:h}"

autoload -Uz compinit
# -C: trust cached compdump; -d: set path
compinit -C -d "$ZSH_COMPDUMP"

# QoL completion styles
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu yes select

# Fish-like tab completion - complete on empty prefix
zstyle ':completion:*' insert-tab false
setopt AUTO_LIST           # Automatically list choices on ambiguous completion
setopt AUTO_MENU           # Use menu completion after second tab
unsetopt LIST_BEEP         # Don't beep on ambiguous completions

# Ensure Tab invokes completion
bindkey '^I' expand-or-complete

# fzf-tab tweaks
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-space:accept' 'tab:down' 'btab:up'

# --- Host on LEFT (prefix), resilient to theme resets ---
autoload -U colors && colors
_HP_PREFIX="%{$fg[cyan]%}%m%{$reset_color%} "

_hp_left() {
  local base="$PROMPT"
  [[ "$base" == $_HP_PREFIX* ]] && base="${base#$_HP_PREFIX}"
  PROMPT="${_HP_PREFIX}${base}"
}

typeset -ga precmd_functions
(( ${precmd_functions[(I)_hp_left]} == 0 )) && precmd_functions+=(_hp_left)

