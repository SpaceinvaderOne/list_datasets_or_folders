# ZFS Dataset content lister

This is a simple bash script for managing ZFS Datasets. The script generates a list of ZFS datasets under a specific source directory and lists all regular directories under a parent dataset.

## How to Use

1. Set `source_dataset` to your source dataset (This is array where you can list the paths of datasets that should be checked by the script).
2. Run the script to list all ZFS datasets and regular directories.

## What the Script Does

- The script prints the retrieved datasets. If no datasets are found, it will print "There are no datasets".
- The script then finds all directories (only one level deep) under the dataset path.
- After that, it prints all the folders that are not ZFS datasets. If there are no such folders, it will print "There are no folders".

## Limitations

The script currently only supports a one-level depth directory structure under the dataset path.

## Contributing

Contributions are welcome. Feel free to open a pull request with improvements.
