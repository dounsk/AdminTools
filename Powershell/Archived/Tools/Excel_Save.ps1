$excel = New-Object -ComObject Excel.Application
# open Excel file
$workbook = $excel.Workbooks.Open("C:\Users\douns\Downloads\temp\excelfile.xlsx")

# uncomment next line to make Excel visible
#$excel.Visible = $true

$sheet = $workbook.ActiveSheet
$column = 1
$row = 1
# change content of Excel cell
$sheet.cells.Item($column,$row) = "wojiushishui?"
# save changes
$workbook.Save()
$excel.Quit()