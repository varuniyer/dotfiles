if status is-interactive
    if not set -q TMUX
        exec tmux new -A -s main
    end

    ## --- Environment Variables ---
    set -gx TERM tmux-256color
    set -gx EDITOR hx
    set -gx BREW_PREFIX /home/linuxbrew/.linuxbrew/
    set -gx TMPDIR ~/tmp

    set -gx LANG en_US.UTF-8
    set -gx LANGUAGE en_US:en
    set -gx LC_ALL en_US.UTF-8
    set -gx LIBTORCH_USE_PYTORCH 1

    set fish_greeting

    # --- Key Bindings ---
    fish_vi_key_bindings

    # Ctrl-A: accept the entire autosuggestion
    bind -M insert \cA accept-autosuggestion

    # Ctrl-S: accept a single word from the autosuggestion
    bind -M insert \cS forward-bigword

    # Remap Ctrl-J in insert mode to normal mode (requires a specific bind function in Fish)
    bind -M insert \cJ "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"

    # --- FZF Setup ---
    if test -d "$BREW_PREFIX/opt/fzf/shell"
        source "$BREW_PREFIX/opt/fzf/shell/key-bindings.fish" 2>/dev/null
    end
    fzf --fish | source

    # --- Aliases ---
    alias hxf="hx ~/.config/fish/config.fish; and source ~/.config/fish/config.fish"
    alias hxe="hx ~/.config/fish/env.fish; and source ~/.config/fish/env.fish"
    alias hxr="hx ~/.config/fish/functions/research_functions.fish; and source ~/.config/fish/config.fish"
    alias hxk="hx ~/.config/fish/functions/kube_functions.fish; and source ~/.config/fish/config.fish"
    alias hxh="hx ~/.config/helix/config.toml"
    alias hxl="hx ~/.config/helix/languages.toml"

    # Python / Venv
    alias sa="source .venv/bin/activate.fish"

    # Git
    alias gpa="git push origin main; git push github main"

    # Utils
    alias apc="uvx --from git+https://github.com/acl-org/aclpubcheck aclpubcheck --paper_type long"
    alias pi="uv pip"

    # Env var setting in alias requires 'env' command or block
    alias p="sa; PYTHONPATH=.:$PYTHONPATH python"

    # --- Restic ---
    alias re="restic --verbose -r $RESTIC_REPOSITORY"
    alias reb="re backup ~ --exclude-file ~/.restic-excludes.txt"
    alias res="re snapshots"
    alias rep="re prune"
    alias ref="re forget"

    alias kgr="chmod go-r ~/Documents/.config/kube/config"

    # --- Starship ---
    starship init fish | source
end

function u
    brew upgrade
    brew autoremove
    brew cleanup --prune=all
    uv tool upgrade --all
end

function yi
    if base64 --help >/dev/null 2>&1
        base64 -w0 | tr -d '\n' | awk '{printf "\033]52;c;%s\007",$0}'
    else
        base64 | tr -d '\n' | awk '{printf "\033]52;c;%s\007",$0}'
    end
end

source ~/.config/fish/functions/kube_functions.fish
source ~/.config/fish/env.fish

# Directory for your Python scripts
set -g PY_SCRIPT_DIR $HOME/.python_scripts

# --- Create wrapper functions so commands don't highlight red ---
function __pyshim_generate_wrappers --description 'Create wrappers for ~/.python_scripts/*.py'
    if not test -d $PY_SCRIPT_DIR
        return
    end

    for file in $PY_SCRIPT_DIR/*.py
        if test -f $file
            set name (basename $file .py)

            if not functions -q $name
                # The wrapper just calls the runner with the command name and args
                eval "
                    function $name --description 'Run $name.py from ~/.python_scripts'
                        __pyshim_run $name \$argv
                    end
                "
            end
        end
    end
end

function __pyshim_run
    set -l cmd $argv[1]
    set -l args $argv[2..-1]

    set -l original_dir (pwd)
    set -l script $PY_SCRIPT_DIR/$cmd.py

    if test -f $script
        cd $PY_SCRIPT_DIR
        command python $cmd.py $original_dir $args
        set -l cmd_status $status
        cd $original_dir
        return $cmd_status
    end

    # If somehow no script, show the standard message
    printf "%s: command not found\n" $cmd >&2
    return 127
end

# --- Optional fallback if a command is typed before wrappers exist ---
function fish_command_not_found --on-event fish_command_not_found
    set -l cmd $argv[1]
    set -l args $argv[2..-1]

    # If there's a matching script, run it through the same runner
    if test -f $PY_SCRIPT_DIR/$cmd.py
        __pyshim_run $cmd $args
        return $status
    end

    # Standard message
    printf "%s: command not found\n" $cmd >&2
    return 127
end

# Generate wrappers at shell startup (prevents red highlighting)
__pyshim_generate_wrappers

# Auto-refresh wrappers after each command so new scripts appear quickly.
function __pyshim_postexec --on-event fish_postexec
    __pyshim_generate_wrappers
end

function __auto_activate_venv --on-variable PWD
    # Avoid running on command substitutions (e.g. inside logic checks)
    status is-command-substitution; and return

    # 1. If a .venv exists here, activate it
    if test -f .venv/bin/activate.fish
        # Only source if it's not arguably already the active one
        if test "$VIRTUAL_ENV" != "$PWD/.venv"
            set -x WANDB_PROJECT (basename (pwd))
            source .venv/bin/activate.fish
        end

        # 2. If no .venv exists, checks if we need to deactivate an old one
    else if functions -q deactivate
        # Calculate the root of the currently active venv
        set -l venv_root (string replace "/.venv" "" "$VIRTUAL_ENV")

        # If the current path does NOT start with the venv root, deactivate
        if not string match -q "$venv_root*" "$PWD"
            deactivate
        end
    end
end

if status is-interactive
    __auto_activate_venv
end
