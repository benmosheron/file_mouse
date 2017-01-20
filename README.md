# file_mouse
A small file mover written in dart.

##Syntax

`>dart main.dart <input> <output> [<regex>]`

* `<input>` Path to the directory containing the files to be copied.
* `<output>` Path to the directory which files will be moved to. If this directory doesn't exist, it will be created.
* `<regex>` An optional regex pattern applied to file names in the input directory. Only files whose names match the regex will be copied. The first matching group of the regex will be prepended to the copied files' names. If no pattern is provided, all files will be copied.

##Example

Folder `C:\videos` contains the following files:
* meow.mp3
* gecko.jpg
* mouse [91].mp4
* mouse [92].mp4

file_mouse is run with the following command:
`>dart main.dart "C:\videos" "C:\mouse videos" "(\[9\d\])"`

A folder, `C:\mouse videos` will be created, with the following contents:
* [91]mouse [91].mp4
* [92]mouse [92].mp4

### Info

* CsvGnome is the creation of Ben Sheron. I welcome correspondence at benmosheron@gmail.com
