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
