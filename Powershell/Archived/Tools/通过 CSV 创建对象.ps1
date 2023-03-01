$text = 'Name,FirstName,Location
Weltner,Tobias,Germany
Nikolic,Aleksandar,Serbia
Snover,Jeffrey,USA
Special,ÄÖÜß,Test'

$objects = $text | ConvertFrom-Csv

$objects | Out-GridView