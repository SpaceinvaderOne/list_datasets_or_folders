#!/bin/bash

source_datasets=("example_pool/appdata" "example_pool/domains")  # List your source datasets here

# Do not change anything below here
mount_point="/mnt"
#
handle_dataset() {
    local source_dataset="$1"

  # set example dummy dataset so script can see if user has chaged them before running
    local dummy_datasets=("example_pool/appdata" "example_pool/domains")
   
  # Check if the dataset exists
    if ! zfs list "$source_dataset" >/dev/null 2>&1; then
        # Check if the dataset is a dummy
        for dummy_dataset in "${dummy_datasets[@]}"; do
            if [ "$source_dataset" == "$dummy_dataset" ]; then
                echo "Error: $source_dataset is an example dummy location in the script. You should change this to a real valid location for your server."
                return 1
            fi
        done

        # If the dataset doesn't exist, check if the directory exists
        if [ -d "${mount_point}/${source_dataset}" ]; then
            echo "Error: $source_dataset this location exists, but it's not a ZFS dataset. Please select a dataset not a folder as the source"
        else
            echo "Error: $source_dataset this location doesn't exist. Please check your script."
        fi
        return 1
    fi


    # add Unraid mountpoint
    local dataset_path="${mount_point}/${source_dataset}"

    # Get datasets
    local zfs_datasets=$(zfs list -Ho name -r "$source_dataset" | awk -F '/' '{print $NF}' | tail -n +2)

    # List datasets
    echo -e "\n**Datasets in $source_dataset are**"
    if [[ -z $zfs_datasets ]]; then
        echo "There are no datasets"
    else
        echo "$zfs_datasets"
    fi

    # Get all directories
    local all_directories=()
    local oldIFS=$IFS
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

    # List regular directories/folders
    echo -e "\n**Folders in $source_dataset are**"
    local folders_found=0
    for folder in "${all_directories[@]}"; do

        if ! grep -Fxq "$folder" <<< "$zfs_datasets"; then
            echo "$folder"
            folders_found=1
        fi
    done

    if [[ $folders_found -eq 0 ]]; then
        echo "There are no folders"
    fi
}

# Process each dataset
for dataset in "${source_datasets[@]}"; do
    handle_dataset "$dataset"
echo ""
echo "----------------------------------------------------------------------------"
echo ""
done

