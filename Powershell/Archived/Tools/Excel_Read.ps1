﻿$excel = New-Object -ComObject Excel.Application
# open Excel file
$workbook = $excel.Workbooks.Open("C:\Users\douns\Downloads\temp\excelfile.xlsx")

# uncomment next line to make Excel visible
#$excel.Visible = $true

$sheet = $workbook.ActiveSheet
$column = 1
$row = 1
$info = $sheet.cells.Item($column, $row).Text
$excel.Quit()


"Cell A1 contained '$info'"