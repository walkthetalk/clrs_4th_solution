#/usr/bin/env sh

FNAME="`readlink -f $1`"
INC_DIR="$2"

FINAL_STR="${FNAME}"

function process_file {
	for i in `cat "$1" | grep "^input "|sed 's/^input \([^;]*\);$/\1/'`; do
		TMP_F="${INC_DIR}/${i}.mp"
		if [ -f "${TMP_F}" ]; then
			FINAL_STR="$FINAL_STR ${TMP_F}"
			process_file "${TMP_F}"
		fi
	done
}

cd "`dirname "${INC_DIR}"`"
process_file "${FNAME}"

echo $FINAL_STR
