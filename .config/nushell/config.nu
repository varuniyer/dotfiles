$env.PATH = [
    "~/.local/bin",
    "/home/linuxbrew/.linuxbrew/bin",
] ++ $env.PATH
$env.EDITOR = "hx"
$env.VIRTUAL_ENV_DISABLE_PROMPT = true
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.config.show_banner = false
$env.config.edit_mode = 'vi'
$env.config.keybindings ++= [
  {
    name: vi_ctrl_j_escape
    modifier: control
    keycode: char_j
    mode: [vi_insert]
    event: { send: vichangemode, mode: normal }
  }
  {
    # Ctrl-A: accept the entire autosuggestion
    name: accept_hint
    modifier: control
    keycode: char_a
    mode: [vi_insert]
    event: { send: historyhintcomplete }
  }
  {
    # Ctrl-S: accept a single word of the autosuggestion
    name: accept_hint_word
    modifier: control
    keycode: char_s
    mode: [vi_insert]
    event: { send: historyhintwordcomplete }
  }
]

$env.config.history = {
    file_format: "sqlite" # Use SQLite for structured storage and sharing
    isolation: false      # Disable isolation to share history across all sessions
    sync_on_enter: true   # Write history to disk after each command
    max_size: 100000      # Maximum number of history entries
}

# --- Completions (external commands delegate to fish) ---
let fish_completer = {|spans|
    let results = fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
    # returning null (instead of an empty list) falls back to nushell's file completion
    if ($results | is-empty) { null } else { $results }
}
$env.config.completions.external = {
  enable: true
  completer: $fish_completer
}

# Override the built-in completion menu to drop the "| " marker.
# $env.config.menus is empty by default, and a menu named completion_menu
# replaces the internal one.
$env.config.menus ++= [{
    name: completion_menu
    only_buffer_difference: false
    marker: ""
    type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
    }
    style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
    }
}]

# --- Modules ---
source ~/.config/nushell/secrets.nu   # private env vars (edit with `hxs`)
source ~/.config/nushell/kube.nu      # kubectl wrappers (edit with `hxk`)

# --- Config editors (edit, then `exec nu` to reload) ---
alias reload = exec nu
def hxn [] { hx ~/.config/nushell/config.nu; exec nu }
def hxs [] { hx ~/.config/nushell/secrets.nu; exec nu }
def hxk [] { hx ~/.config/nushell/kube.nu; exec nu }
alias hxh = hx ~/.config/helix/config.toml
alias hxl = hx ~/.config/helix/languages.toml

# Auto-activate .venv on cd, and deactivate when leaving its tree.
# String-form hooks, so `overlay use` parses at cd time.
$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default []) ++ [
  {
    condition: {|before, after| ('.venv/bin/activate.nu' | path exists) and (($env.VIRTUAL_ENV? | default '') != ($after | path join '.venv')) }
    code: "overlay use .venv/bin/activate.nu"
  }
  {
    condition: {|before, after| (not ('.venv/bin/activate.nu' | path exists)) and ('activate' in (overlay list | get name)) and (not ($after | str starts-with ($env.VIRTUAL_ENV? | default '/__no_venv__/x' | path dirname))) }
    code: "overlay hide activate --keep-env [ PWD ]"
  }
]

# --- Git ---
def gpa [] { git push origin main; git push github main }

# --- Utils ---
alias apc = uvx --from git+https://github.com/acl-org/aclpubcheck aclpubcheck --paper_type long
alias kgr = chmod go-r ~/Documents/.config/kube/config
alias tf = tail -f

# --- Restic (repo from $env.RESTIC_REPOSITORY) ---
alias re = restic --verbose
# `r b|s|p|f [extra]` — backup / snapshots / prune / forget
def r [sub: string, extra?: string] {
  let base = (match $sub {
    "b" => ["backup", $env.HOME, "--exclude-file", $"($env.HOME)/.restic-excludes.txt"]
    "s" => ["snapshots"]
    "p" => ["prune"]
    "f" => ["forget"]
    _ => (error make {msg: $"r: unknown subcommand '($sub)' — use b, s, p, or f"})
  })
  let args = (if $extra != null { $base | append $extra } else { $base })
  restic --verbose ...$args
}

# --- Yank files to the tmux clipboard ---
def yi [] {
  $in | ^tmux load-buffer -
}

# Concat readable (utf-8) files with headers and yank them.
def yank-files [files: list<string>] {
  let texts = ($files | each {|f|
      let p = ($f | path expand)
      let raw = (open --raw $p | into binary)
      if (($raw | decode utf-8 | encode utf-8) == $raw) { $"=== File: ($p) ===\n($raw | decode utf-8)" }
    })
  $texts | str join "\n\n" | yi
  print $"Done! Yanked ($texts | length)/($files | length) files."
}
def yf [...files: string] { yank-files $files }
def yg [] { yank-files (git ls-files | lines | where {|f| ($f | path type) == "file"}) }

# Interactive regex replace across git-tracked files.
def rp [pattern: string, repl: string] {
  for path in (git ls-files | lines | where {|f| ($f | path type) == "file"}) {
    let raw = (open --raw $path | into binary)
    if (($raw | decode utf-8 | encode utf-8) != $raw) { continue }
    let orig = ($raw | decode utf-8 | split row "\n")
    # Prompt per matching line (sequential), returning the kept-or-replaced line.
    let new = ($orig | enumerate | each {|it|
      if ($it.item =~ $pattern) {
        print $"($path):($it.index + 1):($it.item)"
        if (input "Replace this line? (y/n) ") == "y" {
          $it.item | str replace --all --regex $pattern $repl
        } else { $it.item }
      } else { $it.item }
    })
    if $new != $orig { $new | str join "\n" | save --raw --force $path }
  }
}

# --- Upgrade everything ---
def u [] {
  brew upgrade -y
  brew autoremove
  brew cleanup --prune=all
  uv tool upgrade --all
}

# Auto-attach tmux on interactive launch outside tmux.
# Guarded by is-interactive, so `nu -c ...` scripts launch without it.
if $nu.is-interactive and ($env.TMUX? | is-empty) {
  exec tmux new -A -s main
}

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
