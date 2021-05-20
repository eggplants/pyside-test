#!/bin/bash -ux

function main(){

command -v pyinstaller > /dev/null || {
  echo "require: pyinstaller" >&2
  exit 1
}

function usage(){
  echo "$(basename $0) <filename>"
}

[ $# -ne 1 ] && {
  usage >&2
  exit 1
}
readonly main_py="$1"
[ -f "$main_py" ] || {
  echo "file '$main_py' is not file or not found" >&2
  exit 1
}

echo -n "console?([y]/n): "
read -r i
if [[ "$i" =~ ^y?$ ]]
then
  pyinstaller "$main_py" -F
else
  pyinstaller "$main_py" -F -w
fi
}

main "$@"
exit $?
