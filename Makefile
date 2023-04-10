pdf_name := CLRS_solution
doc_env  := book_cht
dir_main := $(shell dirname $(shell readlink -fe $(lastword ${MAKEFILE_LIST})))

include $(dir_main)/scripts/common.mk

define clean_misc =
	rm -f $(tex_name).aux $(tex_name).bbl $(tex_name).blg $(tex_name).log $(pdf_name).tuc
endef

dir_fig:=${dir_main}/fig
fig_srcs:=$(shell cd ${dir_fig}; find . -type f -name "*.mp" | cut -d '/' -f 2 | grep "^[e|p][0-9]")
fig_dsts:=$(patsubst %.mp,$(output_dir)/%-1.pdf,$(fig_srcs))

.PHONY: figs
figs: ${fig_dsts}

${main_object}: ${fig_dsts}

fig_deps:=$(patsubst %.mp,${output_dir}/%.mp.d,$(fig_srcs))
include ${fig_deps}
${output_dir}/%.mp.d:
	@set -e; \
	TMP_DEPS="`./gen_deps_for_mp.sh ${dir_fig}/$*.mp`"; \
	echo [gen dep] $*; \
	echo -e "DEP_$*.mp:=$${TMP_DEPS}\n\
${output_dir}/$*.mp.d: $${TMP_DEPS}\n\
${output_dir}/$*-1.pdf: ${output_dir}/$*.mp.d $${TMP_DEPS}\n\
" > $@

# 此处的依赖已在.d文件中写明，此处仅为拷贝命令使用
$(output_dir)/%-1.pdf : ${DEP_%.mp}
	@set -e; \
	COMPILE_DIR=$$(mktemp -d /tmp/CLRSMP.XXXXXXXX); \
	echo [compile] $* at $${COMPILE_DIR}; \
	cp $^ $${COMPILE_DIR}/; \
	cd $${COMPILE_DIR}; \
	mptopdf $*.mp > /dev/null; \
	cp *.pdf ${output_dir}/; \
	rm -r $${COMPILE_DIR}
