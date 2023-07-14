#!/bin/bash

source_dataset=( "dark_matter/appdata" "dark_matter/domains" )
mount_point="/mnt"

# Get ZFS datasets
zfs_datasets=()
for dataset in ${source_dataset[@]}; do
    zfs_datasets+=("$(zfs list -Ho name -r "$mount_point/$dataset" | tail -n +2)")
done

# List datasets
echo -e "\n**Datasets are**"
echo "${zfs_datasets[@]}"

# Get all directories
all_directories=()
oldIFS=$IFS
IFS=$'\n'
allpaths=()
for dataset in ${source_dataset[@]}; do
    allpaths+=("$(find $mount_point/$dataset  -maxdepth 1 -mindepth 1 -type d)")
done
for dir in ${allpaths[@]}; do
    # restore the IFS
    IFS=$oldIFS
    all_directories+=("${dir#$mount_point/}")
    # change IFS back to handle newline only for the next loop iteration
    IFS=$'\n'
done
# restore the IFS
IFS=$oldIFS

# List regular directories
echo -e "\n**Folders are**"
folders_found=0
for folder in "${all_directories[@]}"; do
    if ! grep -Fxq "$folder" <<< "$zfs_datasets"; then
        echo "$folder"
        folders_found=1
    fi
done

if [[ $folders_found -eq 0 ]]; then
    echo "There are no folders"
fi
