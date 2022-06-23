

f = open("byte.txt", "rb")
s = f.read()
key = ""
for i in range(298):
    key = key + "x"
key = list(key)



def function1(fnc, j, num):
    output = num
    if output % 2 == 0:
        output ^= 32
    else:
        output ^= 82
    key[j] = chr(output)

def function2(fnc, j, num):
    for k in [5, 4, 3, 2, 1]:
        num ^= 0x1693
        num = ((num << (16 - k)) | (num >> k)) & 65535
    gt = (num >> 8) & 255
    key[j] = chr(gt)
    gt = num & 255
    key[j + 1] = chr(gt)

count = 0
fnc = 0
j = 0
num = 0

for i in s:
    if count == 0:
        fnc = i 
    if count == 4:
        j = i 
    if count == 8:
        num = i
    if count == 9 and fnc == 2:
        num = i * 256 + num  
    count = count + 1
    if count == 12:
        if fnc == 1:
            function1(fnc, j, num)
        if fnc == 2:
            function2(fnc, j, num)
            break
        count = 0

key[0] = "T"
print(''.join(key))
# for i in range(len(key)):
#      print(str(i) + ":" + str(ord(key[i])))
