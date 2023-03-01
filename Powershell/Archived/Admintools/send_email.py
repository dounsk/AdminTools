import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


class SendMail(object):

    @staticmethod
    def get_message():
        message = MIMEMultipart()
        message['From'] = mail_set['sender']
        message['To'] = ';'.join(mail_set['receivers'])
        message['Subject'] = '⚠ [' + mail_set[
            'action'] + ']' + mail_set['IP'] +' QS Service Maintenance Is Triggered'
        return message

    @staticmethod
    def get_att(file):
        with open(file, 'r', encoding='utf-16') as rs:
            attach = rs.read()
        attach = MIMEText(attach, 'base64', 'utf-8')
        attach['Content-Type'] = 'application/octet-stream'
        attach['Content-Disposition'] = 'attachment; filename=' + os.path.basename(file)
        return attach

    def get_content(self):
        message = self.get_message()
        # 邮件正文
        content = MIMEText(' ' + '\n' +
                           mail_set['info'] + '\n'
                           )
        message.attach(content)
        message.attach(self.get_att(mail_set['file']))
        return message

    def run(self):
        message = self.get_content()
        try:
            smtp_obj = smtplib.SMTP(mail_set['host'])
            smtp_obj.connect(mail_set['host'], 25)
            smtp_obj.ehlo()
            smtp_obj.starttls()
            smtp_obj.login(mail_set['sender'], mail_set['pwd'])
            smtp_obj.sendmail(mail_set['sender'],
                              mail_set['receivers'],
                              message.as_string())
            print('Successfully!')
        except smtplib.SMTPException as e:
            print('Failed，Error：{}'.format(e))


if __name__ == '__main__':
    file_path = r'\\SYPQLIKSENSE14\ServiceHealthCheck\Qlik_SERVICE_WARNING.txt'
    # file_path = r'D:\TOT\Qlik_SERVICE_WARNING.txt'
    with open(file_path, 'r', encoding='utf-16') as rs:
        data = rs.read()
        IP, action = data.split('\n')[-3:-1]
        info = data.split('\n')[0]

    mail_set = {
        "host": "Smtpinternal.lenovo.com",
        "pwd": 'ZAQ1xsw2-',
        "sender": "qlikplatform@lenovo.com",
        # "receivers": ['zhangzh42@lenovo.com','kuichen1@lenovo.com', ], #TEST
        #"receivers": ['Maxx1@lenovo.com', 'kuichen1@lenovo.com', 'zhangzh42@lenovo.com', 'qlikplatform@lenovo.com', ],
        "file": file_path,
        'IP': IP,
        'action': action,
        'info': info
    }

    app = SendMail()
    app.run()
