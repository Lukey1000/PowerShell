# Script Author: Luke Brown
# Script Last Working: November 2024
# This quickly decoded a base64 encoded, gzip compressed, powershell command string that turned out to be PowerView.
#Usage
#$base64string = ""
#Inspect-EncodedCompressed -EncodedContent $base64string

function Inspect-EncodedCompressed {
    param (
        [string]$EncodedContent
    )
    
    try {
        $bytes = [System.Convert]::FromBase64String($EncodedContent)
        $memStream = [System.IO.MemoryStream]::new($bytes)
        $gzipStream = [System.IO.Compression.GzipStream]::new($memStream, [System.IO.Compression.CompressionMode]::Decompress)
        $reader = [System.IO.StreamReader]::new($gzipStream)
        $decodedContent = $reader.ReadToEnd()
        $reader.Dispose()
        $gzipStream.Dispose()
        $memStream.Dispose()
        $decodedContent | out-file decodedcontent
        
        return @"
Input length: $($EncodedContent.Length)
First 100 chars: $($decodedContent.Substring(0, [Math]::Min(100, $DecodedContent.Length)))
Last 100 chars: $($decodedContent.Substring([Math]::Max(0, $decodedContent.Length - 100), [Math]::Min(100, $decodedContent.Length)))
"@
    }
    catch {
        return @"
Error decoding content: $_
Debug Info:
Input length: $($EncodedContent.Length)
First 100 chars: $($EncodedContent.Substring(0, [Math]::Min(100, $EncodedContent.Length)))
Last 100 chars: $($EncodedContent.Substring([Math]::Max(0, $EncodedContent.Length - 100), [Math]::Min(100, $EncodedContent.Length)))

"@
    }
}

