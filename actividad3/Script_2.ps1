$currentDate = Get-Date -uformat "%Y%m%d"

Get-ChildItem -File -Filter *.jpg | Rename-Item -NewName {$currentDate + '-' + $_.Name }