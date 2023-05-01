pdf_name := CLRS_solution
doc_env  := book_cht
dir_main := $(shell dirname $(shell readlink -fe $(lastword ${MAKEFILE_LIST})))

include $(dir_main)/scripts/common.mk

define clean_misc =
	rm -f $(tex_name).aux $(tex_name).bbl $(tex_name).blg $(tex_name).log $(pdf_name).tuc
endef

dir_fig:=${dir_main}/fig

fig_srcs:=$(shell find ${dir_main} -type f -path "${dir_main}/c[0-9]*.mp")

define mp_to_id =
$(basename $(notdir $1))
endef
define mp_to_pdf =
${output_dir}/$(call mp_to_id,$1)-1.pdf
endef
define mp_to_dep =
${output_dir}/$(notdir $1).d
endef

# #1: mp
# #2: pdf
# #3: dep
define mp_process_template =
fig_dsts+=$2
fig_deps+=$3
DEP_$(call mp_to_id,$1):=$(shell ./gen_deps_for_mp.sh $1 ${dir_fig})
$3:
	@set -e; \
	TMP_DEPS="`./gen_deps_for_mp.sh $1 ${dir_fig}`"; \
	echo [gen dep] $1; \
	echo "$3: $$$${TMP_DEPS}" > $3

$2: $3
	@set -e; \
	COMPILE_DIR=$$$$(mktemp -d /tmp/CLRSMP.XXXXXXXX); \
	echo [compile] $1 at $$$${COMPILE_DIR}; \
	cp $${DEP_$(call mp_to_id,$1)} $$$${COMPILE_DIR}/; \
	cd $$$${COMPILE_DIR}; \
	mptopdf $(notdir $1) > /dev/null; \
	cp *.pdf ${output_dir}/; \
	rm -r $$$${COMPILE_DIR}
endef
$(foreach tmp,${fig_srcs},$(eval $(call mp_process_template,${tmp},$(call mp_to_pdf,${tmp}),$(call mp_to_dep,${tmp}))))

.PHONY: figs
figs: ${fig_dsts}

${main_object}: ${fig_dsts}

include ${fig_deps}
