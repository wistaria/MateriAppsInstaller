#include <stdio.h>
#include <zlib.h>

int main(int argc, char **argv)
{
  zlibVersion();
  printf("%s\n", ZLIB_VERSION);
  return 0;
}
