#
##########################################################################################################################################
#
# Helper file contains procs to support tcl scripts
#
# ---> TODO:
# [x]0) sort procs alphabetically (bill)
#   1) review this script and make both an alphabetic and functional based index with description
#      documentors: Bill (start - provides several examples) - will do log files
#                   Harshal
#                   Asim
#                   Ninad - index/string manipulation procs
#                   Omkar
#
# [x]2) add Doxigen compatable comments for each function/proc
#      #/**
#         <name of proc> 
#         <description of what proc does>
#         <metatags>
#         @param <name of argument>
#         @return { describe type and meaning of returned value }
#      #*/
#     where the metatags might be used to identify the function such as its catagory { list manipulation, string manipulation, etc. }
#   3) Make certain that the procs are organized properly (that is, something for string manipulation might have been accidentally placed in another section) (in spreadsheet)
#   4) (stretch) Identify any missing capability and add it 
#
# --------------------------------
#
#   ALPHABETIC INDEX (just proc names, args, and brief description)
#
#       atEOF { }
#       boxedMsg { x }
#       catonate { x y }
#       closeLogFile { }
#       closestPart { partNumber }
#       commaSeparatedStringToList { str }
#       containedIn { target list }
#       copyFiles { domain, tcName, list }
#       copyIfNewer { src dst }
#       createDir { dirName }
#       demoPath { }
#       directoryCreate { dirName }
#       directoryDelete { target }
#       directoryExists { target }
#       directoryWipe { target }
#       directoryWipe { target }
#       doneWithStep { n }
#       dumpStack { }
#       errorMsg { msg }
#       extractIntegerFromString { s }
#       fileClose { }
#       fileDelete { target }
#       fileExists { target }
#       fileOpen { fName mode }
#       fileRead { }
#       filesDelete { list }
#       fileWrite { msg }
#       find7z { }
#       findDir { basedir pattern }
#       findDirectories { basedir pattern recursive }
#       findFiles { basedir pattern recursive }
#       findInThisBranch { basedir pattern }
#       fixSlashes { path }
#       flushLogFile { }
#       getFiles { target }
#       getLanguage { }
#       getLastHierarchy { path }
#       getLastStep { }
#       getNewestXilinxVersion { }
#       getPathToJava { }
#       getScriptLocation { }
#       hierarchyToList { name }
#       infoMsg { msg }
#       inList { item thisList }
#       invertLogic { x }
#       isDigit { c }
#       isDirectory { target }
#       isFile { target }
#       labPath { }
#       lastIndexOf { s c }
#       latestVersion { IPname }
#       logClose { }
#       logExist { }
#       logExists { }
#       logFlush { }
#       logForceOpen { logFileName }
#       logicValue { x }
#       logIsOpen { }
#       logOpen { logFileName }
#       logOpenForAppending { logFileName }
#       logWrite { s }
#       markLastStep { lastStepName }
#       militaryMonthName { monthNumber }
#       msSleep { ms }
#       numberOfCPUs { }
#       openLogFile { logFileName }
#       pause { }
#       print { msg }
#       procName { }
#       randName { len }
#       repeatChar { c n }
#       rm-R { startDir }
#       runChoicesGUI { path_to_source argList }
#       runDedScript { path_to_source path_to_script }
#       runDedScriptExtra { path_to_source path_to_script path_to_destination }
#       runJava { toolName arguments }
#       safeCopy { src dst }
#       safeMove { src dst }
#       scanDir { dir }
#       spaceSeparatedStringToList { str }
#       strace { }
#       strcmp { a b }
#       strContains { a b }
#       strEndsWith { a b }
#       strIndex { s c from }
#       stripLastHierarchy { path }
#       strLastIndex { a b }
#       strlen { a }
#       strMatch { a b }
#       strPosition { a b }
#       strReplace { s target replacement }
#       strsame { a b }
#       substr { x a b }
#       toHex { decVal }
#       unfixSlashes { path }
#       urlFileGetBinary { url fName }
#       urlFileGetText { url fName }
#       use { thing }
#       warningMsg { msg }
#       workspacePath { }
#       writeLogFile { s }
#       zipIt { srcDirName destFileName }
#
# --------------------------------
#
#   FUNCTIONAL INDEX (just proc names and brief description) - grouped by function (String manipulation, log file functions, file/directory manipulation, list manipulations, conversion, ...)
#
# --------------------------------
# index: 
#    runDedScript  - source script - configures the arguments and launches the directedEditor
#    fixSlashes    - path          - replaces \\ with / when moving from Windows to Linux
#    unfixSlashes  - path          - replaces / with \\ when moving from Linux to Windows
#    use           - argument      - sets one of several global variables based on the argument <move to completer_helper>
#    strcmp        - a b           - returns a value > 0 if a > b, value < 0 if a < b, and 0 if equal. Comparison is case insensitive
#    strcontains   - a b           - returns value > 0 if b exists in a
#    strEndsWith   - a b           - returns value > 0 if a ends with b, 0 otherwise.  Comparison is case insensitive
#    strLastIndex  - a b           - returns the last position of b in a
#    strMatch      - a b           - returns 1 if a and b are case insensitive matches, 0 otherwise
#    markLastStep  - name          - remembers the name of the last step. used in conjunction with getLastStep <move to completer_helper>
#    getLastStep   -               - returns the name of the last step executed                                <move to completer_helper>
#    getLanguge    -               - returns the value of the language variabled. used in conjuction with "use" <move to completer_helper>
# urlFileGetText
# urlFileGetBinary
#    *** Log File procs:
#       logExist                   - returns true if log file exists (which means that it is currently capturing data)
#       logForceOpen <fname>       - opens a text file of fname to use as a log file. if a log file already exists, it is closed and this new file becomes the active log file
#       logOpen <fname>            - creates a text file of fname to use as a log file. if a log file already exists, a warning message is printed to the log file and no further changes to the data logging occur
#       openLogFile <fname>        - deprecated - same as logOpen
#       logClose <fname>           - flushes and closes the log file
#       closeLogFile <fname>       - deprecated - same as logClose
#       logWrite <msg>             - writes msg to log file and flushes
#       writeToLogFile <msg>       - deprecated - same as logWrite
#       logFlush                   - flushes the log file buffer to disk
#       flushLogFile               - deprecated - same as logFlush
#       boxedMsg <message>         - Makes a pretty box around message and sends to the log file and console
#       infoMsg <msg>              - dumps msg to log file and console with info flag and msg
#       warningMsg <msg>           - dumps msg to log file and console with warning flag and msg
#       errorMsg <msg>             - dumps msg to log file and console with error flag and msg
#       print <msg>                - dumps msg to log file and console with no formatting
#
#   *** File and directory management
#    workspacePath - builds proper path to workspace c:/training/$topic_name/workspace
#    labPath       - builds proper path to the lab    c:/training/$topic_name>/lab
#    demoPath      - builds proper path to the demo   c:/training/$topic_name/demo
#    getPathToJava - locates and returns the path to the newest version of the jre on the local machine (5/23/2016 - sc) (5/13/2016 - wk)
#    findFiles     - starting_dir namePattern - returns a list of files beginning at the starting_dir that match the namePattern
#    findDirectory - starting_dir namePattern - returns a list of directories beginning at the starting_dir that matches the namePattern
#    directoryExists - returns 1 if the specified directory exists, 0 otherwise
#    directoryWipe  - deletes directory and all content within that directory (rm -r)
#    stripLastHierarchy - removes last level of hierarchy in a path - this could be either file name or directory name
#    scanDir        - returns a list of all directories from the given path
#    hierarchyToList - converts a full path to a list of directories with the last entry being the file name
#    directoryCreate - makes a directory of the passed name at the specified location
#
#    latestVersion - ip name (with old version #) - returns the same IP with the latest version number
#    
#
# History:
#    2019/05/10 - WK - added copyFiles
#    2019/05/06 - WK - added support for ZCU111 and ZCU102. minor code cleanup. fix to findDirectories.
#    2019/01/16 - AM - Added Linux paths
#    2018/04/10 - WK - copyIfNewer - added protection for missing source file
#    2018/04/03 - WK - added failed delete protection
#    2018/03/29 - WK - added new filesDelete and changed the old filesDelete to directoryWipe, findFiles now has a third argument for recursive searching
#    2018/03/27 - WK - added check to see if verbose was defined or not (to prevent "no such variable" errors), tested runJava proc, added logForceOpen
#    2017/11/28 - WK - added additional use capability - QEMU
#    08/28/2017 - WK - added getLatestXilinxVersion
#    08/28/2017 - WK - fixed activePeripheralList failure to initialize, cleaned up "use", added debug variable
#    07/31/2017 - WK - updated for 2017.1 including removal of SVN access (see developer_helper.tcl)
#    11/01/2016 - WK - added numerous procs to support 2016.3 and future releases
#    07/25/2016 - WK - added numerous procs to support 2016.1 release
#    04/15/2016 - WK - initial coding
#
###################################################################################################################################################
#

#!/usr/bin/tclsh
variable hostOS [lindex $tcl_platform(os) 0]
if { $hostOS == "Windows" } {
    set trainingPath "c:"
    set xilinxPath "c:/Xilinx"
} else {
    set trainingPath "/home/xilinx"
    set xilinxPath "/opt/Xilinx/Vivado_SDK"
}

puts "setting training directory to $trainingPath/training"
puts "setting Xilinx tool path to $xilinxPath"

#puts "Building for version $::env(VIVADO_VER)"
puts "helper.tcl - 2019.1 - 2019/05/10"

# general use variables
variable language         undefined
variable platform         undefined
variable lastStep         notStarted
variable processor        undefined
variable activePeripheralList ""
variable debug            1
variable usingQEMU        0
variable tools            /training/tools
variable myLocation       [file normalize [info script]]
set suppressLogErrors     0

# used to indicate that the helper.tcl was loaded
variable helper loaded

# is verbose mode defined?
if {![info exists verbose]} {
   variable verbose 0;        # just define the verbose variable and keep it disabled
} 


#/**
# * proc:  pause
# * descr: prompts user to press a key to continue. proc returns after key-press 
# * @meta wait, user, input
# */
proc pause {} {
    puts -nonewline message "Hit Enter to continue ==> "
    flush stdout
    gets stdin
}

#/**
# * proc:  labPath
# * descr: returns the path to lab directory in the current topic cluster
# * @meta  path, training, lab
# */
proc labPath {} {
   variable topicClusterName
   variable trainingPath
   set path $trainingPath/training/$topicClusterName/lab
   return $path
}
#/**
# * proc:  demoPath
# * descr: returns the path to demo directory in the current topic cluster
# * @meta  path, training, demo  
# */
proc demoPath {} {
   variable trainingPath
   variable topicClusterName
   set path $trainingPath/training/$topicClusterName/demo
   return $path
}
#/**
# * proc:  workspacePath
# * descr: returns the path to workspace directory in the current topic cluster
# * @meta path, training, workspace 
# */
proc workspacePath {} {
   variable trainingPath
   variable topicClusterName
   set path $trainingPath/training/$topicClusterName/workspace
   return $path
}
#########################################################################
#
# procs for managing drives
#
#    getDriveList - returns a list of available drives
#
# todo: http://twapi.magicsplat.com/v3.1/disk.html for get_volume_info 
#
#########################################################################
#package require twapi
#proc driveEject { target } {
# todo: make sure target is in the form: X: or X:/
#   eject_media $target
#}
#proc getDriveList {} {
#   return [file volumes];
#}

#/**
# * proc:   getPathToJava
# * descr:  identifying the newest version of JRE assuming that java was installed into one of the two default directories
# * @meta   java, jre, path, windows
# */
proc getPathToJava {} {
   variable hostOS
   puts "Operating System detected: $hostOS"
   if { $hostOS != "Windows" } { return "/usr/bin/java" } 
   
   set maxVal ""
   set maxLength 0
   set javaDirs86 [glob -directory "c:/Program Files (x86)/Java" -type d -nocomplain *]
   set javaDirs   [glob -directory "c:/Program Files/Java" -type d -nocomplain *]
   set allJavaDirs {}
   append allJavaDirs $javaDirs " " $javaDirs86
   # allJavaDirs will contain a mix of jres and jdks. we only want the jres
   set cleanList {}
   foreach dir $allJavaDirs {
      set dirList [hierarchyToList $dir]
      set dirName [lindex $dirList [expr [llength $dirList] - 1]]
      # pull first 4 characters
      set type [substr $dirName 0 2]
      if {[strsame $type jre]} { lappend cleanList $dir}
   }
   set allJavaDirs $cleanList
   puts "All Java Directories is now $allJavaDirs"

   # were any Java directories found? If not, we can't continue!
   if {[llength $allJavaDirs] == 0} {
      puts "No Java installation found! Cannot continue!";
     puts "Please install Java JRE in its default location!"
     puts "go to Java.com and download the free tool"
     return "";
   }
   
   # if some Java directories were found, then we can continue
   set javaPath ""
   foreach dir $allJavaDirs {
      # isolate just the directory name from the full path
      set firstIndex [string first jre1 $dir]
      set version    [string range $dir $firstIndex end]
      
      # break out the actual version number which will be in the form x.y_z*
      # find the last dot in the name and strip the string to that point
      set lastDot [string last . $version]
      incr lastDot -1
      set nextToLastDot [string last . $version $lastDot]
      incr nextToLastDot
      set length  [string length $version]
      set trimmedVersion [string range $version $nextToLastDot $length]
   
      # debug - the comparison should be on the version, the result should be the path
      # for now, just compare the entire directory
      set newLength [string length $trimmedVersion]
      set maxLength [string length $maxVal]
      if {$newLength > $maxLength} {
         set maxLength $newLength
         set maxVal $trimmedVersion
         set javaPath $dir
      } elseif {$newLength > $maxLength} {      
         if {[strsame $maxVal $trimmedVersion]} {
            if {$debug > 0} { puts "Setting new max to $trimmedVersion from directory $dir" }
            set maxVal $trimmedVersion
            set javaPath $dir
         }
      } else {
     }
   }
   # debug: javaPath not getting set 
   if {[string length $javaPath] == 0} {
      puts "was unable to find a path to Java!"
     return ""
   } else {
      return $javaPath/bin/java.exe
   }
}

#/**
# * proc:  getNewestXilinxVersion
# * descr: identifies newest version of Xilinx tools in the default install directory
# * @meta  xilinx, path, vivado, sdk, find, newest, version
# */
proc getNewestXilinxVersion {} {
   variable xilinxPath
   set maxVal ""
   set maxLength 0
   set allVivadoVersionDirs [glob -directory "$xilinxPath/Vivado" -type d -nocomplain *]
   set allSDKversionDirs [glob -directory "$xilinxPath/Vivado" -type d -nocomplain *]
   set allXilinxVersionDirs {}
   append allXilinxVersionDirs $allVivadoVersionDirs " " $allSDKversionDirs

   # were any Java directories found? If not, we can't continue!
   if {[llength $allXilinxVersionDirs] == 0} {
      puts "No Xilinx installation found! Cannot continue!";
     puts "Please install the Xilinx tools to its default location!"
     puts "go to Xilinx.com > Support > Downloads and download the version you need"
     return "";
   }
   
   # if some directories were found, then we can continue
   set xilinxVersion 0
   foreach dir $allXilinxVersionDirs {
      # strip off the path information
     set lastHierarchySeparatorPos [expr [string last / $dir] + 1]
     set version [string range $dir $lastHierarchySeparatorPos [string length $dir]]
     
     # get rid of the dot which could screw up the comparisons
      set decimalPos [string last . $version]
      set trimmedVersion ""
      append trimmedVersion [string range $version 0 [expr $decimalPos - 1]] [string range $version [expr $decimalPos + 1] [string length $version]]
   
      # the comparison should be on the version, the result should be the newest (largest)
      if {$xilinxVersion < $trimmedVersion} {
         set xilinxVersion $trimmedVersion
      } 
   }
   # debug: javaPath not getting set 
   if {[string length $xilinxVersion] == 0} {
      puts "was unable to find a path to Xilinx!"
     return ""
   } else {
      # put the decimal point back in
     set retStr ""
     append retStr [string range $xilinxVersion 0 3] . [string range $xilinxVersion 4 5]
      return $retStr
   }
}

#/**
# * proc:  rm-R
# * descr: manually creates a list of files, sorts them in reverse alpha and deletes everything
# * @meta  delete, recursive, rmdir, remove, directory
# * @param startDir  
# * @return  1 on success; 
# *         -1 when files and directires could not be deleted;
# *         -2 when files deleted, but not directories
# */
proc rm-R {startDir} {
   set fileList [findFiles $startDir * 1]   
   set fileList [lsort -decreasing -nocase $fileList]
   
   infoMsg "rm-R: removing files and directories from $startDir"
   
   foreach fileElement $fileList {
      catch {
         file delete -force $fileElement
      } err
      if {[string length $err] > 0} {
         errorMsg "could not delete $fileElement - $err"
         return -1
      }
   }
   
   set dirList [findDirectories $startDir * 1]
   set dirList [lsort -decreasing -nocase $dirList]
   foreach dirElement $dirList {
      catch {
         file delete -force $dirElement
      } err
      if {[string length $err] > 0} {
         errorMsg "could not delete $dirElement - $err"
         return -2
      }
   }
   return 1
}

#/**
# * proc:  findFiles
# * descr: find files in the hierarchy <starting path, files to find, 1=recursive>
# * @meta   search, find, files, recursive
# * @param  basedir   - directory in which to begin the search 
# * @param  pattern   - which files to find (should handle wildcards)
# * @param  recursive - 1 will do a recursive search, 0 will only search in current directory
# * @return list of file paths
# */
proc findFiles { basedir pattern recursive} {

   # Fix the directory name, this ensures the directory name is in the
   # native format for the platform and contains a final directory seperator
   set basedir [string trimright [file join [file normalize $basedir] { }]]
   set fileList {}

   # Look in the current directory for matching files, -type {f r}
   # means ony readable normal files are looked at, -nocomplain stops
   # an error being thrown if the returned list is empty
   catch {
      foreach fileName [glob -nocomplain -type {f r} -path $basedir $pattern] {
         lappend fileList $fileName
      }
   } err
   if {[string length $err] > 0} { puts "findFiles error value: $err" }

   # Now look for any sub direcories in the current directory
   if {$recursive} {
      catch {
         foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
            # Recusively call the routine on the sub directory and append any
            # new files to the results
            set subDirList [findFiles $dirName $pattern 1]
            if { [llength $subDirList] > 0 } {
               foreach subDirFile $subDirList {
                  lappend fileList $subDirFile
               }
            }
         }
      } err
      if {[string length $err] > 0} { puts "subdirectory errors: $err" }
   }
   
   return $fileList
}
#/**
# * proc:  findDirectories
# * descr: find directories in the hierarchy <starting path, directories to find, 1=recursive>
# * @meta   search, find, directories, directory, recursive
# * @param  basedir   - directory in which to begin the search 
# * @param  pattern   - which directories to find (should handle wildcards)
# * @param  recursive - 1 will do a recursive search, 0 will only search in current directory
# * @return list of directory paths
# */
proc findDirectories { basedir pattern recursive } {

   # Fix the directory name, this ensures the directory name is in the
   # native format for the platform and contains a final directory seperator
   set basedir [string trimright [file join [file normalize $basedir] { }]]
   set dirList {}

   # Look in the current directory for matching files, -type {f r}
   # means ony readable normal files are looked at, -nocomplain stops
   # an error being thrown if the returned list is empty
   catch {
      foreach dirName [glob -nocomplain -type {d r} -path $basedir $pattern] {
         lappend dirList $dirName
      }
   } err
   if {[string length $err] > 0} { puts "findDirectories error value: $err" }

   # Now look for any sub direcories in the current directory
   if {$recursive} {
      catch {
         foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
            # Recusively call the routine on the sub directory and append any
            # new files to the results           
            set subDirList [findDirectories $dirName $pattern 1]
            if { [llength $subDirList] > 0 } {           
               foreach subDirFile $subDirList {
                  lappend dirList $subDirFile                  
               }
            }
         }
      } err
      if {[string length $err] > 0} { puts "subdirectory errors: $err" }
   }
   
   return $dirList
}

#/**
# * proc:   findDir
# * descr:  find a directory in the hierarchy starting from a given location (recursively)
# * todo:   update this to use findDirectories and return count of found directories > 0
# * @meta   find, search, browse, directory, dir
# * @param  basedir - starting location of the search
# * @param  pattern - name of directory to find (will accept wildcards. returns true if any variant of the wildcard is found)
# * @return true if indicated directory is found, false (0) otherwise
# */
proc findDir { basedir pattern } {

    # Fix the directory name, this ensures the directory name is in the native format for the platform and contains a final directory seperator
    set basedir [string trimright [file join [file normalize $basedir] { }]]
    set fileList {}

    # Look in the current directory for matching files, -type {d} means ony directories are looked at, -nocomplain stops an error being thrown if the returned list is empty
   set targetName [glob -nocomplain -type {d} -path $basedir $pattern]
   #if {[llength $targetName] > 0} { puts "found!"; return 1 }
   
    # Now look for any sub direcories in the current directory and recurse
    foreach dirName [glob -nocomplain -type {d  r} -path $basedir *] {
      set foundInThisBranch 0
        if {[catch {set findInThisBranch [findDir $dirName $pattern]} result]} {
         # puts "Error Management in the true portion of the if statement: $result"
      } 
      if { $foundInThisBranch == 1 } { return 1; }
    }
    return 0
}

#/**
# * proc:   findInThisBranch
# * descr:  finding directory names in the hierarchy - only one level of hierarchy depth
# * todo:   obsolete this proc in favor of findDirectories with recursion set to 0
# * @meta   find, search, file, name, directory
# * @param  basedir  
# * @param  pattern  
# * @return list of directory names
# */
proc findInThisBranch { basedir pattern } {

    # Fix the directory name, this ensures the directory name is in the
    # native format for the platform and contains a final directory seperator
    set basedir [string trimright [file join [file normalize $basedir] { }]]
    set fileList {}

    # Look in the current directory for matching files, -type {f r}
    # means ony readable normal files are looked at, -nocomplain stops
    # an error being thrown if the returned list is empty
    foreach fileName [glob -nocomplain -type {d r} -path $basedir $pattern] {
        lappend fileList $fileName
    }

    # Now look for any sub direcories in the current directory
    #foreach dirName [glob -nocomplain -type {d  r} -path $basedir $pattern] {
        # Recusively call the routine on the sub directory and append any
        # new files to the results
        #set subDirList [findFiles $dirName $pattern]
        #if { [llength $subDirList] > 0 } {
        #    foreach subDirFile $subDirList {
        #        lappend fileList $subDirFile
        #    }
        #}
   #  lappend fileList $dirName
    #}
    return $fileList
}

#/**
# * proc:   fileExists
# * descr:  identifies if a file exists
# * @meta   file, exist, exists
# * @param  target  
# * @return true/1 if file is found, false/0 otherwise
# */
proc fileExists {target} { 
   set fexist [file exist $target]
   return $fexist 
}
#/**
# * proc:  isFile
# * descr: 
# * @meta <list of searchable terms> 
# * @param target  
# */
proc isFile { target } {
   set fexist 0
   if {[fileExists $target]} {
      set fexist [file isfile $target]
   }
   return $fexist
}
#########################################################################
#
# proc for identifying if a directory exists
#
# returns 1 if the directory is found, 0 otherwise
#
#########################################################################
#/**
# * proc:  directoryExists
# * descr: identify if a directory exists
# * @meta <list of searchable terms> 
# * @param target  
# */
proc directoryExists {target} { return [file isdirectory $target] }
#/**
# * proc:   isDirectory
# * descr:
# * @meta   file, exist, exists
# * @param  target  
# * @return true/1 if file is found, false/0 otherwise  
# */
proc isDirectory {target} { return [file isdirectory $target] }

#/**
# * proc:   directoryWipe
# * descr:  removes directory and everything in it - equivalent to rm -r, then recreates it
# * @meta   directory, erase, delete, wipe, clean
# * @param  target  
# * @return 1 for success, 0 indicates target directory didn't exist, 
# *         -1 indicates failure to delete, -2 indicates directory was wiped, but not recreated
# */
proc directoryWipe { target } {
   if {[directoryExists $target]} {
      infoMsg "wiping directory: $target"
      set status [directoryDelete $target]
      if {$status == 1} {
         info "directoryWipe: succesful deletion of $target"
         return 1
      } else {
         errorMsg "directoryWipe: Failed to wipe directory $target with return message of $status"
      }
      return -1
   } else {
      warning "directoryWipe: Directory $target does not exist therefore directoryWipe has nothing to work on"
      return 0
   }
   # recreate the deleted directory
   file mkdir $target
   if {directoryExists $target } {
      return 1
   } else {
      return -2
   }
}
# renamed as directoryWipe may wind up with a different behavior
#/**
# * proc:   directoryDelete
# * descr:  deletes directory and everything in it.
# * @meta   delete, directory, remove, rmdir
# * @param  target  
# * @return -1 for failure, 0 for no directory to work on, 1 success
# */
proc directoryDelete { target } {
   if {[directoryExists $target]} {
      if { [catch {file delete -force $target} fid] } {
         puts stderr "Could not delete $target: $fid"
         exit -1
      }
      if {[directoryExists $target]} {
         warning "failed to delete $target"
         return -1
      }
      return 1
   } else {
      warning "Directory $target does not exist therefore directoryWipe has nothing to work on"
      return 0
   }
}
#/**
# * proc:  directoryWipe
# * descr: erases all the files in the specified directory, but leaves the directory
# * todo:  needs testing as this manually removes all of the files before removing the directories
# * @meta <list of searchable terms> 
# * @param list  
# */
#########################################################################
#
# proc directoryWipe (path to directory)
#
# erases all the files in the specified directory, but leaves the directory
#
#########################################################################
#proc directoryWipe { target } {
#   set fileList [getFiles $target]
#   foreach thisFile $fileList {
#      fileDelete $thisFile
#   }
#}

#########################################################################
#
# proc filesDelete (path)
#
# 
#
#########################################################################
#/**
# * proc:   filesDelete
# * descr:  deletes all the files in the given list
# * @meta   list, delete, files
# * @param  list - paths to the files to delete
# * @return sum of statuses. If all went properly, this value will be equal to the list length 
# */
proc filesDelete { list } {
   set statusSum 0
   foreach thisFile $list {
      set status [fileDelete $thisFile]
      if {$status == 1} {
         puts "$thisFile successfully deleted"
      } else {
         puts "$thisFile failed to be deleted!   <<<==="
      }
      set statusSum [expr $statusSum + $status]
   }   
   return $statusSum
}
#/**
# * proc:   fileDelete
# * descr:  deletes a single file
# * @meta   file, delete, remove, erase 
# * @param  target - path to file to delete
# * @return 1 if successful, 0 if not
# */
proc fileDelete { target } {
   if {[fileExists $target]} {
      catch {
         file delete -force $target
      } err
      if {[string length $err] > 0} {
         puts "could not delete $target - $err"
         if {[logExist]} {
            logWrite "could not delete $target - $err"
         }
         return -1;
      }
   } else {
      warning "File $target does not exist therefore fileDelete has nothing to work on"
      return 0;
   }
   return 1;
}
#########################################################################
#
# proc getFiles (path to directory) - returns a list of all files in this directory
#
#########################################################################
#/**
# * proc:   getFiles
# * descr:  returns a list of all files in this directory
# * @meta   get, file, list 
# * @param  target  
# * @return list of all files in the directory
# */
proc getFiles { target } {
    set basedir [string trimright [file join [file normalize $target] { }]]
    set fileList {}

    # Look in the current directory for matching files, -type {f r}
    # means ony readable normal files are looked at, -nocomplain stops
    # an error being thrown if the returned list is empty
    foreach fileName [glob -nocomplain -type {f r} -path $basedir *] {
        lappend fileList $fileName
    }
    
    return $fileList
 }
    
#########################################################################
#
# proc stripLastHierarchy (path) [
#
#########################################################################
#/**
# * proc:   stripLastHierarchy
# * descr:  removes last level of hierarchy from the specified path
# *         generally used to remove the file name from the path
# *         limited protection, needs further testing
# * @meta   remove, file, name, strip, filename
# * @param  path - path to strip from
# * @return returns the path minus the last level of hierarchy 
# */
proc stripLastHierarchy {path} {
   set lastHierarchySeparator [string last / $path]
   set lastHierarchySeparator [expr $lastHierarchySeparator - 1]
   if {$lastHierarchySeparator > -1} {
      set returnString [string range $path 0 $lastHierarchySeparator]
   } else {
      set returnString ""
   }
   return $returnString
}
#/**
# * proc:   getLastHierarchy
# * descr:  conjugate to stripLastHierarchy
# *         limited protection, needs further testing
# * @meta   <list of searchable terms> 
# * @param  path 
# * @return returns last level of hierarchy from the path 
# */
proc getLastHierarchy {path} {
   set lastHierarchySeparator [string last / $path]
   set lastHierarchySeparator [expr $lastHierarchySeparator + 1]
   if {$lastHierarchySeparator > -1} {
      set returnString [string range $path $lastHierarchySeparator [string length $path]]
   } else {
      set returnString ""
   }
   return $returnString
}
#/**
# * proc:    scanDir
# * descr:   scan directories and provides a list of all the directories at this level of hierarchy
# * todo:    is this functionally identical to a previous proc like "findDirectories"?
# * @meta    find, search, scan, directory, 
# * @param   dir  - starting point
# * @returns list of directory names - not recursive
# */
proc scanDir { dir } {
   set contents [glob -type d -directory $dir *]
   set list {}
   foreach item $contents {
     lappend list $item
    # append out $item
    # append out " "
   }
   return $list
}
#########################################################################
#
# directoryCreate - creates a directory at the specified location
# checks to make sure the directory doesn't already exist
#
#########################################################################
#/**
# * proc:   directoryCreate
# * descr:  creates a directory at the specified location
# * @meta   directory, make, mkdir, mk, create
# * @param  dirName  
# * @return 1 on success, 0 on failure, -1 if it already exists
# */
proc directoryCreate { dirName } {
   if { [directoryExists $dirName] } {
      return -1
   } else {
      return [createDir $dirName]
   }
}

#/**
# * proc:  strIndex
# * descr: finds the first occurance of the character c in string s
# * @meta <list of searchable terms> 
# * @param s    - string to search
# * @param c    - character to find
# * @param from - where to begin looking
# * @return first occurance of c in s starting at from
# */
proc strIndex {s c from} {
   return [string first $c $s $from]
}
#########################################################################
#
# hierarchyToList name
#
# returns list of directory names provided in "name". the file name will
# be the last element in the list
#
#########################################################################
#/**
# * proc:  hierarchyToList
# * descr: 
# * @meta <list of searchable terms> 
# * @param name  
# */
proc hierarchyToList { name } {
   set hierarchyList {}
   
   # are any hierarchy separators found?
   set pos [expr [strIndex $name / 0] + 1]
   while {$pos > 0 && $pos < [string length $name]} {
      set nextPos [strIndex $name / [expr $pos + 1]]
     if {$nextPos == -1} { set nextPos [string length $name] }
     set thisHierarchyName [string range $name $pos [expr $nextPos - 1]]
     lappend hierarchyList $thisHierarchyName
     set pos [expr $nextPos + 1]
   }
   
   return $hierarchyList
}
#########################################################################
#
# containedIn (object,list) 
#
# returns 1 if object is contained in list, 0 otherwise
#
#########################################################################
#/**
# * proc:  containedIn
# * descr: 
# * @meta <list of searchable terms> 
# * @param target  
# * @param list  
# */
proc containedIn {target list} {
   set result [lsearch -exact $list $target]
   if {[expr $result >= 0]} {
      set result 1
   } else {
      set result 0
   }
   return $result
}
#########################################################################
#
# commaSeparatedStringToList str
#
#########################################################################
#/**
# * proc:  commaSeparatedStringToList
# * descr: 
# * @meta <list of searchable terms> 
# * @param str  
# */
proc commaSeparatedStringToList { str } {
   set list {}
   
   # are any hierarchy separators found?
   #set pos [expr [strIndex $str , 0] + 1]
   set pos [strIndex $str , 0]
   if {$pos != -1} { 
      set thisItem [string range $str 0 [expr $pos - 1]]
     lappend list $thisItem
     set pos [expr $pos + 1]
   } else {
      return $str
   }
   
   while {$pos < [string length $str]} {  
      set nextPos [strIndex $str , [expr $pos + 1]]
     if {$nextPos == -1} { set nextPos [string length $str] }
     set thisItem [string range $str $pos [expr $nextPos - 1]]
     lappend list $thisItem
     set pos [expr $nextPos + 1]
   }   
   return $list
}
#########################################################################
#
# spaceSeparatedStringToList str
#
#########################################################################
#/**
# * proc:  spaceSeparatedStringToList
# * descr: 
# * @meta <list of searchable terms> 
# * @param str  
# */
proc spaceSeparatedStringToList { str } {
   set list {}
   
   # are any hierarchy separators found?
   #set pos [expr [strIndex $str , 0] + 1]
   set space " "
   set pos [strIndex $str $space 0]
   if {$pos != -1} { 
      set thisItem [string range $str 0 [expr $pos - 1]]
     lappend list $thisItem
     set pos [expr $pos + 1]
   } else {
      return $str
   }
   
   while {$pos < [string length $str]} {  
      set nextPos [strIndex $str $space [expr $pos + 1]]
     if {$nextPos == -1} { set nextPos [string length $str] }
     set thisItem [string range $str $pos [expr $nextPos - 1]]
     lappend list $thisItem
     set pos [expr $nextPos + 1]
   }   
   return $list
}
#########################################################################
#
# proc for downloading a URL to the local directory
#
#########################################################################
package require http
#/**
# * proc:  urlFileGetText
# * descr: 
# * @meta <list of searchable terms> 
# * @param url  
# * @param fName  
# */
proc urlFileGetText { url fName } {
   set fp [open $fName w]
   # no cleanup, so we lose some memory on every call
   append urlFile $url $fName
   puts $fp [ ::http::data [ ::http::geturl $urlFile ] ]
   close $fp
}
#########################################################################
# proc for downloading a binary 
#########################################################################
#/**
# * proc:  urlFileGetBinary
# * descr: 
# * @meta <list of searchable terms> 
# * @param url  
# * @param fName  
# */
proc urlFileGetBinary { url fName } {
   set fp [open $fName w]
   # no cleanup, so we lose some memory on every call
   append urlFile $url $fName
   puts "Complete URL: $urlFile"
   set r [http::geturl $urlFile -binary 1]
   fconfigure $fp -translation binary
   puts -nonewline $fp [http::data $r]
   close $fp
   ::http::cleanup $r
}
#########################################################################
# proc for copying a file from src to dst if src is newer 
#########################################################################
#/**
# * proc:  copyIfNewer
# * descr: 
# * @meta <list of searchable terms> 
# * @param src  
# * @param dst  
# */
proc copyIfNewer { src dst } {
   # check if source file exists
   if {![fileExist $src]} {
      if {[logExists]} {
         logWrite "attempted to copy $src to $dst, but source doesn't exist!";         
      } else {
         puts "attempted to copy $src to $dst, but source doesn't exist!"
      }
      return
   }
   # if dst doesn't exist then just copy
   if {![fileExist $dst]} {
      file copy -force -- $src $dst
   } else {
      # if dst does exist then get time/date for both src and dst
     set srcTimeDate [file mtime $src]
     set dstTimeDate [file mtime $dst]
      # if src newer than dst, copy
     if {$srcTimeDate > $dstTimeDate} {
        file copy -force -- $src $dst
     }
   }
}

#/**
# * proc:   copyFiles
# * descr:  copies files from the SVN > domain > topicClusters > tcName to \training\<tcName>
# * Warning! this is ONLY for custEd use and is not intended as a general purpose action
# * @meta <list of searchable terms> 
# * @param  domain - FPGA, lang, Embedded, etc. This tells the proc which domain to reach into when copying
# * @param  tcName - name of the topic cluster. used to point to the TC within the domain and the training directory
# * @param  list   - list of files to be copied from the SVN under domain > tcName to the support directory
# * @return - number of files successfully copied  
# */
proc copyFiles { domain tcName list } {

   # define the path to the SVN if not already done
   if {![info exists SVNloc]} { 
      set SVNloc $::env(SVNloc)
      regsub -all {\\} $SVNloc / SVNloc
   }

   # make sure the source path exists. if not, return 0 for no files copied
   set sourcePath ""
   append sourcePath $SVNloc/trunk/$domain/TopicClusters/$tcName
   if {[directoryExists $sourcePath]} {
      # point to the destination
      set destinationPath ""
      append destinationPath /training/$tcName/support
      if {[directoryExists $destinationPath]} {
         # directory does exist, time to iterate through the files
         set successfulFileCopyCount 0
         foreach fileName $list {
            set srcFile $sourcePath/$fileName
            #puts "source: $srcFile  ( [fileExists $srcFile] )"
            if {[fileExists $srcFile]} {
               set dstFile $destinationPath/$fileName
               file delete -force -- $dstFile;                 # ensure that the destination doesn't exist
               if { ![fileExists $dstFile] } {
                  file copy -force -- $srcFile $dstFile;       # copy 
                  if { [fileExists $dstFile] } {
                     set successfulFileCopyCount [expr $successfulFileCopyCount + 1]; # if the file exists now when it didn't before, then it was copied
                  }
               } else {
                  puts "helper.tcl:copyFiles - destination file couldn't be deleted therefore copy is unreliable"
               }
            } else {
               puts "helper.tcl:copyFiles - source file must exist in order to be copied: $srcFile"
            }
         }
         return $successfulFileCopyCount
      } else {
         puts "helper.tcl:copyFiles - destination directory/ies must exist before files can be copied"
      }
   } 
   return 0
}
#########################################################################
# proc for creating a directory if it doesn't yet exist
#
# if it does exist, return 0, otherwise create the directory and return a 1
# if we tried to create the directory but failed, return -1
#########################################################################
#/**
# * proc:  createDir
# * descr: 
# * @meta <list of searchable terms> 
# * @param dirName  
# */
proc createDir { dirName } {
   if {![directoryExists $dirName]} {
      file mkdir $dirName
      if {[directoryExists $dirName]} {
         return 1
      } else {
         errorMsg "Dirctory $dirName should have been created but wasn't!"
         return -1
      }
   } else {
      warningMsg "Directory $dirName already exists - no action taken"
      return 0
   }
}
#########################################################################
# proc for launching the directed editor
#########################################################################
#/**
# * proc:  runDedScript
# * descr: 
# * @meta <list of searchable terms> 
# * @param path_to_source  
# * @param path_to_script  
# */
proc runDedScript {path_to_source path_to_script} {
   variable java
   variable tools
   set java [getPathToJava]
   set arguments ""
   append arguments $tools/directedEditor.jar "," $path_to_source "," $path_to_script
   regsub -all {' '} $arguments ',' arguments
   puts $arguments
   exec $java -jar $tools/directedEditor.jar $path_to_source $path_to_script
}
#/**
# * proc:  runDedScriptExtra
# * descr: 
# * @meta <list of searchable terms> 
# * @param path_to_source  
# * @param path_to_script  
# * @param path_to_destination  
# */
proc runDedScriptExtra {path_to_source path_to_script path_to_destination} {
   variable java
   variable tools
   set java [getPathToJava]
   set arguments ""
   append arguments $tools/directedEditor.jar "," $path_to_source "," $path_to_script
   regsub -all {' '} $arguments ',' arguments
   puts $arguments
   exec $java -jar $tools/directedEditor.jar $path_to_source $path_to_destination
}
# assumes toolName contains full path
# warning: this can be pretty picky with quotes in the argument list
#/**
# * proc:  runJava
# * descr: 
# * @meta <list of searchable terms> 
# * @param toolName  
# * @param arguments  
# */
proc runJava {toolName arguments} {
   variable verbose
   set verbose 1
   set java [getPathToJava]
   # iterate through the arguments list
   if {$verbose} {
      puts "listing passed arguments...$arguments"
      puts "now individually: "
   }
   set argumentString ""
   set argCount 0
   foreach argument $arguments {
      if {$verbose} { puts "$argCount: $argument" }
      append argumentString $argument
      incr argCount
      if {$argCount < [llength $arguments]} { 
         append argumentString ","
      }
   }
   if {$verbose} {
      puts "argument string is $argumentString"
      puts "java location: $java"
      puts "tool name with path: $toolName"   
   }
   puts "getting ready to run the tool"
   # catch any errors to avoid breaking the calling routine
   if {[catch {exec $java -jar $toolName $argumentString} resultText]} {
      puts "failed execution: $::errorInfo"
   } else {
      puts "successful execution - application returned $resultText"
   }
}
#########################################################################
# proc for launching the choicesGUI
#########################################################################
#/**
# * proc:  runChoicesGUI
# * descr: 
# * @meta <list of searchable terms> 
# * @param path_to_source  
# * @param argList  
# */
proc runChoicesGUI {path_to_source argList} {
   variable java
   set java [getPathToJava]
   exec $java -jar $path_to_source $argList
}
#########################################################################
# proc for fixing slashes from Windows to Linux
#########################################################################
#/**
# * proc:  fixSlashes
# * descr: 
# * @meta <list of searchable terms> 
# * @param path  
# */
proc fixSlashes {path} {
   
   # replace below with the following and verify
   regsub -all {\\} $path / path
   
   # set len [string length $path]
   # for {set i 0} {$i < $len} {incr i} {
      # set c [string index $path $i]
      # if {$c == "\\"} {
         # set path [string replace $path $i $i "/"]
      # }
   # }
   return $path
}

#########################################################################
# proc for fixing slashes from Linux to Windows
#########################################################################
#/**
# * proc:  unfixSlashes
# * descr: 
# * @meta <list of searchable terms> 
# * @param path  
# */
proc unfixSlashes {path} {
   
   # replace below with the following and verify
   regsub -all / $path {\\} path
   
   # set len [string length $path]
   # for {set i 0} {$i < $len} {incr i} {
      # set c [string index $path $i]
      # if {$c == "/"} {
         # set path [string replace $path $i $i "\\"]
      # }
   # }
   return $path
}

#########################################################################
# proc for doing wide range of configurable items
#########################################################################
#/**
# * proc:  use
# * descr: 
# * @meta <list of searchable terms> 
# * @param thing  
# */
proc use { thing } {
   variable processor
   variable hdfName
   variable language
   variable platform   
   variable userIO   
   variable MPSoCactivePeripheralList
   variable APSoCactivePeripheralList
   variable activePeripheralList
   variable usingQEMU
   variable debug
   
   # if the variable is not yet in use, initialize it
   if {[info exists processor] == 0} { set processor undefined }   
   if {[info exists hdfName] == 0}   { set hdfName   undefined }
   if {[info exists language] == 0}  { set language  undefined }   
   if {[info exists platform] == 0}  { set platform  undefined }  
   if {[info exists userIO] == 0}    { set userIO    base }      
   if {[info exists usingQEMU] == 0} { set usingQEMU 0}
   
   # what kind of platform is being used? Determine the hdf name and type of processor
   if { [strsame $thing ZCU102] } {
      set platform ZCU102
      set processor A53
      puts "Processor is $processor"
      if { ![strsame $processor MicroBlaze] } {
         if {$debug} { puts "platform: ZCU102; using A53" }
         set processor ps7_cortexa53_0 
        
         if {[info exists MPSoCactivePeripheralList]} {
           set activePeripheralList $MPSoCactivePeripheralList
         } else {
           puts "Variable MPSoCactivePeripheralList must be defined and filled with user defined peripherals."
           puts "In order to keep this script running, this variable will be defined, but not filled with any peripherals"
           set activePeripheralList {}   
         } 
      } else {
         # processor is a MicroBlaze
         if {$debug} { puts "platform: ZCU102; using uB" } 
      }   
   } elseif { [strsame $thing ZC702] } {       
      set platform  ZC702
      if { ![strsame $processor "MicroBlaze"]} {
         if {$debug} { puts "platform: ZC702; using A9" }
         set processor ps7_cortexa9_0 
        
         if {[info exists APSoCactivePeripheralList]} {
           set activePeripheralList $APSoCactivePeripheralList
         } else {
           puts "Variable APSoCactivePeripheralList must be defined and filled with user defined peripherals."
           puts "In order to keep this script running, this variable will be defined, but not filled with any peripherals"
           set activePeripheralList {}   
         } 
      } else {
         # processor is a MicroBlaze
         if {$debug} { puts "platform: ZC702; using uB" } 
      }    
   } elseif { [strsame $thing "Zed"] } {
      set platform  Zed
      if { ![strsame $processor "MicroBlaze"] } {
        if {$debug} { puts "platform: Zed; using A9" } 
         set processor ps7_cortexa9_0 
      
        # assign peripheral list
       if {[info exists APSoCactivePeripheralList]} {
          set activePeripheralList $APSoCactivePeripheralList
        } else {
          puts "Variable APSoCactivePeripheralList must be defined and filled with user defined peripherals."
         puts "In order to keep this script running, this variable will be defined, but not filled with any peripherals"
         set activePeripheralList {}
       }  
     } else {
        # processor is a microblaze
       if {$debug} { puts "platform: Zed; using uB" } 
     }
   } elseif { [strsame $thing KC705] } {
       set processor microblaze_0
       set platform  KC705
       puts "!!! Deprecated board! (KC705) !!!"
   } elseif { [strsame $thing ZCU111] } {
      set processor zynq_ultra_ps_e_0 
      set platform ZCU111;
      if {[info exists MPSoCactivePeripheralList]} {
         puts "setting the peripheral list for this device"
         set activePeripheralList $MPSoCactivePeripheralList
      }      
   } elseif {[strsame $thing "RFSoC"] } {
      set processor zynq_ultra_ps_e_0 
      set platform ZCU111;
      if {[info exists MPSoCactivePeripheralList]} {
         puts "setting the peripheral list for this device"
         set activePeripheralList $MPSoCactivePeripheralList
      }      
   }  elseif { [strsame $thing "KC705"] } {
		set platform KC705
   } elseif { [strsame $thing "KCU105"] } {
		set platform KCU105
   } elseif { [strsame $thing "KC7xx"] } {
		set platform KC7xx
   } elseif {[strsame $thing "vhdl"] } {
		set language vhdl
   } elseif {[strsame $thing "verilog"] } {
		set language verilog
   } elseif { [strsame $thing "ZCU104"] } {
		set platform ZCU104
   } elseif {[strsame $thing "netlist"] } {
		set language netlist
   } elseif { [strsame $thing "base"] } {
      set userIO base
   } elseif { [strsame $thing "FMC-CE"] } {
      set userIO FMC-CE
      puts "FMC-CE has been deprecated!"
   } elseif {[strsame $thing "VHDL"] } {
      set language VHDL
   } elseif {[strsame $thing "Verilog"] } {
      set language Verilog
   } elseif {[strsame $thing "A9"] } {
      set processor ps7_cortexa9_0
   } elseif {[strsame $thing "ps7_cortexa9_0"] } {
      set processor ps7_cortexa9_0
   } elseif {[strsame $thing "APU"] } {
      set processor A53
   } elseif {[strsame $thing "A53"] } {
      set processor A53
   } elseif {[strsame $thing "RPU"] } {
      set processor R5
   } elseif {[strsame $thing "R5"] } {
      set processor R5
   } elseif {[strsame $thing "PMU"] } {
      set processor MicroBlaze
   } elseif {[strsame $thing "MicroBlaze"] } {
      set processor MicroBlaze
   } elseif {[strsame $thing "microblaze_0"] } {
      set processor MicroBlaze
   } elseif {[strsame $thing "uB"] } {
      set processor MicroBlaze
   } elseif {[strsame $thing "QEMU"] } {
      set usingQEMU 1
   } else {
      puts "Unknown use item! $thing"
      return
   }
}

#########################################################################
#
# inList item list_of_things - returns true or false if item is in the list
#
# returns 0 if item is not in list, 1 if it is
#
#########################################################################
#/**
# * proc:  inList
# * descr: 
# * @meta <list of searchable terms> 
# * @param item  
# * @param thisList  
# */
proc inList {item thisList} {
   set result [lsearch $thisList $item];
   if {$result != -1} {return 1} 
   return 0;
}
#########################################################################
#
# strReplaceChar (s x c) - returns string s where character x is replaced by character c
#
#########################################################################
#/**
# * proc:  strReplace
# * descr: 
# * @meta <list of searchable terms> 
# * @param s  
# * @param target  
# * @param replacement  
# */
proc strReplace {s target replacement} {
   set retStr [regsub -all $target $s $replacement]
   return $retStr
}
#########################################################################
#
# strlen (a) - returns number of characters in a
#
#########################################################################
#/**
# * proc:  strlen
# * descr: 
# * @meta <list of searchable terms> 
# * @param a  
# */
proc strlen {a} {
   return [string length $a]
}

#########################################################################
#
# strcmp (a,b) - performs case insensitive comparison
#
# returns -1 if a<b, 0 if a=b, 1 if a>b
#
#########################################################################
#/**
# * proc:  strcmp
# * descr: 
# * @meta <list of searchable terms> 
# * @param a  
# * @param b  
# */
proc strcmp {a b} {
   return [strsame $a $b]
}

#########################################################################
#
# strsame (a,b) - performs case insensitive comparison
#
# returns 1 if they are the same (case not withstanding), otherwise 0
#
#########################################################################
#/**
# * proc:  strsame
# * descr: 
# * @meta <list of searchable terms> 
# * @param a  
# * @param b  
# */
proc strsame {a b} {
   set comparisonValue [string compare -nocase $a $b]
   if {$comparisonValue == 0} { return 1 } else { return 0 }
}
#########################################################################
#
# proc for locating the last occurrance of the given symbol
#
#########################################################################
#/**
# * proc:  lastIndexOf
# * descr: 
# * @meta <list of searchable terms> 
# * @param s  
# * @param c  
# */
proc lastIndexOf { s c } {
   string last $c $s
   puts "Obsolete - use strLastIndex instead of lastIndexOf"
}
#########################################################################
#
# strLastIndex (a,b) - returns the position corresponding to the last
#                      occurrance of b in a
#
#########################################################################
#/**
# * proc:  strLastIndex
# * descr: 
# * @meta <list of searchable terms> 
# * @param a  
# * @param b  
# */
proc strLastIndex {a b} {
   set pos [string last $b $a]
   return $pos
}
# the following appears to return the end of the string starting at the position where b was found
   # if {$pos > -1} {   
      # set pos [incr pos]
      # set str [string range $a $pos [string length $a]]
     # return $str
   # }
   # return "?"
# }
#########################################################################
#
# strMatch (a,b) - returns 1 if and b are case insensitive matches, 0 otherwise
#
#########################################################################
#/**
# * proc:  strMatch
# * descr: 
# * @meta <list of searchable terms> 
# * @param a  
# * @param b  
# */
proc strMatch {a b} {
   set comparisonValue [string compare -nocase $a $b]
   if {$comparisonValue == 0} { return 1 } else { return 0 }
}
#########################################################################
#
# strContains (a,b) - returns 1 if b is in a
#
#########################################################################
#/**
# * proc:  strContains
# * descr: 
# * @meta <list of searchable terms> 
# * @param a  
# * @param b  
# */
proc strContains {a b} {
   set pos [string first $b $a]
   if {$pos > -1} { return 1; }
   return 0;
}
#########################################################################
#
# strPosition (a,b) - returns position of b if in a, -1 otherwise
#
#########################################################################
#/**
# * proc:  strPosition
# * descr: 
# * @meta <list of searchable terms> 
# * @param a  
# * @param b  
# */
proc strPosition {a b} {
   set pos [string first $b $a]
   if {$pos > -1} { return $pos; }
   return -1;
}
#########################################################################
#
# substr (x,start,end) - returns string from start to end
#
#########################################################################
#/**
# * proc:  substr
# * descr: 
# * @meta <list of searchable terms> 
# * @param x  
# * @param a  
# * @param b  
# */
proc substr {x a b} {
   set retVal "Error in substring $x $a $b";
   if {[strlen $x] >= $a} { 
      if {[strlen $x] >= $b} {
        set retVal [string range $x $a $b]
     }
   }
   return $retVal;
}
#########################################################################
#
# strEndsWith (a,b) - does string a end with string b?
#
# returns 0 if no, 1 if yes
#
#########################################################################
#/**
# * proc:  strEndsWith
# * descr: 
# * @meta <list of searchable terms> 
# * @param a  
# * @param b  
# */
proc strEndsWith {a b} {
   set A [string toupper $a]
   set B [string toupper $b]
   set endsWith [string last $B $A]
   set endPosShouldBe [expr [string length $A] - [string length $B]]
   if { $endsWith == $endPosShouldBe } {
      return 1;
   } else {
      return 0;
   }
}
#########################################################################
#
# invertLogic (x) - returns the inverse logic value
#
# returns "yes"  if "no" is passed and vica-versa
#         "1"    if "0"  is passed and vica-versa
#         "true" if "false" is passed and vica-versa
#
#########################################################################
#/**
# * proc:  invertLogic
# * descr: 
# * @meta <list of searchable terms> 
# * @param x  
# */
proc invertLogic {x} {
   if {[strsame $x "yes"]} { 
      return "no"
   } elseif {[strsame $x "no"]} { 
      return "yes"
   } elseif {$x != 0} { 
      return 1
   } elseif {$x == 0} {
      return 1
   } elseif {[strsame $x "true"]} { 
      return "false"
   } elseif {[strsame $x "false"]} { 
      return "true"
   } else {
      return "?"
   }
}
#########################################################################
#
# logicValue (x) - returns 1 or 0 based on x
#
# returns 1 if x is 1, true, or yes; 0 otherwise
#
#########################################################################
#/**
# * proc:  logicValue
# * descr: 
# * @meta <list of searchable terms> 
# * @param x  
# */
proc logicValue {x} {
   if {[strsame $x "yes"]} { 
      return 1
   } elseif {[strsame $x "true"]} { 
      return 1
   } elseif {[strsame $x "1"]} { 
      return 1
   }
   return 0
}
#########################################################################
# proc for marking the step that was just completed
#########################################################################
#/**
# * proc:  markLastStep
# * descr: 
# * @meta <list of searchable terms> 
# * @param lastStepName  
# */
proc markLastStep { lastStepName } {
   variable lastStep
   set lastStep $lastStepName
}
#/**
# * proc:  getLastStep
# * descr: 
# * @meta <list of searchable terms> 
# */
proc getLastStep {} { variable lastStep; return $lastStep }
#/**
# * proc:  getLanguage
# * descr: 
# * @meta <list of searchable terms> 
# */
proc getLanguage {} { variable language; return $language }

#########################################################################
#
# print - prints to both STDOUT and log file (if opened)
#
#########################################################################
#/**
# * proc:  print
# * descr: 
# * @meta <list of searchable terms> 
# * @param msg  
# */
proc print { msg } {
   puts $msg
   logWrite $msg
}

#########################################################################
#
# log file management procs and variables
#
#########################################################################
variable log
variable logPath

# use these procs moving foward, the other procs are present for backward compatability
#/**
# * proc:  logExist
# * descr: 
# * @meta <list of searchable terms> 
# */
proc logExist { } {
   variable log
   variable logPath
   # is the log file already open?
   if {[info exist log] == 1} {
      return 1;
   }
   return 0;
}
#/**
# * proc:  logExists
# * descr: 
# * @meta <list of searchable terms> 
# */
proc logExists {} { logExist; }
#/**
# * proc:  logForceOpen
# * descr: 
# * @meta <list of searchable terms> 
# * @param logFileName  
# */
proc logForceOpen { logFileName } {
   variable log
   variable logPath
   # is the log file already open?
   if {[info exist log] == 1} {
     errorMsg "Log file already open when attempting to open new log file: $logFileName. Closing existing log file and opening new one"
     logClose
   }
   
   # does the logFileName already end in .log?
   if {[strEndsWith $logFileName .log] != 0} {
      set logPath $logFileName
   } else {
      set logPath ""
      append logPath $logFileName .log
   }
   set log [open $logPath w]

   # start the log
   set today [clock format [clock seconds] -format %Y-%m-%d]
   set now   [clock format [clock seconds] -format %H:%M:%S]
   print "$logFileName started at $now on $today"
   logWrite "\n\n"
}
#/**
# * proc:  logOpen
# * descr: 
# * @meta <list of searchable terms> 
# * @param logFileName  
# */
proc logOpen { logFileName } {
   variable log
   variable logPath
   # is the log file already open?
   if {[info exist log] == 1} {
     errorMsg "Log file already open when attempting to open new log file: $logFileName. Will continue with existing log file."
     print "Log file already open when attempting to open new log file: $logFileName. Will continue with existing log file."
     set today [clock format [clock seconds] -format %Y-%m-%d]
     set now   [clock format [clock seconds] -format %H:%M:%S]
     print "attempt to open $logFileName at $now on $today failed. Continuing to use $logPath"    
     logWrite "\n\n"     
   } else {
     # open the file normally
     logForceOpen $logFileName
   }
}
#/**
# * proc:  openLogFile
# * descr: 
# * @meta <list of searchable terms> 
# * @param logFileName  
# */
proc openLogFile { logFileName } {
   logOpen $logFileName
   logWrite "deprecated use of openLogFile found!"
}
#/**
# * proc:  logOpenForAppending
# * descr: 
# * @meta <list of searchable terms> 
# * @param logFileName  
# */
proc logOpenForAppending { logFileName } {
   variable log
   variable logPath
   
   # does the logFileName already end in .log?
   if {[strEndsWith $logFileName .log] != 0} {
      set logPath $logFileName
   } else {
      set logPath ""
      append logPath $logFileName .log
   }

   # now open   
   if {[fileExists $logPath]} {
      set log [open $logPath a+]
   } else {
      errorMsg "Log file name ($logPath) doesn't exist; therefore, can't append to it. Will open it normally."
      logOpen $logPath
   }
}
#/**
# * proc:  logWrite
# * descr: 
# * @meta <list of searchable terms> 
# * @param s  
# */
proc logWrite {s} {
   variable log
   variable suppressLogErrors
   # get the string into the output buffer
   if {[logIsOpen]} { 
      puts $log $s
      # ensure that this buffer gets pushed to the file in case of a crash
      flush $log
   } else {
      if { $suppressLogErrors == 0} { puts "log file wasn't open!!!"   }
   }
}
#/**
# * proc:  writeLogFile
# * descr: 
# * @meta <list of searchable terms> 
# * @param s  
# */
proc writeLogFile {s} {
   logWrite $s
   logWrite "deprecated use of writeLogFile found!"
}
#/**
# * proc:  logFlush
# * descr: 
# * @meta <list of searchable terms> 
# */
proc logFlush {} {
   variable log
   flush $log
}
#/**
# * proc:  flushLogFile
# * descr: 
# * @meta <list of searchable terms> 
# */
proc flushLogFile {} {
   logWrite "deprecated use of flushLogFile found!"
   logFlush
}
#/**
# * proc:  logClose
# * descr: 
# * @meta <list of searchable terms> 
# */
proc logClose {} {
   variable log
   variable logPath
   
   # if there is a log to close...
   if { [info exists log] } {
   
      # show the time/date stamp for the closing
      set today [clock format [clock seconds] -format %Y-%m-%d]
      set now   [clock format [clock seconds] -format %H:%M:%S]     
     
      # dump the message to the log file and console
      print "$logPath closed at $now on $today"
      logWrite "\n"
   
      # empty the buffer and close the file
      flush $log
      close $log
     
      # remove the log so that it is no longer defined and that info exists will return 0 showing log is closed
      unset log
   } else {
      puts "*Error* No log file open"
   }
}
#/**
# * proc:  closeLogFile
# * descr: 
# * @meta <list of searchable terms> 
# */
proc closeLogFile {} {
   logClose
   logWrite "deprecated use of closeLogFile found!"
}
#/**
# * proc:  logIsOpen
# * descr: 
# * @meta <list of searchable terms> 
# */
proc logIsOpen {} {
   variable log
   return [info exists log]
}
#/**
# * proc:  infoMsg
# * descr: 
# * @meta <list of searchable terms> 
# * @param msg  
# */
proc infoMsg { msg } {
   if {[logIsOpen] == 1} {
      logWrite "----- Info: $msg"
    }
    puts     "----- Info: $msg"
}
#/**
# * proc:  warningMsg
# * descr: 
# * @meta <list of searchable terms> 
# * @param msg  
# */
proc warningMsg { msg } {
   if {[logIsOpen] == 1} {
      logWrite "===== Warning: $msg"
   }
   puts     "===== Warning: $msg"
}
#/**
# * proc:  errorMsg
# * descr: 
# * @meta <list of searchable terms> 
# * @param msg  
# */
proc errorMsg { msg } {
   if {[logIsOpen] == 1} {
      logWrite "!!!!! Error: $msg"
   }
   puts     "!!!!! Error: $msg"
}
#########################################################################
#
# user file management procs: fileOpen, fileWrite, fileRead, fileClose
#
#########################################################################
variable fileHandle
variable fileName
variable fileStatus
set fileStatus CLOSED

# mode is w for writing, a for appending
#/**
# * proc:  fileOpen
# * descr: 
# * @meta <list of searchable terms> 
# * @param fName  
# * @param mode  
# */
proc fileOpen {fName mode} {
   variable fileName
   variable fileHandle
   variable fileStatus
   # is the file already open?
   if {[strMatch $fileStatus CLOSED]} {
      # ready to open
     set fileName $fName
     set fileHandle [open $fName $mode]     
     if {[strMatch $mode w]} {
        set fileStatus OPEN_FOR_WRITING
     } elseif {[strMatch $mode a]} {
        set fileStatus OPEN_FOR_APPENDING
     } elseif {[strMatch $mode r]} {
        set fileStatus OPEN_FOR_READING
     }
   }
}
#/**
# * proc:  fileWrite
# * descr: 
# * @meta <list of searchable terms> 
# * @param msg  
# */
proc fileWrite {msg} {
   variable fileName;
   variable fileHandle;
   variable fileStatus;
   if {[strMatch $fileStatus OPEN_FOR_WRITING] || [strMatch $fileStatus OPEN_FOR_APPENDING]} {      
      puts $fileHandle $msg
      # ensure that this buffer gets pushed to the file in case of a crash
      flush $fileHandle
   } else {
      puts "Cannot write to $fileName because it's status is currently listed as: $fileStatus"
   }
}
#/**
# * proc:  fileRead
# * descr: 
# * @meta <list of searchable terms> 
# */
proc fileRead {} {
   variable fileName
   variable fileHandle
   variable fileStatus
   
   set rtnStr READ_FAILURE
   
   if {[strMatch $fileStatus OPEN_FOR_READING]} {
      if {[atEOF]} {
        puts "Can't read from $fileName because we are at the end of file and there is no more data"
     } else {
         set readString [gets $fileHandle]
       return $readString
     }      
   } else {
      puts "Can't read from $fileName because it is currently $fileStatus"
   }
   return ""
}
#/**
# * proc:  atEOF
# * descr: 
# * @meta <list of searchable terms> 
# */
proc atEOF {} {
   variable fileHandle
   variable fileStatus
   
   if {![strMatch $fileStatus CLOSED]} {
      set status [eof $fileHandle]
      return $status
   } else {
      puts "Can't ready from $fileName because it is currently $fileStatus"
   }
}
#/**
# * proc:  fileClose
# * descr: 
# * @meta <list of searchable terms> 
# */
proc fileClose {} {
   variable fileName
   variable fileHandle
   variable fileStatus
   
   if {![strMatch $fileStatus CLOSED]} {
      if {[strMatch $fileStatus OPEN_FOR_APPENDING] || [strMatch $fileStatus OPEN_FOR_WRITING]} {
         flush $fileHandle
     }
      close $fileHandle
     set fileStatus CLOSED
   } else {
      puts "Can't close $fileName because it is already closed!"
   }
}
#
# *** graphic reminder that the section of the script has completed
#     step number is argument
#
#/**
# * proc:  doneWithStep
# * descr: 
# * @meta <list of searchable terms> 
# * @param n  
# */
proc doneWithStep { n } { 
   print "**************************";
   print "*  Done Running Step $n   *";
   print "**************************";
}
#
#########################################################################
#
# boxedMsg (m) - dumps m to the log file and terminal
#
# puts m in pretty box
# centered - 11/04/2016 WK
# future - add wrap
#
#########################################################################
#
#/**
# * proc:  boxedMsg
# * descr: 
# * @meta <list of searchable terms> 
# * @param x  
# */
proc boxedMsg { x } {
   set minWidth 50

   # how wide is the message?
   # future - adjust for cr/lfs in the msg (wrap)
   set xWidth [string length $x]
   # 5 for the leading 2 *s, 2 for the trailing *s, 1 for the each space btwn * and msg
   set totalWidth [expr $xWidth + 2 + 2 + 2]
   
   # ensure that there is a minimum width
   if {$totalWidth < $minWidth} { set totalWidth $minWidth }
   
   # build the top 2 lines (blank line and all asterisks)
   print ""
   set allAsterisks [repeat * $totalWidth]
   print "\t$allAsterisks"

   # 3rd line is asterisks at front and back of line
   set blankedLine ""
   append blankedLine "**" [repeatChar " " [expr $totalWidth - 4]] "**"
   print "\t$blankedLine"

   # 4th line contains the message
   # if smaller than minWidth, then center in the fields
   # first half is totalWidth/2 - "** " - half of the msg width
   set firstHalfBuffer  [expr $totalWidth / 2 - 3 - $xWidth / 2]
   # second half is what ever is left over to account for rounding: including "**" and "**" and whole word
   set secondHalfBuffer [expr $totalWidth - $firstHalfBuffer - $xWidth - 6]    
   set msgLine ""
   append msgLine "\t** " [repeatChar " " $firstHalfBuffer] $x [repeatChar " " $secondHalfBuffer] " **"
   print "$msgLine"

   # finish up with what we started with
   print "\t$blankedLine"
   print "\t$allAsterisks"
   print ""
}

#/**
# * proc:  repeatChar
# * descr: 
# * @meta <list of searchable terms> 
# * @param c  
# * @param n  
# */
proc repeatChar { c n } {
   set s ""
   for {set i 0} {$i < $n} {incr i} {
      append s $c
   }
   return $s
}

#########################################################################
#
# proc for identifying the newest version of IP
#
# pass in IP name and this function will return the newest version of that IP
#
#########################################################################
#/**
# * proc:  latestVersion
# * descr: 
# * @meta <list of searchable terms> 
# * @param IPname  
# */
proc latestVersion { IPname } {
   # find the package type
   set packageTypes {iclg }
   set lastPos [strLastIndex $IPname :]; # strip off everything beyond the third colon (as this contains the version info)
   set IPnameNoVer [string range $IPname 0 $lastPos]
   
   set listOfAllIP [get_ipdefs]
   foreach pieceOfIP $listOfAllIP {
      set lastPos [strLastIndex $pieceOfIP :]; # strip off everything beyond the third colon (as this contains the version info)
      set pieceOfIPnoVer [string range $pieceOfIP 0 $lastPos]
      if {[string compare $pieceOfIPnoVer $IPnameNoVer] == 0} { 
         return $pieceOfIP
      }
   }
}

#########################################################################
#
# proc for identifying the closest part number
#
# pass in a partial part name and this function will return the first match of this part 
# matches to core part minus speed grade, temp grade, es, etc.
# this is useful when a specific part is not required, rather only a member of a family
# and size
# todo: add wildcards
#
#########################################################################
#/**
# * proc:  closestPart
# * descr: 
# * @meta <list of searchable terms> 
# * @param partNumber  
# */
proc closestPart { partNumber } {
   # before we go through the lengthly process of searching, is this part already in the list?
   set partList [get_parts]
   set exactResult [lsearch $partList $partNumber]
   if {$exactResult > -1} {
      return $partNumber;
   }

   # list of known packages
   set packages {clg iclg sclg ifbg isbg sbg fbg fbv ifbv iffg iffv fbg ffg ffv cl rf rb ffvb ffvc ffvd sfva sfvc}

   # strip off the package id
   foreach thisPkg $packages {
      # set pkgPos [strLastIndex $partNumber $packages]; # look for this package in the part
      # if pkgPos > -1 means that it's found
      set pkgPos [strLastIndex $partNumber $thisPkg]
      if {$pkgPos > -1} {
       set partialPart [substr $partNumber 0 $pkgPos]
         append partialPart "*"
         # now find the first partial match...
         set fullPartPosition [lsearch $partList $partialPart]
         set fullPart [lindex $partList $fullPartPosition]
         return $fullPart
      }
   }
   return "???"
}

#########################################################################
#
# proc for copying src to dst
#
# catches any error and prevents Tcl from aborting execution of script
#
#########################################################################
#/**
# * proc:  safeCopy
# * descr: 
# * @meta <list of searchable terms> 
# * @param src  
# * @param dst  
# */
proc safeCopy { src dst } {
   # attempt to copy and catch status of copy
   if { [catch {file copy -force -- $src $dst} fid] } {
       puts stderr "Could not copy $src to $dst\n$fid"
       writeLogFile "Could not copy $src to $dst\n$fid"
       flushLogFile
      return 0
   }
   return 1
}
#########################################################################
#
# proc for moving src to dst
#
# catches any error and prevents Tcl from aborting execution of script
#
#########################################################################
#/**
# * proc:  safeMove
# * descr: 
# * @meta <list of searchable terms> 
# * @param src  
# * @param dst  
# */
proc safeMove { src dst } {
   # attempt to copy and catch status of copy
   if { [catch {file copy -force -- $src $dst} fid] } {
      puts stderr "Could not copy $src to $dst\n$fid"
      writeLogFile "Could not copy $src to $dst\n$fid"
      flushLogFile
      return 0
   }
   # attempt to delete and catch status of deletion
   if { [catch {file delete -force -- $dst} fid] } {
      puts stderr "Could not delete $src\n$fid"
      writeLogFile "Could not delete $src\n$fid"
      flushLogFile
      return 0
   }   
   return 1
}

#########################################################################
#
# returns the name of the proc this proc is called from
#
#########################################################################
#/**
# * proc:  procName
# * descr: 
# * @meta <list of searchable terms> 
# */
proc procName {} {
   set trace [strace]
   set thisLevel [info level]
   # since trace is still sitting on the stack we have to go up two instead of one
   set upTwoLevels [expr $thisLevel - 2]
   set thisLevelName [lindex $trace $upTwoLevels]
   return $thisLevelName
}

#/**
# * proc:  dumpStack
# * descr: 
# * @meta <list of searchable terms> 
# */
proc dumpStack {} {
    set trace [strace]
    puts "Trace:"
    foreach t $trace {
        puts "* ${t}"
    }
}

#/**
# * proc:  strace
# * descr: 
# * @meta <list of searchable terms> 
# */
proc strace {} {
    set ret {}
    set r [catch {expr [info level] - 1} l]
    if {$r} { return {""} }
    while {$l > -1} {
        incr l -1
        lappend ret [info level $l]
    }
    return $ret
}

#/**
# * proc:  getScriptLocation
# * descr: 
# * @meta <list of searchable terms> 
# */
proc getScriptLocation {} {
   variable myLocation
   return [file dirname $myLocation]
}
#
# set paths to important places
#
variable tclLoc
variable custEdServer
# Removed by LR set java [getPathToJava]

##########################################################################
#
# proc isDigit character
#
# returns 0 if the character is not a digit, 1 otherwise
#
##########################################################################
#/**
# * proc:  isDigit
# * descr: 
# * @meta <list of searchable terms> 
# * @param c  
# */
proc isDigit {c} {
   if {[string length $c] == 0} { return 0; }
   set c [string range $c 0 1 ]
   if {$c>=0&$c<=9} { return 1 }
   return 0
}
##########################################################################
#
# proc extractIntegerFromString
#
# extracts all digits from within a string - 123ABC456 => 123456
#
##########################################################################
#/**
# * proc:  extractIntegerFromString
# * descr: 
# * @meta <list of searchable terms> 
# * @param s  
# */
proc extractIntegerFromString {s} {
   set integer ""
   for {set i 0} {$i < 10} {incr i} {
      set thisChar [string range $s $i [expr $i + 0]]
      if { [isDigit $thisChar] } { append integer $thisChar; }
   }
   return $integer
}
###########################################################################
#
# proc toHex decVal
#
###########################################################################
#/**
# * proc:  toHex
# * descr: 
# * @meta <list of searchable terms> 
# * @param decVal  
# */
proc toHex { decVal } {
   return [format 0x%x $decVal]
}
###########################################################################
#
# proc msSleep decVal
# - requires Tcl 8.4
###########################################################################
#/**
# * proc:  msSleep
# * descr: 
# * @meta <list of searchable terms> 
# * @param ms  
# */
proc msSleep { ms } {
     after $ms
 }
##########################################################################
#
# randName(length)
# creates a random string of length
#
###########################################################################
#/**
# * proc:  randName
# * descr: 
# * @meta <list of searchable terms> 
# * @param len  
# */
proc randName {len} {
   set retStr ""
   for {set i 0} {$i<$len} {incr i} {
      set value [expr int(rand()*127)]
      set char [format %c $value]   
      if {(($value >= 48) && ($value <=  57) && ($i > 0)) || 
          (($value >= 65) && ($value <=  90)) ||
           (($value >= 97) && ($value <= 122)) } {
          # this is a legal symbol and should be appended to the return string        
         append retStr $char
      } else {
        # this is an illegal symbol and should be skipped
        incr i -1;               
      } 
   }
   return $retStr;
 }
##########################################################################
#
# catonate (X Y)
# appends Y to X
#
###########################################################################
#/**
# * proc:  catonate
# * descr: 
# * @meta <list of searchable terms> 
# * @param x  
# * @param y  
# */
proc catonate {x y} { 
   set z ""
   append z $x $y
   return $z
} 
##########################################################################
#
# find7z - either returns the path to 7z including the executable nameor
#    dumps an error message to stdout and exits
#
###########################################################################
#/**
# * proc:  find7z
# * descr: 
# * @meta <list of searchable terms> 
# */
proc find7z {} {
   # point to the 7zip tool which may be called if there is unzipping to be done
   set zipTool [findFiles {c:/Program Files (x86)} 7z.exe 1];      # assumes default location
   if {[llength $zipTool] == 0} {
      set zipTool [findFiles {c:/Program Files} 7z.exe 1];         # assumes the other default location
   }     
   # was anything found?
   if {[llength $zipTool] == 1} {
      set zipToolExe [lindex $zipTool 0]
      return $zipToolExe
   } else {
      errorMsg "zipIt - could not locate 7 zip utility in the default installation site"
      exit 5
   }
}
##########################################################################
#
# zip srcDir destFile
#    srcDir is the directory path to where the things that are to be zipped are located
#    destFile is the file name ending in .7z that the files get zipped to
#
#    uses find7z to locate the zipTool/zip tool then attempts to zip srcDirName
#    into a zip file given by destFileName. 
#
###########################################################################
#/**
# * proc:  zipIt
# * descr: 
# * @meta <list of searchable terms> 
# * @param srcDirName  
# * @param destFileName  
# */
proc zipIt {srcDirName destFileName} {
   # point to the 7zip tool which may be called if there is unzipping to be done
   set zipTool [find7z]
   
   # confirm that the source is valid
   if {[isDirectory $srcDirName]} {
      exec $zipTool a -tzip $destFileName $srcDirName;           # zip it!
   } else {
      warningMsg "zipIt - source directory not found: $srcDirName"
   }
}
##########################################################################
#
# numberOfCPUs
#
#    identifies the number of processors available regardless of os 
#    stolen from: https://stackoverflow.com/questions/29482303/how-to-find-the-number-of-cpus-in-tcl
#
###########################################################################
#/**
# * proc:  numberOfCPUs
# * descr: 
# * @meta <list of searchable terms> 
# */
proc numberOfCPUs {} {
    # Windows puts it in an environment variable
    global tcl_platform env
    if {$tcl_platform(platform) eq "windows"} {
        return $env(NUMBER_OF_PROCESSORS)
    }

    # Check for sysctl (OSX, BSD)
    set sysctl [auto_execok "sysctl"]
    if {[llength $sysctl]} {
        if {![catch {exec {*}$sysctl -n "hw.ncpu"} cores]} {
            return $cores
        }
    }

    # Assume Linux, which has /proc/cpuinfo, but be careful
    if {![catch {open "/proc/cpuinfo"} f]} {
        set cores [regexp -all -line {^processor\s} [read $f]]
        close $f
        if {$cores > 0} {
            return $cores
        }
    }

    # No idea what the actual number of cores is; exhausted all our options
    # Fall back to returning 1; there must be at least that because we're running on it!
    return 1
}
##########################################################################
#
# militaryMonthName monthNumber
#    where monthNumber (1-12)
#    returns three letter month name
#
###########################################################################
#/**
# * proc:  militaryMonthName
# * descr: 
# * @meta <list of searchable terms> 
# * @param monthNumber  
# */
proc militaryMonthName {monthNumber} {
   switch $monthNumber {
      1  { return JAN }
      2  { return FEB }
      3  { return MAR }
      4  { return APR }
      5  { return MAY }
      6  { return JUN }
      7  { return JUL }
      8  { return AUG }
      9  { return SEP }
      10 { return OCT }
      11 { return NOV }
      12 { return DEC }
      default { return ???; }
   }  
}


# Note: does not display if run in quiet mode
variable helper_loaded 1
puts "Helper is $helper"
