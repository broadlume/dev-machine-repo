fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n$fmt\\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.dev-machine" ]; then
    zshrc="$HOME/.zshrc.dev-machine"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\\n" "$text" >> "$zshrc"
    else
      printf "\\n%s\\n" "$text" >> "$zshrc"
    fi
  fi
}

append_to_bash_profile() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  bash_profile="$HOME/.bashrc"

  if ! grep -Fqs "$text" "$bash_profile"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\\n" "$text" >> "$bash_profile"
    else
      printf "\\n%s\\n" "$text" >> "$bash_profile"
    fi
  fi
}

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
  fi
}

add_or_update_asdf_plugin() {
  local name="$1"
  local url="$2"

  asdf plugin-add "$name" "$url" || asdf plugin-update "$name"
}

install_asdf_language() {
  local language="$1"
  local version
  version="$(asdf list-all "$language" | grep -v "[a-z]" | tail -1)"

  if ! asdf list "$language" | grep -Fq "$version"; then
    asdf install "$language" "$version"
    asdf global "$language" "$version"
  fi
}

quietly_run() {
  if [[ "${VERBOSE:=0}" -eq 1 ]]; then
    "$@"
  else
    "$@" >> "/dev/null" 2>&1
  fi
}
