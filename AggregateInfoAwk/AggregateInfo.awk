# $1 ==> file permissions
# $2 ==> links to the specified area
# $3 ==> owner
# $4 ==> group
# $5 ==> file size in bytes
# $6 ==> date last modified
# $7 ==> last modified timestamp
# $8 ==> file name

#BEGIN block initializes all the sum/loop/time related variables
BEGIN { ownerSum = 0; x = 0; fileSum = 0; hidSum = 0; dirSum = 0; byteSum = 0; otherSum = 0; oldestTime = 0; newestTime = 0; timestamp = 0; } 

#skips unnecessary lines if there are any
NF < 8 { next }
NR < 4 { next }


#main contents
{
	#creates array of users if it is a new unique user that hasn't already been read in
        if(!($3 in usr)){
            #i is number of users
            usr[$3];
            ownerSum++; #increments total number of users found
        }
        

        #Case for if it is a directory
        if(match($1, /^d/)){
            #counts total number of directories to display at the end
            dirCount[$3]++;
            dirSum++; #increments number of directories found
	    
        }
        
	#Case for if it is a normal file
        if(match($1, /^-/)){
            
	    #increments total number of bytes stored in each regular file 
            bytesStor[$3] += $5;
            allFiles[$3]++;   #increments number of files for the particular user
            fileSum++;	      #increments total number of files to display at the end
            byteSum+=$5;      #increments total number of bytes stored to display at the end
      	    
	    #grabs 6th and 7th field to combine into the date + timestamp
	    timestamp = $6 $7;
	#code block below determines the newest and oldest file from input
		if(timestamp <= newestTime){
                	oldFile = $0; #grabs the whole line and saves it as the oldest file
                	oldestTime = timestamp;
	        }

        	else{
                	newFile = $0; #grabs the whole line and saves it as the newest file
                	newestTime = timestamp;
        	}
	
	 }
        
        #Case for if it is a hidden file 
        if(match($8, /^\./) && match($1, /^-/)){
            #counts number of hidden files for the particular user
	    hiddenCount[$3]++;
	    #counts total number of hidden files to display at the end
            hidSum++;
        }
       
	#Case for if it is a file of type "other"
        if(match($1, /^[^-d]/)){
            #counts number of other files for the particular user
            otherFiles[$3]++;
	    #counts total number of other files to display at the end
            otherSum++;
        }
       
        
}
    

END {
    #prints file information per user/owner
    for(x in usr){
        printf("Username: %s\n", x);
        if(allFiles[x] > 0) {     #only print this information if there are more than 0 files
            printf("     Files: \n");
            printf("          All: %d\n", allFiles[x]);
            printf("          Hidden: %d\n", hiddenCount[x]);
        }
        if(dirCount[x] > 0){      #only print this information if there are more than 0 directories
            printf("          Directories: %d\n", dirCount[x]);
        }
        if(otherFiles[x] > 0){    #only print this information if there are more than 0 "other" files
            printf("          Others: %d\n", otherFiles[x]);
        }
        if(bytesStor[x] > 0){     #only print this information if there are more than 0 bytes stored for this user
            printf("          Storage (B): %d bytes\n", bytesStor[x]);
        }
        printf("\n");
    }

    #prints oldest and newest file found in the input
    printf("Oldest file: \n");
    printf("    %s\n", oldFile);
    printf("Newest file: \n");
    printf("    %s", newFile);

    printf("\n\n"); 

    #prints information for total number of users, files, etc.
    printf("Total users:          %d\n", ownerSum);
	printf("Total files: \n");
	printf("   (All / Hidden):      ( %d / %d )\n", fileSum, hidSum);
	printf("Total directories:     %d\n", dirSum);
	printf("Total others:          %d\n", otherSum);
	printf("Storage (B):          %d bytes\n", byteSum);
}

