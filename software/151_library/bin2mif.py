#/usr/bin/python
import codecs
import sys

HEADER =("WIDTH=32;\n"+
         "DEPTH=%d;\n"+
         "\n"+
         "ADDRESS_RADIX=HEX;\n"+
         "DATA_RADIX=HEX;\n"+
         "\n"+
         "CONTENT BEGIN\n");

f=sys.argv[1]
start = int(sys.argv[2],0)/4

words=[]
done=False;
depth=start
# with open(f) as ff:
with codecs.open(f,"r",encoding='utf-8', errors='ignore') as ff:
    while True:
        line=ff.read(4)
        k=0
        while len(line)<4:
            done=1
            line +="\0"

        for i in line[::-1]:
            k=k*256+ord(i)
        words.append(k)
        depth+=1

        if done:
            break



print (HEADER %depth)

print ("[0..%x] : 0;" % int(start-1))

for i,w in enumerate(words):
    print ("\t%x : %x;" %(int(i+start),int(w)))
print ("END ;")
