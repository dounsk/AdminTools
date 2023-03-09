import smtplib
from email.mime.text import MIMEText


def __init__(self, logo_url, date, ip, cpu, ram, service_names, service_status, logs, disclaimer):
    self.logo_url = logo_url
    self.date = date
    self.ip = ip
    self.cpu = cpu
    self.ram = ram
    self.service_names = service_names
    self.service_status = service_status
    self.logs = logs
    self.disclaimer = disclaimer

def to_html(self):
    html = """<html>
    <head>
        <style>
        table, th, td {{
            border: 1px solid black;
            border-collapse: collapse;
            padding: 5px;
        }}
        </style>
    </head>
    <body>
        <div align="center">
            <img src="{logo_url}" width="100">
        </div>
    
        <h1>NEWSLETTER</h1>
        <h3>Date: {date}</h3>
    
        <p>This is the Newsletter of the day. The following information is provided.</p>
    
        <h3>Summary</h3>
        <ul>
            <li>IP, CPU and RAM usage</li>
            <li>Service Status</li>
            <li>Logs</li>
        </ul>
    
    <h3> IP, CPU and RAM usage </h3>
        <p>The IP, CPU and RAM usage are as follows:</p>
        <table>
        <tr>
            <th>Description</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>IP</td>
            <td>{ip}</td>
        </tr>
        <tr>
            <td>CPU</td>
            <td>{cpu}</td>
        </tr>
        <tr>
            <td>RAM</td>
            <td>{ram}</td>
        </tr>
        </table>
    
        <h3>Service Status</h3>
        <p>The following is the Service Status:</p>
        <table>
        <tr>
            <th>Service</th>
            <th>Status</th>
        </tr>
        """.format(logo_url=self.logo_url,
                    date=self.date,
                    ip=self.ip,
                    cpu=self.cpu,
                    ram=self.ram)

    for service_name, service_status in zip(self.service_names, self.service_status):
        html += """
        <tr>
            <td>{service_name}</td>
            <td>{service_status}</td>
        </tr>
        """.format(service_name=service_name,
                    service_status=service_status)

    html += """
        </table>
    
        <h3>Logs</h3>
        <p>The following is the Logs:</p>
        <ul>
        """
    for log in self.logs:
        html += """
            <li>{log}</li>
        """.format(log=log)
        
    html += """
        </ul>
        <p>Disclaimer: {disclaimer}</p>
    </body>
    </html>
    """.format(disclaimer=self.disclaimer)
    
    return html
    
def smtp_sendemail(mail_to, subject, content):
    msg = MIMEText(content, 'html')
    msg['From'] = 'noreply@8088.onmicrosoft.com'
    msg['To'] = mail_to
    msg['Subject'] = subject

    server = smtplib.SMTP('smtp.office365.com', 587)
    server.starttls() 
    server.login('noreply@8088.onmicrosoft.com', 'KFCrazy4V50ToMe')
    server.sendmail('noreply@8088.onmicrosoft.com',mail_to, msg.as_string())
    server.quit()

mail_to = 'dounsk@outlook.com'
subject = 'Mail TEST Info '

if __name__ == '__main__':
    smtp_sendemail(mail_to, subject, to_html())
    print('The email was sent successfully')