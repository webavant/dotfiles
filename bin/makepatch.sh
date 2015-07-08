#! /bin/sh
pkgver=;pkgname=;eval `cat ../PKGBUILD | sed -e "s/\(pkgver=\S*\)/\1/p" -e "s/\(pkgname=\S*\)/\1/p" -n`
pkg="${pkgname%%-*}-$pkgver"; cd $pkg; echo "building patches for $pkg"; echo
echo "changing directory" `pwd`; echo
declare -a add
declare -a mod
mod=() add=()
for new in `find * -type f`; do
  orig="$pkg.orig/$new"
  eval diff -rq ../$orig $new >& /dev/null; ret=$?
  case "$ret" in
    0) ;;
    1) mod+=("$new") ;;
    2) add+=("$new") ;;
    *) echo Unhandled case for $new. Add a case to handle this problem. ;;
  esac
done
cd ..
echo "New Files:"; printf '%s\n' ${add[@]}; echo
echo "Modified Files:"; printf '%s\n' ${mod[@]}; echo
echo "changing directory" `pwd`; echo
for (( i=0; $i<${#add[@]}; i+=1 )); do
  echo diff -ruN $pkg.orig/${add[$i]} $pkg/${add[$i]} >> patch.txt
  diff -ruN $pkg.orig/${add[$i]} $pkg/${add[$i]} >> patch.txt
done
for (( i=0; $i<${#mod[@]}; i+=1 )); do
  echo diff -ruN $pkg.orig/${mod[$i]} $pkg/${mod[$i]} >> patch.txt
  diff -ruN $pkg.orig/${mod[$i]} $pkg/${mod[$i]} >> patch.txt
done

