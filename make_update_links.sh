#!/usr/bin/env bash

repo_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

links_doc="$repo_dir/snippets/imports/cdn.sublime-snippet"
old_cdn_css="none"
old_cdn_jq="none"
old_cdn_popper="none"
old_cdn_bs="none"

function replace () {
  sed -i -e "s\\$1\\$2\\g" $3
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
    elif [[ "$old_cdn_bs" == "none" ]]; then
      old_cdn_bs="$line"
      echo "set old_cdn_bs $old_cdn_bs"
    fi
  fi
done < "$links_doc"

if [[ -f "$repo_dir/newlinks" ]]; then
  source "$repo_dir/newlinks"
  echo "found new values"
fi

# prompt new values
if [ -z "$cdn_css" ];    then echo "new cdn_css:";    read cdn_css; fi;
if [ -z "$cdn_jq" ];     then echo "new cdn_jq:";     read cdn_jq; fi;
if [ -z "$cdn_popper" ]; then echo "new cdn_popper:"; read cdn_popper; fi;
if [ -z "$cdn_bs" ];     then echo "new cdn_bs:";     read cdn_bs; fi;

function process() {
  replace "$old_cdn_css"       "$cdn_css" $1
  replace "$old_cdn_jq"        "$cdn_jq" $1
  replace "$old_cdn_popper"    "$cdn_popper" $1
  replace "$old_cdn_bs" "$cdn_bs" $1
}

# file by file in snippets, do replacements
while read filename; do
  echo "processing $filename"
  process "${filename}"
done < <(find "$repo_dir/snippets" -type f)
