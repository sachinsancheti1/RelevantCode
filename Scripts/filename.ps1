gci -rec -file|%{"$($_.Fullname)`t$($_.LastWriteTime)`t$($_.Length)"} >filelist-sachin-share-0.txt
gci -R . | where { $_.PSISContainer -and @( $_ | gci ).Count -eq 0 } | ri