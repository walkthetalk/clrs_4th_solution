#!/usr/bin/env bash
set -e
SELF_PATH="`readlink -f $0`"
SELF_DIR="`dirname ${SELF_PATH}`"
MAIN_DIR="`readlink -f ${SELF_DIR}/`"
DST_DIR="${MAIN_DIR}"

echo "MAIN_DIR is ${MAIN_DIR}"

if [ $# -lt 2 ]; then
	echo "no eough parameter: chapter s01N s02N ... pN"
	exit 1
fi

CHAPTER_DIR="${DST_DIR}/$1"
echo "create chapter: ${CHAPTER_DIR}"
mkdir ${CHAPTER_DIR}
touch ${CHAPTER_DIR}/main.tex

# fill chapter header
CHAP_TEX="${CHAPTER_DIR}/main.tex"
echo "\startchapter[
  title={},
]
" >> ${CHAP_TEX}

SN=$(($# - 2))

SIDX=1
while [ $SIDX -le $SN ]; do
	shift
	SEC_ID="`printf "s%02d" $SIDX`"
	SEC_NAME="${CHAPTER_DIR}/${SEC_ID}"
	SEC_NUM="$1"
	echo "create section: ${SEC_NAME}, exercise number: ${SEC_NUM}"
	mkdir "${SEC_NAME}"
	for i in `seq 1 ${SEC_NUM}`; do
		touch "${SEC_NAME}/$i.tex"
	done
	SIDX=$(($SIDX + 1))

	echo "\sectioncomponents[
  title={},
]{${SEC_ID}}{${SEC_NUM}}" >> ${CHAP_TEX}
done

PRL_NAME="${CHAPTER_DIR}/p"
PRL_NUM="$2"
echo "create problem: ${PRL_NAME}, problem number: ${PRL_NUM}"
mkdir "${PRL_NAME}"
for i in `seq 1 ${PRL_NUM}`; do
	touch ${PRL_NAME}/$i.tex
done
echo "\sectioncomponents[
  title={Problems},
]{p}{${SEC_NUM}}" >> ${CHAP_TEX}

echo "
\stopchapter
" >> ${CHAP_TEX}


