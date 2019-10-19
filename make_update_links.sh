#!/usr/bin/env bash

repo_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

links_doc="$repo_dir/snippets/imports/cdn.sublime-snippet"
old_cdn_css="none"
old_cdn_jq="none"
old_cdn_popper="none"
old_cdn_bootstrap="none"

function replace () {
  sed -i -e "s\$1\$2\g" $3
}

# find what to replace
while IFS= read -r line; do
  if [[ "$line" == "<link rel"* ]]; then
    old_cdn_css="$line"
    echo "set old_cdn_css $old_cdn_css"
  fi
  if [[ "$line" == "<script src"* ]]; then
    if [[ "$old_cdn_jq" == "none" ]]; then
      old_cdn_jq="$line"
      echo "set old_cdn_jq $old_cdn_jq"
    elif [[ "$old_cdn_popper" == "none" ]]; then
      old_cdn_popper="$line"
      echo "set old_cdn_popper $old_cdn_popper"
    elif [[ "$old_cdn_bootstrap" == "none" ]]; then
      old_cdn_bootstrap="$line"
      echo "set old_cdn_bootstrap $old_cdn_bootstrap"
    fi
  fi
done < "$links_doc"

echo "new cdn_css:"
read cdn_css
echo "new cdn_jq:"
read cdn_jq
echo "new cdn_popper:"
read cdn_popper
echo "new cdn_bootstrap:"
read cdn_bootstrap

function process() {
  replace "$old_cdn_css"       "$cdn_css" $1
  replace "$old_cdn_jq"        "$cdn_jq" $1
  replace "$old_cdn_popper"    "$cdn_popper" $1
  replace "$old_cdn_bootstrap" "$cdn_bootstrap" $1
}

find "$repo_dir" -type f -not -path "$repo_dir/.git/*" -exec process {} \;
