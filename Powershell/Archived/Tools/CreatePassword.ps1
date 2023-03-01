$Length = 12
$characters = 'abcdefghkmnprstuvwxyz23456789§$%&?*+#'
$password = -join ($characters.ToCharArray() |
Get-Random -Count $Length)

$password