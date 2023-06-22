#!/bin/bash

source_dataset="darkmatter_disks/domains"
mount_point="/mnt"

# Add the mount point to the dataset
dataset_path="${mount_point}/${source_dataset}"

# Get ZFS datasets
zfs_datasets=$(zfs list -Ho name -r "$source_dataset" | awk -F '/' '{print $NF}' | tail -n +2)

# List datasets
echo -e "\n**Datasets are**"
if [[ -z $zfs_datasets ]]; then
    echo "There are no datasets"
else
    echo "$zfs_datasets"
fi

# Get all directories
all_directories=()
oldIFS=$IFS
IFS=$'\n'
for dir in $(find "$dataset_path" -maxdepth 1 -mindepth 1 -type d); do
    # restore the IFS
    IFS=$oldIFS
    all_directories+=("${dir#$dataset_path/}")
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
