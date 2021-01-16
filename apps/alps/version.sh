ALPS_VERSION="20210116-r7861"
ALPS_MA_REVISION=1
ALPS_URL=https://alps.comp-phys.org/svn/alps1/trunk/alps

__NAME__=alps
__VERSION__=${ALPS_VERSION}
__VERSION_REVISION__=$(echo ${ALPS_VERSION} | cut -dr -f2)
__URL__=${ALPS_URL}
__MA_REVISION__=${ALPS_MA_REVISION}
