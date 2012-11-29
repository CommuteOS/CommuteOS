This is intended to be run alongside the OS's shell, as an (unused) api, like so:

	os.loadAPI("fileService")
	parallel.waitForAll(function() fileService.serv() end, shell)
	
Where "shell" is a function containing all of your OS code, or at the very least, your shell code.

To send a file to other computers running CommuteOS, send a serialized table (textutils.serialize) that is formatted like so:
{"FILE", fileName, fileContents}

For example:

{"FILE", "email_1", "Hello world!"}

Prints are transmitted in nearly the same way:

{"PRINT", fileName, contents, title}

For example:

{"PRINT", "email_1", "Hello world!", "Email 1"}

Recieved files and prints are stored in "remoteFiles", which is made as necessary.
In addition, prints are stored in "remoteFiles/prints/", which, again, is made as necessary.

Our examples above would be stored in remoteFiles/email_1 and remoteFiles/prints/email_1 respectively.

Also, I've also made the "printFile" function global, in case anyone wants to use it. 
Call it like so:
fileService.printFile(side, path_to_file, print_title)

Regarding the print_title argument:
This function specifies the "title" to give to each page. Example:

	My Print (Page 1)
	My Print (Page 2)
	My Print (Page 3)
	My Print (Page 4)
	My Print (Page 5)
	...
	My Print (Page 11023)
	My Print (Page 11024)

By default, it is the file's name.
	
	rom/users/lua (Page 17)
	rom/users/lua (Page 18)
	rom/users/lua (Page 19)

However, it can be set to whatever you want:
	
	Secret Spy Report (Page 14)
	Secret Spy Report (Page 15)
	Secret Spy Report (Page 16)
