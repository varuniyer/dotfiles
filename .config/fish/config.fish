if status is-interactive
    if not set -q TMUX
        exec tmux new -A -s main
    end

    ## --- Environment Variables ---
    set -gx TERM tmux-256color
    set -gx EDITOR hx
    set -gx BREW_PREFIX /home/linuxbrew/.linuxbrew/
    set -gx TMPDIR ~/tmp

    fish_add_path $BREW_PREFIX/bin ~/.local/bin

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

    # Python / Venv
    alias sa="source .venv/bin/activate.fish"

    # Git
    alias gpa="git push origin main; git push github main"

    # Utils
    alias apc="uvx --from git+https://github.com/acl-org/aclpubcheck aclpubcheck --paper_type long"
    alias pi="uv pip"

    # Env var setting in alias requires 'env' command or block
    alias p="sa; env PYTHONPATH=.:$PYTHONPATH python"

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
    llm install -U llm-deepseek llm-anthropic llm-moonshot
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

function fish_command_not_found --on-event fish_command_not_found
    # event args: $argv[1] is the command name, $argv[2..] are its args
    set -l cmd $argv[1]
    set -l args $argv[2..-1]

    # Look for matching Python scripts in ~/.python_scripts
    set -l dir ~/.python_scripts
    for p in (ls -1 $dir/*.py 2>/dev/null)
        if test (basename $p .py) = $cmd
            # Found exact match: run with python3
            uv run --project $dir $p $args
            return $status
        end
    end

    # fallback: original message
    printf "%s: command not found\n" $cmd >&2
    return 127
end

function __auto_activate_venv --on-variable PWD
    # Avoid running on command substitutions (e.g. inside logic checks)
    status is-command-substitution; and return

    # 1. If a .venv exists here, activate it
    if test -f .venv/bin/activate.fish
        # Only source if it's not arguably already the active one
        if test "$VIRTUAL_ENV" != "$PWD/.venv"
            source .venv/bin/activate.fish
        end

        # 2. If no .venv exists, checks if we need to deactivate an old one
    else if functions -q deactivate
        # We only deactivate if we have effectively LEFT the project folder.
        # This handles the case where you are in a subdirectory (e.g., src/)
        # which doesn't have the .venv file itself but should keep the venv active.

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
