cd C:\Users\zhu\Desktop\github\tcmosten\tcmosten\static_ROOT\isys\js\
rm .\bundle.js 
rm .\bundle.js.map
cd C:\Users\zhu\Desktop\github\tcmosten\tcmosten\isys_js
npm run build
cd C:\Users\zhu\Desktop\github\tcmosten\tcmosten\isys_js\build
cp .\bundle.js C:\Users\zhu\Desktop\github\tcmosten\tcmosten\static_ROOT\isys\js\
cp .\bundle.js.map C:\Users\zhu\Desktop\github\tcmosten\tcmosten\static_ROOT\isys\js\
cd C:\Users\zhu\Desktop\github\tcmosten\tcmosten\
python .\manage.py runserver