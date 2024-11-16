# Script Author: Luke Brown
$privtocheck = 'SeCreateGlobalPrivilege'
$result = Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Services" |
    Where-Object { $_.PSIsContainer } |
    ForEach-Object {
        $requiredPrivileges = $_.GetValue('RequiredPrivileges')
        if ($null -ne $requiredPrivileges) {
            $privileges = $requiredPrivileges -split '\r\n'
            if ($privileges -contains $privtocheck) {
                [PSCustomObject]@{
                    Service = $_.PSChildName
                    RequiredPrivileges = $privileges -join ', '
                }
            }
        }
    }

$count = $result | Measure-Object | Select-Object -ExpandProperty Count

Write-Host "Number of services with $privtocheck`: $count"
Write-Host ""
$result | Format-Table -AutoSize
