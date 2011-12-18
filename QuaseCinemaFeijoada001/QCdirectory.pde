//
// directory stuff
//

//
// file filters
//

java.io.FilenameFilter txtFilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".mov")
    || name.toLowerCase().endsWith(".avi")
    || name.toLowerCase().endsWith(".mp4")
    || name.toLowerCase().endsWith(".ogg")
    || name.toLowerCase().endsWith(".mpg");
  }
};

java.io.FilenameFilter txtFilterMp3 = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".mp3")
    || name.toLowerCase().endsWith(".wav");
  }
};


//
// This function returns all the files in a directory as an array of Strings  
//

String[] listFileNames(String dir,java.io.FilenameFilter extension) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(extension);
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

//
// select an input dir
//

File[] listFiles(String dir) {
  
    File file = new File(dir);

    if (file.isDirectory()) {
	File[] files = file.listFiles();
	return files;
    } else {
	// If it's not a directory
	return null;
    }
}


// ------ folder selection dialog + init visualization ------
void setInputFolder(String theFolderPath) {
  // get files on harddisk
  println("\n"+theFolderPath+"\n");
  FileSystemItem selectedFolder = new FileSystemItem(new File(theFolderPath));
  selectedFolder.printDepthFirst();
  rootFolder = theFolderPath + "/";
  println("\n rootFolder: "+theFolderPath+"\n");
}


class FileSystemItem {
  File file;
  public FileSystemItem[] children;
  int childCount;

  // ------ constructor ------
  FileSystemItem(File theFile) {
    file = theFile;

    if (file.isDirectory()) {
      String[] contents = file.list();
      if (contents != null) {
        // Sort the file names in case insensitive order
        contents = sort(contents);

        children = new FileSystemItem[contents.length];
        for (int i = 0 ; i < contents.length; i++) {
          // skip the . and .. directory entries on Unix systems
          if (contents[i].equals(".") || contents[i].equals("..")
            || contents[i].substring(0,1).equals(".")) {
            continue;
          }
          File childFile = new File(file, contents[i]);
          // skip any file that appears to be a symbolic link
          try {
            String absPath = childFile.getAbsolutePath();
            String canPath = childFile.getCanonicalPath();
            if (!absPath.equals(canPath)) continue;
          }
          catch (IOException e) {
          }
          FileSystemItem child = new FileSystemItem(childFile);
          children[childCount] = child;
          childCount++;
        }
      }
    }
  }



// ------ print and debug functions ------

// Depth First Search
void printDepthFirst() {
  //println("printDepthFirst");
  // global fileCounter1
  fileCounter1 = 0; fileCounter2 = 0; fileCounter3 = 0; fileCounter4 = 0; fileCounterMp3 = 0; 
  printDepthFirst(0,-1);
  //println(fileCounter1+" files");
}
  
  
void printDepthFirst(int depth, int indexToParent) {

    if (file.isDirectory()) {
      //println(file.getName());
      dirs1[fileCounter1] = file.getName();
      dirs2[fileCounter2] = file.getName();
      dirs3[fileCounter3] = file.getName();
      dirs4[fileCounter4] = file.getName();
      indexToParent = fileCounter1; indexToParent = fileCounter2; indexToParent = fileCounter3; indexToParent = fileCounter4;
      fileCounter1++; fileCounter2++; fileCounter3++; fileCounter4++;
    }
    
    // now handle the children, if any
    for (int i = 0; i < childCount; i++) {
      if (depth == 1) { break; }
      children[i].printDepthFirst(depth+1,indexToParent);
    } // end for
    
  }

}
