<#
 Author: Kui.Chen
 Date: 2023-02-22 10:43:12
 LastEditors: Kui.Chen
 LastEditTime: 2023-02-22 10:45:32
 FilePath: \Scripts\Powershell\tools\GUI.ps1
 Description: 
 Copyright: Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
#>
# 创建一个GUI界面
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Powershell GUI"
$Form.Size = New-Object System.Drawing.Size(500,300)
$Form.StartPosition = "CenterScreen"
# 创建5个按钮
$Button1 = New-Object System.Windows.Forms.Button
$Button1.Location = New-Object System.Drawing.Size(175,20)
$Button1.Size = New-Object System.Drawing.Size(75,23)
$Button1.Text = "Button1"
$Button1.Add_Click({
    # 运行Button1脚本
    # 例如：
    .\Button1.ps1
})
$Button2 = New-Object System.Windows.Forms.Button
$Button2.Location = New-Object System.Drawing.Size(175,50)
$Button2.Size = New-Object System.Drawing.Size(75,23)
$Button2.Text = "Button2"
$Button2.Add_Click({
    # 运行Button2脚本
    # 例如：
    .\Button2.ps1
})
$Button3 = New-Object System.Windows.Forms.Button
$Button3.Location = New-Object System.Drawing.Size(175,80)
$Button3.Size = New-Object System.Drawing.Size(75,23)
$Button3.Text = "Button3"
$Button3.Add_Click({
    # 运行Button3脚本
    # 例如：
    .\Button3.ps1
})
$Button4 = New-Object System.Windows.Forms.Button
$Button4.Location = New-Object System.Drawing.Size(175,110)
$Button4.Size = New-Object System.Drawing.Size(75,23)
$Button4.Text = "Button4"
$Button4.Add_Click({
    # 运行Button4脚本
    # 例如：
    .\Button4.ps1
})
$Button5 = New-Object System.Windows.Forms.Button
$Button5.Location = New-Object System.Drawing.Size(175,140)
$Button5.Size = New-Object System.Drawing.Size(75,23)
$Button5.Text = "Button5"
$Button5.Add_Click({
    # 运行Button5脚本
    # 例如：
    .\Button5.ps1
})
# 将按钮添加到GUI界面
$Form.Controls.Add($Button1)
$Form.Controls.Add($Button2)
$Form.Controls.Add($Button3)
$Form.Controls.Add($Button4)
$Form.Controls.Add($Button5)
# 显示GUI界面
$Form.ShowDialog()