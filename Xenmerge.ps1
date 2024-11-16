# Powershell script to transfrom a XenMobile export (ManagedDevices) into a specific mail merge ready format.
# By doing this rather than a mass mail, user's recceived a personalised message just to them and this noticably improved their patching.
# The output from XenMobile device export .csv's was just awful. This script:
# 1. Unifies version numbers to be easily sorted
# 2. Recreates email addresses from firstname lastname domain values
# 3. Unifies date formats
# 4. Selects only devices that have authed in the last 30 days
# 5. And finally outputs a mail merge ready .csv
# Written by Luke Brown. 2022-11

$domain = ‘domain.com’
Import-Csv -Path '.\Managed Devices.csv' |
    Where-Object { $_.User -notlike "*Device Enrollment Program User*" -and $_.User -notlike "*anonymous*" } | 
        ForEach-Object {
        if ($_.('OS Version').Length -lt 5) {
            $_.('OS Version') = $_.('OS Version') + ('.0' * (5-$_.('OS Version').Length))
        }
       
        $name = ($_.User -split '"')[1]
        $_ | Add-Member -MemberType NoteProperty -Name "Name" -Value $name -PassThru |
            Add-Member -MemberType NoteProperty -Name "FirstName" -Value ($name -split ', ')[1] -PassThru |
            Add-Member -MemberType NoteProperty -Name "Email" -Value ($name.Split(',')[1].Trim() + '.' + $name.Split(',')[0].Trim() + $domain) -PassThru
    } |
 
    Where-Object { [datetime]::ParseExact($_.'Last Auth Date', 'M/d/yy h:mm tt', $null) -ge (Get-Date).AddDays(-30) } |
    Select-Object Email, FirstName, Name, Model, 'OS Version', @{Name="DateFormatted";Expression={[datetime]::ParseExact($_.'Last Auth Date', 'M/d/yy h:mm tt', $null).ToString("yyyy/MM/dd")}} |
    Sort-Object DateFormatted |
    Export-Csv -Path '.\readytomerge.csv' -NoTypeInformation
