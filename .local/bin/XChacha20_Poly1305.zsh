#!/bin/zsh
# Created by @oivas000

eco() { XChacha20_Poly1305 };
dco() { XChacha20_Poly1305 -d };
ec0x() { echo -n "Enter your password: "; read -rs password; echo ""; for f in "${@}"; do xz -zc0T0 $f | XChacha20_Poly1305 - $f.xz.ec $password; done };
ec9x() { echo -n "Enter your password: "; read -rs password; echo ""; for f in "${@}"; do xz -zec9T0 $f | XChacha20_Poly1305 - $f.xz.ec $password; done };
ec0z() { echo -n "Enter your password: "; read -rs password; echo ""; for f in "${@}"; do 7z a -bb -y -mx=0 -- $f.7z $f; XChacha20_Poly1305 $f.7z $f.7z.ec $password; rm -r $f.7z; done };
ec9z() { echo -n "Enter your password: "; read -rs password; echo ""; for f in "${@}"; do 7z a -bb -y -m0=LZMA2 -mx=9 -md=64M -- $f.7z $f; XChacha20_Poly1305 $f.7z $f.7z.ec $password; rm -r $f.7z; done };
dcz() { echo -n "Enter your password: "; read -rs password; echo ""; for f in "${@}"; do XChacha20_Poly1305 -d $f ${f%.ec} $password; 7z x -bb -y -- ${f%.ec}; rm -r ${f%.ec}; done };
dcx() { echo -n "Enter your password: "; read -rs password; echo ""; for f in "${@}"; do XChacha20_Poly1305 -d $f - $password | xz -dcT0 > ${f%.xz.ec}; done };

$1 ${@:2}
