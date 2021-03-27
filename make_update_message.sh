#!/usr/bin/env bash

if ! [ $# -eq 1 ]; then
  echo "Usage: ./make_update_message.sh <major.minor.patch>"
  exit 1
fi

if ! [[ $1 =~ ^[0-9]\.[0-9]\.[0-9]$ ]]; then
  echo "Semantic version must be <major.minor.patch>"
  exit 1
fi

repo_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cat > $repo_dir/messages/$1.txt << EOF

============================================================
Bootstrap 4 Snippets - Has been updated !! -> v$1
============================================================
        Bootstrap v$1 has been released !!
============================================================
------------------------------------------------------------

------------------------------------------------------------
Documentation, examples & issue filing can be found here:
https://github.com/alexanderankin/sublime-bootstrap4
EOF

sed -i "/This is version/s/.*/This is version: $1/" $repo_dir/messages/install.txt
