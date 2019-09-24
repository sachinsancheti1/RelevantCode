
cd 'F:\Google Drive\'
gci -rec -file|%{"$($_.Fullname)`t$($_.LastWriteTime)`t$($_.Length)"} >filelist.txt