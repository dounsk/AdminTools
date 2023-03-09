import smtplib
from email.mime.text import MIMEText

# SMTP Email
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

email_template = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>{title}</title>
</head>
<body>
    <table cellpadding="0" cellspacing="0" border="0" align="center" width="600" style="font-family: Arial, sans-serif; font-size: 14px; color: #333;">
        <tr>
            <td align="center" style="background-color: #f5f5f5; padding: 20px;">
                <img src="{logo}" alt="logo" width="100" height="100">
                <h1 style="margin-top: 20px;">{heading}</h1>
            </td>
        </tr>
        <tr>
            <td style="background-color: #ffffff; padding: 20px;">
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td style="border-bottom: 1px solid #cccccc; padding-bottom: 10px;">
                            <h2>{title1}</h2>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top: 10px;">
                            <p>{description1}</p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top: 20px; border-bottom: 1px solid #cccccc; padding-bottom: 10px;">
                            <h2>{title2}</h2>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top: 10px;">
                            <p>{description2}</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td align="center" style="background-color: #f5f5f5; padding: 20px;">
                <img src="{image}" alt="image" width="400" height="200">
            </td>
        </tr>
    </table>
</body>
</html>
'''

# 使用示例
email_content = email_template.format(
    title="我是标题哈哈哈",
    logo="D:\OneDrive - 8088\Scripts\Python\Data\logo.png",
    heading="邮件标题",
    title1="表格一",
    description1="这里是表格一的描述",
    title2="表格二",
    description2="这里是表格二的描述",
    image="D:\OneDrive - 8088\Scripts\Python\Data\logo.png"
)

mail_to = 'dounsk@outlook.com'
subject = 'Mail TEST Info '

if __name__ == '__main__':
    smtp_sendemail(mail_to, subject, email_content)
    print('The email was sent successfully')