#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>

#include "quake_common.h"
#include "patches.h"
#include "common.h"

Cmd_CallVote_f_ptr Cmd_CallVote_f;

int patch_by_mask(pint offset, char* pattern, char* mask) {
  int res, page_size;

  page_size = sysconf(_SC_PAGESIZE);
  if (page_size == -1) return errno;
  res = mprotect((void*)(offset & ~(page_size-1)), page_size, PROT_READ | PROT_WRITE | PROT_EXEC);
  if (res) return errno;

  for (int i=0; mask[i]; i++) {
    if (mask[i] != 'X')
      continue;

    *(int8_t*)(offset+i) = pattern[i];
  }
  return 0;
}

void vote_clientkick_fix(void) {
  Cmd_CallVote_f = (Cmd_CallVote_f_ptr)PatternSearch((void*)((pint)qagame + 0xB000),
    0xB0000, PTRN_CMD_CALLVOTE_F, MASK_CMD_CALLVOTE_F);
  if (Cmd_CallVote_f == NULL) {
    DebugPrint("WARNING: Unable to find Cmd_CallVote_f. Skipping callvote-clientkick patch...\n");
    return;
  }

  patch_by_mask( ADDR_VOTE_CLIENTKICK_FIX, PTRN_VOTE_CLIENTKICK_FIX, MASK_VOTE_CLIENTKICK_FIX );
}

void framerate_fix(void* offset) {
	unsigned char str_125[] = "125";
	int page_size = sysconf(_SC_PAGESIZE);
	mprotect((void*)((uint64_t)(offset + 0x254878) & ~(page_size-1)), page_size, PROT_READ | PROT_WRITE);
	*(int64_t*)(offset + 0x254878) = (int64_t)str_125;
}

void patch_vm(void* moduleOffset) {
  vote_clientkick_fix();
  framerate_fix(moduleOffset);
}
