import 'dart:io';
import 'package:path/path.dart' as dart_path;

class Args{
  Iterable<Directory> directories = new List<Directory>();
  String regexPattern;

  bool get valid => directories.isNotEmpty && directories.every((d) => d.existsSync());
  bool get regexProvided => regexPattern != null && regexPattern.isNotEmpty;
  Directory get input => directories.first;
  Directory get output => directories.last;

  Args.validate(List<String> args){
    if(args.length < 2) {
      print("An input and output path must be provided.");
      return;
    }
    if(args.length == 3) {
      regexPattern = args[2];
    }

    directories = args.take(2).map((a) => new Directory(a));

    // Validate to console.
    if(!input.existsSync()) print("Invalid input directory [${output.path}]");

    // Validate output directory (create it if it doesn't exist).
    if(!output.existsSync()){
      output.createSync(recursive: true);
      print("Created output directory [${output.path}]");
    }
  }

  bool validatePath(String path){
    var dir = new Directory(path);
    if (!dir.existsSync()) {
      print("Directory not found [$path]");
    }
  }
}

class FileMouseFile {
  File file;
  String newName;
  FileMouseFile(this.file, this.newName);
  FileMouseFile withNewName(String s) {
    return new FileMouseFile(this.file, s);
  }
}

main(List<String> args) {

  Args a = new Args.validate(args);

  // Return if arguments are invalid, console has already been notified!
  if(!a.valid) return;

  List<FileMouseFile> files = a.input
      .listSync()
      .where((f) => f is File)
      .map((f) => new FileMouseFile(f, dart_path.basename(f.path)))
      .toList();

  // If a regex is provided, only files matching the regex will be copied.
  // The first matching group will be prepended to the file name.
  if (a.regexProvided) {
    var regex = new RegExp(a.regexPattern);
    files = files
        .where((f) => regex.hasMatch(f.newName))
        .map((f) => f.withNewName("${regex.firstMatch(f.newName).group(1)}${f.newName}"))
        .toList();
  }

  print("Copying ${files.length} files...");

  files.forEach((f) => copy(f, a.output));

  print("Done!");
}

void copy(FileMouseFile f, Directory output){
  f.file.copySync(dart_path.join(output.path, f.newName));
}
