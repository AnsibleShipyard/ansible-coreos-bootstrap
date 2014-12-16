#/bin/bash

set -e

if [ -e $HOME/.bootstrapped ]; then
  exit 0
fi

PYPY_VERSION=2.4.0

if [ -e $HOME/pypy ]; then
  rm -R $HOME/pypy*
fi

if [ -e pypy-$PYPY_VERSION-linux64.tar.bz2 ]; then
  rm pypy-$PYPY_VERSION-linux64.tar.bz2
fi;

if [ -e pypy-$PYPY_VERSION-linux64 ]; then
  rm -R pypy-$PYPY_VERSION-linux64
fi;

wget https://bitbucket.org/pypy/pypy/downloads/pypy-$PYPY_VERSION-linux64.tar.bz2
tar -xf pypy-$PYPY_VERSION-linux64.tar.bz2
ln -sf pypy-$PYPY_VERSION-linux64 pypy

## library fixup
if [ ! -e $HOME/pypy/lib ]; then 
  mkdir -p $HOME/pypy/lib
fi;

if [ ! -e /lib64/libncurses.so.5.9 ]; then
  echo "Could not find libncurses.so.5.9"
  exit 0
fi;

ln -sf /lib64/libncurses.so.5.9 $HOME/pypy/lib/libtinfo.so.5

mkdir -p $HOME/bin

cat > $HOME/bin/python <<EOF
#!/bin/bash
LD_LIBRARY_PATH=$HOME/pypy/lib:$LD_LIBRARY_PATH $HOME/pypy/bin/pypy "\$@"
EOF

chmod +x $HOME/bin/python
$HOME/bin/python --version

touch $HOME/.bootstrapped

# cleanup
rm *.bz2

