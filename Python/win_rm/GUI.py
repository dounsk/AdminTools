'''
Author       : Kui.Chen
Date         : 2023-03-06 15:33:28
LastEditors  : Kui.Chen
LastEditTime : 2023-03-06 15:33:45
FilePath     : \Scripts\Python\win_rm\GUI.py
Description  : 创建python gui 获取远程服务器状态 并选择运行维护脚本
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import tkinter as tk
# import subprocess
import winrm

class ServerStatus:
    def __init__(self, master):
        self.master = master
        master.title("Server Status")

        # 设置GUI窗口大小
        master.geometry("1024x768")

        # 展示logo
        self.logo = tk.PhotoImage(file="Python\Data\logo.png")
        self.logo_label = tk.Label(master, image=self.logo)
        self.logo_label.pack()

        # 创建左侧集群机器名列表
        self.machine_listbox = tk.Listbox(master)
        self.machine_listbox.pack(side=tk.LEFT, fill=tk.BOTH)

        self.populate_machine_listbox()

        # 创建右侧的服务器状态显示区域
        self.status_frame = tk.Frame(master)
        self.status_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

        self.status_label = tk.Label(self.status_frame, text="Select a machine to view its status")
        self.status_label.pack(pady=50)

        # 创建维护脚本运行按钮
        self.run_script_button1 = tk.Button(self.status_frame, text="Run Script 1", command=lambda: self.run_maintenance_script("Python\Data\get\script1.ps1"))
        self.run_script_button1.pack(pady=10)

        self.run_script_button2 = tk.Button(self.status_frame, text="Run Script 2", command=lambda: self.run_maintenance_script("Python\Data\get\script1.ps1"))
        self.run_script_button2.pack(pady=10)

        self.run_script_button3 = tk.Button(self.status_frame, text="Run Script 3", command=lambda: self.run_maintenance_script("Python\Data\get\script1.ps1"))
        self.run_script_button3.pack(pady=10)

        self.run_script_button4 = tk.Button(self.status_frame, text="Run Script 4", command=lambda: self.run_maintenance_script("Python\Data\get\script1.ps1"))
        self.run_script_button4.pack(pady=10)

    def populate_machine_listbox(self):
        # Add the names of the machines to the listbox
        self.machine_listbox.insert(tk.END, 'PEKWPQLIK03')
        self.machine_listbox.insert(tk.END, 'PEKWPQLIK04')
        self.machine_listbox.insert(tk.END, 'PEKWPQLIK05')

        # Bind the listbox to the show_status method
        self.machine_listbox.bind("<<ListboxSelect>>", self.show_status)

    def show_status(self, event):
        # Get the selected machine from the listbox
        selected_machine = self.machine_listbox.get(tk.ACTIVE)

        # Display the status of the selected machine
        # self.status_label.configure(text="Status of " + selected_machine + ":\n\n" + self.get_machine_status(selected_machine))
        self.status_label.configure(text="Status of " + selected_machine + ":\n\n" + str(self.get_machine_status(selected_machine)))

    def get_machine_status(self, machine_name):
        # Get the status of the machine by running a command in the terminal
        session = winrm.Session('http://'+machine_name+':5985/wsman', auth=('tableau', 'wixj-2342'), transport = 'ntlm', server_cert_validation = 'ignore')
        result = session.run_ps('systeminfo | findstr /c:"OS Name" /c:"OS Version" /c:"OS Configuration" /c:"OS Build" /c:"System Type" /c:"Hotfix(s)" /c:"Available Physical Memory" /c:"Total Physical Memory" /c:"Domain"')
        return result.std_out.decode("utf-8")
        

    def run_maintenance_script(self, script_name):
        # Get the selected machine from the listbox
        selected_machine = self.machine_listbox.get(tk.ACTIVE)

        # Run a maintenance script on the selected machine
        session = winrm.Session('http://'+selected_machine+':5985/wsman', auth=('tableau', 'wixj-2342'), transport = 'ntlm', server_cert_validation = 'ignore')
        with open(script_name, 'r') as f:
            script_contents = f.read()
        result = session.run_ps(script_contents)
        print(result.std_out)

root = tk.Tk()
app = ServerStatus(root)
root.mainloop()