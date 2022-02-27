param(
    [Parameter(Mandatory)]
    [int] $threshold
)

if(-not($threshold)) { 
    Throw “You must supply a value for -threshold” 
}

if($threshold -le 0) { 
    Throw “The value must be greater than 0.” 
}

$disks = Get-WmiObject Win32_LogicalDisk

$results = Foreach($disk in $disks) {
    $percentageFree = [math]::round(($disk.FreeSpace * 100)/$disk.Size)

    if ($percentageFree -lt $threshold) {

        $sizeGB = [math]::round($disk.Size/1GB)
        $freeGB = [math]::round($disk.FreeSpace/1GB)
        [PSCustomObject]@{
            DeviceID       = $disk.DeviceID
            Size           = $sizeGB
            "Free Space"   = $freeGB
        }
    }
}

$results | Format-Table -AutoSize