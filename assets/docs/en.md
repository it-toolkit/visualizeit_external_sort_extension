# External Sort Extension

This is the External Sort extension usage doc.

Extension id: `external_sort`

## Available commands

### externalsort-create

Creates the external sort, passing the buffer size for the sort algorithm(first argument), the amount of fragments that can be held in memory at the same time (second argument) and the unsorted file, represented
by a list of keys. File must be larger than buffer size to not be a trivial case in which all file can be loaded in memory
and sorted.

#### Arguments

| Name          | Type     | Position | Required | Default value | Description                          |
|---------------|----------|----------|----------|---------------|--------------------------------------|
| bufferSize    | int      | 0        | true     | -             | Must be in range [ 2, 30 ]           |
| fragmentLimit | int      | 1        | true     | -             | Must be in range [ 2, 30 ]           |
| fileToSort    | intArray | 2        | true     | -             | Must have more keys than buffer size |

### externalsort-sort
Executes the sort algorithm on the unsorted file, generating a list of sorted fragment

### externalsort-merge
Must be used after the sort command. Executes the merge algorithm on the sorted fragments generated in the previous command.

#### Usage example

```yaml
name: "..."
description: "..."
tags: ["..."]
scenes:
  - name: "..."
    extensions: ['external_sort']
    description: "..."
    initial-state:
      - externalsort-create:
          bufferSize: 5
          fragmentLimit: 3
          fileToSort: ["410", "425", "656", "427", "434", "446", "973", "264", "453",
                       "466", "717", "738", "477", "221", "486", "497", "503", "62",
                       "985", "220", "508", "481"]
    transitions:
      - externalsort-sort
      - externalsort-merge
```