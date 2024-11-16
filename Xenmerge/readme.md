Powershell script to transfrom a XenMobile export (ManagedDevices) into a specific mail merge ready format.
By doing this rather than a mass mail, user's received a personalised message just to them and this noticably improved their patching.
The output from XenMobile device export .csv's was just awful. This script:
1. Unifies version numbers to be easily sorted
2. Recreates email addresses from firstname lastname domain values
3. Unifies date formats
4. Selects only devices that have authed in the last 30 days
5. And finally outputs a mail merge ready .csv
