#!/usr/bin/bash 

cd ~/Desktop/github/tcmosten/tcmosten/static_ROOT/isys/js/
rm -f bundle.js bundle.js.map
cd ~/Desktop/github/tcmosten/tcmosten/isys_js/linux
npm run build
cd ~/Desktop/github/tcmosten/tcmosten/isys_js/linux/build/
cp bundle.js bundle.js.map  ~/Desktop/github/tcmosten/tcmosten/static_ROOT/isys/js/
cd ~/Desktop/github/tcmosten/tcmosten/
python3 ./manage.py runserver 192.168.136.128:8000
