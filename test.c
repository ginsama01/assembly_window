#include <stdint.h>
#include <stdio.h>
#include <string.h>

struct Elf64Hdr {
  uint8_t     e_ident[16];         /* Magic number and other info */
  uint16_t    e_type;              /* Object file type */
  uint16_t    e_machine;           /* Architecture */
  uint32_t    e_version;           /* Object file version */
  uint64_t    e_entry;             /* Entry point virtual address */
  uint64_t    e_phoff;             /* Program header table file offset */
  uint64_t    e_shoff;             /* Section header table file offset */
  uint32_t    e_flags;             /* Processor-specific flags */
  uint16_t    e_ehsize;            /* ELF header size in bytes */
  uint16_t    e_phentsize;         /* Program header table entry size */
  uint16_t    e_phnum;             /* Program header table entry count */
  uint16_t    e_shentsize;         /* Section header table entry size */
  uint16_t    e_shnum;             /* Section header table entry count */
  uint16_t    e_shstrndx;          /* Section header string table index */
};

void read_elf_header(const char* elfFile, const char* outputFile) {
  struct Elf64Hdr header;
  // printf("%s\n%s", elfFile, outputFile);
  FILE* file = fopen(elfFile, "rb");
  if(file) {
    // read the header
    // check so its really an elf file
    for (int i = 0; i <= 15; ++i) {
       printf("%d ", header.e_ident[i]);
    }
   //  if(header.e_type == 0x7f &&
   //     header.e_ident[1] == 'E' &&
   //     header.e_ident[2] == 'L' &&
   //     header.e_ident[3] == 'F') {

   //     // write the header to the output file
   //     FILE* fout = fopen(outputFile, "wb");
   //     if(fout) {
   //       fwrite(&header, 1, sizeof(header), fout);
   //       fclose(fout);
   //     }
   //   }

    // finally close the file
    fclose(file);
  }
}

int main()
{
   char inp_file[50];
   scanf("%s", inp_file);
   char out_file[50];
   scanf("%s", out_file);
   read_elf_header(inp_file, out_file);
}