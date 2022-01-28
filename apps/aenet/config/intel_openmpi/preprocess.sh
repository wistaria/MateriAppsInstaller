cd lib
sed -i.orig 's/FC *= *gfortran -c/FC = ifort -c/' Makefile
