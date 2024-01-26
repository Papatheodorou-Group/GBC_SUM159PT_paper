

SCRIPT_DIR=$( cd $(dirname $0) ; pwd )

P0="P0_ccRegress"
TREAT="treated_ccRegress"
ALL="all_ccRegress"

META="CB_metadata.tsv"
META_FILT="CB_metadata_ccRegress_filt.tsv"

if [[ $# -lt 5 ]]
then
    echo "Usage: bash $0 <dir> <modeP0> <modeT> <clP0> <clT>"
fi

dir=$1
modeP0=$2
modeT=$3
clP0=$4
clT=$5

dir_P0_filt="${dir}/${P0}_filt"
[[ -d "${dir_P0_filt}" ]] || mkdir -p "${dir_P0_filt}"
cellsP0="${dir_P0_filt}/cells.txt"

dir_T_filt="${dir}/${TREAT}_filt"
[[ -d "${dir_T_filt}" ]] || mkdir -p "${dir_T_filt}"
cellsT="${dir_T_filt}/cells.txt"

dir_all_filt="${dir}/${ALL}_filt"
[[ -d "${dir_all_filt}" ]] || mkdir -p "${dir_all_filt}"
cellsAll="${dir_all_filt}/cells.txt"

# extract the cells
Rscript ${SCRIPT_DIR}/cell_subset.R ${dir}/${P0}/hvg_pca_clust/object.Rds ${modeP0} ${clP0} ${cellsP0}
Rscript ${SCRIPT_DIR}/cell_subset.R ${dir}/${TREAT}/hvg_pca_clust/object.Rds ${modeT} ${clT} ${cellsT}
cat ${cellsP0} ${cellsT} > ${cellsAll}

# subset the object
Rscript ${SCRIPT_DIR}/obj_subset.R ${dir}/${P0}/object.Rds ${cellsP0} ${dir_P0_filt}/object.Rds
Rscript ${SCRIPT_DIR}/obj_subset.R ${dir}/${TREAT}/object.Rds ${cellsT} ${dir_T_filt}/object.Rds
Rscript ${SCRIPT_DIR}/obj_subset.R ${dir}/${ALL}/object.Rds ${cellsAll} ${dir_all_filt}/object.Rds

# subset the metadata
Rscript ${SCRIPT_DIR}/meta_subset.R ${dir}/${META} ${cellsAll} ${dir}/${META_FILT}

exit
