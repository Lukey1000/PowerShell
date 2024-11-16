#SCript Author: Luke Brown
function Get-FileHashes {                                                                                     
     param (
         [Parameter(Mandatory=$true)]
         [string]$Directory
     )

     $files = Get-ChildItem -Path $Directory -File

     $hashes = @()
     foreach ($file in $files) {
         $sha1 = Get-FileHash -Path $file.FullName -Algorithm SHA1 | Select-Object -ExpandProperty Hash
         $md5 = Get-FileHash -Path $file.FullName -Algorithm MD5 | Select-Object -ExpandProperty Hash
         $hashResult = [PSCustomObject]@{
             "FileName" = $file.Name
             "SHA1"     = $sha1
             "MD5"      = $md5
         }

         $hashes += $hashResult
     }

     $hashes | Format-Table -AutoSize
 }
