#include <stdio.h>
#include <gsl/gsl_version.h>

int main(int argc, char **argv)
{
  printf("%s\n", gsl_version);
  return 0;
}
