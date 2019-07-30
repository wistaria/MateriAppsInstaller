#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. ${PREFIX_TOOL}/env.sh
LOG=${BUILD_DIR}/hphi-${HPHI_VERSION}-${HPHI_MA_REVISION}.log

PREFIX="${PREFIX_APPS}/hphi/hphi-${HPHI_VERSION}-${HPHI_MA_REVISION}"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

source /etc/profile.d/modules.sh
module unload cuda
module load cuda/8.0

module list

sh ${SCRIPT_DIR}/setup.sh
rm -rf $LOG
cd ${BUILD_DIR}/hphi-${HPHI_VERSION}
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check rm -rf build
check mkdir build
check cd build
check cmake \
  -DCUDA_CUDART_LIBRARY=$CUDA_HOME/lib64/libcudart.so \
  -DCONFIG=sekirei_acc \
  -DUSE_SCALAPACK=ON \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  ../
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
echo "cp -r samples ${PREFIX}" | tee -a $LOG
cp -r ../samples ${PREFIX}
echo "mkdir -p ${PREFIX}/doc" | tee -a $LOG
mkdir -p $PREFIX/doc | tee -a $LOG
echo "cp ../userguide_HPhi_ja.pdf ${PREFIX}/doc" | tee -a $LOG
cp ../userguide_HPhi_ja.pdf ${PREFIX}/doc/ | tee -a $LOG
echo "cp ../userguide_HPhi_en.pdf ${PREFIX}/doc" | tee -a $LOG
cp ../userguide_HPhi_en.pdf ${PREFIX}/doc/ | tee -a $LOG

cd $PREFIX/bin
for file in HPhi; do
  mv ${file} ${file}_nocount
  cat << EOF > ${file}
#!/bin/sh
/home/issp/materiapps/tool/bin/issp-ucount hphi
${PREFIX}/bin/${file}_nocount \$@
EOF
  chmod +x ${file}
done

finish_info | tee -a $LOG

cat << EOF > ${BUILD_DIR}/hphivars.sh
# hphi $(basename $0 .sh) ${HPHI_VERSION} ${HPHI_MA_REVISION} $(date +%Y%m%d-%H%M%S)
. ${PREFIX_TOOL}/env.sh
export HPHI_ROOT=$PREFIX
export PATH=\${HPHI_ROOT}/bin:\$PATH

source /etc/profile.d/modules.sh
module unload cuda
module load cuda/8.0
module list

EOF
HPHIVARS_SH=${PREFIX_APPS}/hphi/hphivars-${HPHI_VERSION}-${HPHI_MA_REVISION}.sh
rm -f $HPHIVARS_SH
cp -f ${BUILD_DIR}/hphivars.sh $HPHIVARS_SH
cp -f $LOG ${PREFIX_APPS}/hphi/
