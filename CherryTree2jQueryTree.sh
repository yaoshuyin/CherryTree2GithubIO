#!/bin/bash
if [ $# -eq 0 ]
then
    echo Usage: %0 tree_src.html
    exit 1
fi

inputf="$1"
output="/tmp/aaaaaa.html"

if [ -f "$1" ]
then
   sed -E "s/<img[^>]+>//g" "$inputf" | sed -e  "s/&nbsp;/  /g" | sed -e "s/<tr>/\n<tr>/g" | sed -E "s/<tr><td>//g" | sed -e "s~</td></tr>~~g" | sed -e "s~</table>~\n~g"> $output
fi

cat >ChreeTreeNav.html <<__EOF__
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Navigation</title>
<link rel="stylesheet" type="text/css" href="./js/jQuery/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="./js/jQuery/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="./css/index.css">
<script type="text/javascript" src="./js/jQuery/jquery.min.js"></script>
<script type="text/javascript" src="./js/jQuery/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="./js/index.js"></script>
</head>
<body>

<div id="wrapper">
  <div id="header"></div>
 
  <div id="main" class="clearfix">
      <div id="left">

__EOF__

cat >/tmp/a.py <<__EOF__
#!/usr/bin/python
#-*- encoding: utf-8 -*-
import io
import re
import os
import sys


if len(sys.argv) == 2:
    srcfile=sys.argv[1]
else:
    print "Usage: ", sys.argv[0], " a.html"
    os._exit(1)


f=open(srcfile,'r')


print "<ul class=\\"easyui-tree\\" data-options=\\"animate:true,lines:true\\">"
nodes=0
cengshu=0
tmp=0
for line in f:
    rec=re.compile(r">([0-9\.]+) ")
    result=rec.findall(line)
    for i in result:
       cengshu=i.count(".")
       if cengshu != tmp and cengshu>tmp:
           tmp=cengshu
           #if nodes>0:
           #    print "   " * tmp , "</span>"
           print "   " * tmp , "<ul>"
       elif cengshu != tmp and cengshu<tmp:
           if nodes>0:
               print "   " * (tmp+1) , "</li>"
           print "   " * tmp , "</ul>" * (tmp-cengshu)
           tmp=cengshu
       else:
           if nodes>0:
               print "   " * (tmp+1) , "</li>"

       print "   " * (tmp+1) , "<li><span>",line.strip(),"</span>"
       nodes+=1

f.close()


print '''
        </ul>
      </div>

   	  <div id="right-content" name="right-content"></div>
    </div>
  
   <div id="footer"></div>
</div>
</body>
</html>
'''

__EOF__

chmod +x /tmp/a.py
/tmp/a.py $output >> ChreeTreeNav.html

rm -f $output

sed -i -E "s/(<td valign=\"top\" align=cons.TAG_PROP_LEFT width=20%>).*(<td valign=\"top\" align=cons.TAG_PROP_LEFT width=80%>)/<td>/g"  ../yaoshuyin.github.io/*.html 

sed -i -e "s/<\!doctype html><html><head>.*content=\"CherryTree\"><\/head><body><table width=\"100%\"><tr><td>//g" ../yaoshuyin.github.io/*.html
sed -i -e "s/<\/td><\/tr><\/table><\/body><\/html>//g" ../yaoshuyin.github.io/*.html


cp -pfr ChreeTreeNav.html ../yaoshuyin.github.io/index.html
cp -pfr js css ../yaoshuyin.github.io/
