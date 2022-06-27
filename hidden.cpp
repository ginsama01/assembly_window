#include <bits/stdc++.h>
#include <windows.h>
#include <windef.h>
#include <stdio.h>
#include <stdlib.h>


int main()
{
  unsigned int v3; // kr00_4
  HANDLE v4; // eax
  void *v5; // ebx
  HANDLE v7; // eax
  void *v8; // esi
  char *v9; // ebx
  unsigned int v10; // eax
  unsigned int v11; // esi
  char v12; // cl
  const void *v13; // edi
  DWORD v14; // edx
  unsigned int v15; // ebx
  int v16; // ecx
  char *v17; // eax
  int v18; // edx
  int v19; // eax
  int v20; // edi
  int v21; // edx
  char v22; // al
  HANDLE v23; // [esp+4h] [ebp-128h]
  HANDLE hObject; // [esp+8h] [ebp-124h]
  int v25; // [esp+Ch] [ebp-120h]
  char *v26; // [esp+10h] [ebp-11Ch]
  int v27; // [esp+14h] [ebp-118h]
  char *lpBaseAddress; // [esp+18h] [ebp-114h]
  char *v29; // [esp+1Ch] [ebp-110h]
  DWORD v30; // [esp+20h] [ebp-10Ch]
  int v31; // [esp+20h] [ebp-10Ch]
  unsigned int v32; // [esp+24h] [ebp-108h]
  int v33; // [esp+24h] [ebp-108h]
  char Dest[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"; // [esp+28h] [ebp-104h] BYREF
  char bmpFile[] = "C:\\Users\\sv_huynq\\Desktop\\assembly\\inside-the-mind-of-a-hacker-memory.bmp";
  {
    v3 = strlen(Dest);
    printf("%ld\n", v3);
    if ( v3 )
    {
      v4 = CreateFileW(L"C:\\Users\\sv_huynq\\Desktop\\assembly\\inside-the-mind-of-a-hacker-memory.bmp", 0xC0000000, 1u, 0, 3u, 0x80u, 0);
      v5 = v4;
      v23 = v4;
      if ( v4 != (HANDLE)-1 )
      {
        v30 = GetFileSize(v4, 0);
        if ( v30 == -1 || (v7 = CreateFileMappingW(v5, 0, 4u, 0, 0, 0), v8 = v7, (hObject = v7) == 0) )
        {
          CloseHandle(v5);
          return 0;
        }
        lpBaseAddress = (char *)MapViewOfFile(v7, 6u, 0, 0, 0);
        if ( lpBaseAddress )
        {
          v9 = (char*)malloc(8 * v3);
          v10 = 0;
          v29 = v9;
          v11 = 0;
          v32 = 0;
          do
          {
            v12 = Dest[v10];
            v9[v11] = v12 & 1;
            v9[v11 + 1] = (v12 >> 1) & 1;
            v9[v11 + 2] = (v12 >> 2) & 1;
            v9[v11 + 3] = (v12 >> 3) & 1;
            v9[v11 + 4] = (v12 >> 4) & 1;
            v9[v11 + 5] = (v12 >> 5) & 1;
            v9[v11 + 6] = (v12 >> 6) & 1;
            v10 = v32 + 1;
            v9[v11 + 7] = (v12 >> 7) & 1;
            v11 += 8;
            v32 = v10;
          }
          while ( v10 < v3 );
          v13 = lpBaseAddress;
          if ( *(int16_t *)lpBaseAddress == 19778 && v30 >= *(int *)(lpBaseAddress + 2) )
          {
            v14 = *(int *)(lpBaseAddress + 10);
            if ( v14 < v30 && v11 < *(int *)(lpBaseAddress + 34) )
            {
              v15 = 0;
              v16 = *(int *)(lpBaseAddress + 18);
              v27 = *(int *)(lpBaseAddress + 22);
              v17 = &lpBaseAddress[v14];
              v18 = 0;
              v25 = v16;
              v26 = v17;
              *((int16_t *)lpBaseAddress + 3) = v11;
              v33 = 0;
              if ( v11 )
              {
                v19 = 0;
                v31 = 0;
                do
                {
                  if ( v18 >= v27 )
                    break;
                  v20 = 0;
                  if ( v15 < v11 )
                  {
                    do
                    {
                      if ( v20 >= v16 )
                        break;
                      v21 = v19 + v20++;
                      v22 = v29[v15++];
                      //v26[2 * v21 + v21] = v22; 
                      printf("%d ", v26[2 * v21 + v21]);
                      v19 = v31;
                      v16 = v25;
                    }
                    while ( v15 < v11 );
                    v18 = v33;
                  }
                  ++v18;
                  v19 += 3 * v16;
                  v33 = v18;
                  v31 = v19;
                }
                while ( v15 < v11 );
                v13 = lpBaseAddress;
              }
              v9 = v29;
            }
          }
          free(v9);
          UnmapViewOfFile(v13);
          CloseHandle(hObject);
          CloseHandle(v23);
        }
        else
        {
          CloseHandle(v8);
          CloseHandle(v5);
        }
      }
    }
  }
  return 0;
}
