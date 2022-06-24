f = open("byte.txt", "rb")
s = f.read()
f = open("hexa", "rb")
g = f.read()
key = ""
for i in range(298):
    key = key + "x"
key = list(key)



def function1(j, num):
    output = num
    if output % 2 == 0:
        output ^= 32
    else:
        output ^= 82
    key[j] = chr(output)

def function2(j, num):
    for k in [5, 4, 3, 2, 1]:
        num ^= 0x1693
        num = ((num << (16 - k)) | (num >> k)) & 0xffff
    gt = (num >> 8) & 0xff
    key[j] = chr(gt)
    gt = num & 0xff
    key[j + 1] = chr(gt)


def function3(j, num):
    v3 = "ABDCEHGFIJKLUNOPYRTSMVWXQZajcdefohibkmlngpqrstuv4xzy8123w56709+0"
    a2 = num & 0xff
    a3 = (num >> 8) & 0xff
    a4 = (num >> 16) & 0xff
    a5 = (num >> 24) & 0xff
    for v14 in range(32, 127):
        if ord(v3[(v14 & 0xfc) >> 2]) == a2:   
            for v15 in range(32, 127):
                if ord(v3[((v15 & 0xf0) >> 4) + 16 * (v14 & 3)]) == a3:
                    for v16 in range(32, 127):
                        if ord(v3[((v16 & 0xC0) >> 6) + 4 * (v15 & 0xf)]) == a4 and ord(v3[v16 & 0x3f]) == a5:
                            key[j] = chr(v14)
                            key[j + 1] = chr(v15)
                            key[j + 2] = chr(v16)
                            return

def function4(j, num):
    a1 = []
    for i in g:
        a1.append(i)
        print(i)
    v7 = 0
    v6 = 0
    v5 = 0
    v4 = 4
    while v5 < v4:
        v7 = (v7 + 1) % 256
        v6 = (v6 + a1[v7 * 2]) % 256
        v8 = a1[v7 * 2]
        a1[v7 * 2] = a1[v6 * 2]
        a1[v6 * 2] = v8
        


count = 0
fnc = 0
j = 0
num = 0
c1 = 0
c2 = 0
c3 = 0
c4 = 0

for i in s:
    if i == 32:
        i = 0
    if count == 0:
        fnc = i 
    if count == 4:
        j = i 
    if count == 5:
        j = (i << 8) + j
    if count == 8:
        num = i
    if count == 9 and fnc >= 2:
        num = (i << 8) + num  
    if count == 10 and fnc >= 3:
        num = (i << 16) + num
    if count == 11 and fnc >= 3:
        num = (i << 24) + num
    count = count + 1
    if count == 12:
        if fnc == 1:
            function1(j, num)
            c1+=1
        if fnc == 2:
            function2(j, num)
            c2+=1
        if fnc == 3:
            function3(j, num)
            c3+=1
        if fnc == 4:
            c4+=1
        count = 0

print(''.join(key))
# for i in range(len(key)):
#      print(str(i) + ":" + str(ord(key[i])))
print(c1)
print(c2)
print(c3)
print(c4)