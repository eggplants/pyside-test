#!/bin/bash -eux

function _setup_wine(){
  sudo dpkg --add-architecture i386 &&
  wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add - &&
  sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' -y &&
  sudo add-apt-repository ppa:cybermax-dexter/sdl2-backport -y &&
  sudo apt update -y &&
  sudo apt install --install-recommends winehq-stable -y &&
  wget https://www.python.org/ftp/python/3.9.5/python-3.9.5-amd64.exe &&
  wine ./python-* /passive &&
  wine py -m pip install --upgrade pip &&
  wine py -m pip install pyinstaller
}

function _check_wine(){
  command -v wine || {
    echo "setup wine with pyinstaller?([y]/n)"
    read -r i
    if [[ "$i" =~ ^y?$ ]]
    then
      _setup_wine || {
  	    echo "failed!" >&2
  	    exit 1
      }
    else
      echo "exit." >&2
  	  exit 1
    fi
  }
}

function _usage(){
  echo "$(basename $0) <filename>"
}

function main(){
  _check_wine
  [ $# -ne 1 ] && {
    _usage >&2
    exit 1
  }
  readonly main_py="$1"
  [ -f "$main_py" ] || {
    echo "file '$main_py' is not file or not found" >&2
    exit 1
  }

  readonly pyinstaller_exe_path='C:\users\root\Local Settings\Application Data\Programs\Python\Python39\Scripts\pyinstaller.exe'
  echo -n 'console?([y]/n): '
  read -r i
  if [[ "$i" =~ ^y?$ ]]
  then
    wine "$pyinstaller_exe_path" "$main_py" -F
  else
    wine "$pyinstaller_exe_path" "$main_py" -F -w
  fi
}

main "$@"
exit $?
