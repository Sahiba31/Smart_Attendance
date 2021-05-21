#!/usr/bin/python3

import cgi
import subprocess
import convertImage

print("content-type: text/html")
print()

mydata = cgi.FieldStorage()
name = mydata.getvalue("x")
reg = mydata.getvalue("y")

convertImage.convertImages(name, reg)
