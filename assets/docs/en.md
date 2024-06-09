# External Sort Extension

This is the External Sort extension usage doc.

## Available commands

### externalsort-create

Creates the external sort, passing the buffer size for the sort algorithm(first argument), the amount of fragments that can be held in memory at the same time (second argument) and the unsorted file, represented
by a list of keys

### externalsort-sort
Executes the sort algorithm on the unsorted file, generating a list of sorted fragment

### externalsort-merge
Must be used after the sort command. Executes the merge algorithm on the sorted fragments generated in the previous command.

#### Usage example

```
name: "..."
description: "..."
tags: ["..."]
scenes:
  - name: "..."
    extensions: ['externalsort-extension']
    description: "..."
    initial-state:
      - externalsort-create: [5, 3, ["410","425","656","427","434","446","973","264","453","466","717","738","477","221","486","497","503","62","985","220","508","481"]]
    transitions:
      - externalsort-sort
      - externalsort-merge
```