'''
Author       : Kui.Chen
Date         : 2023-03-20 16:18:32
LastEditors  : Kui.Chen
LastEditTime : 2023-03-20 16:52:26
FilePath     : \Scripts\Python\Tools\chat_openai.py
Description  : 
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import openai
import json

openai.api_key = "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"

def generate_response(prompt):
    response = openai.Completion.create(
      engine="text-davinci-002",
      prompt=prompt,
      max_tokens=2048,
      n=1,
      stop=None,
      temperature=0.5,
    )

    return response.choices[0].text.strip()

# Example usage
prompt = "使用python写一个获取日志文件的脚本"
response = generate_response(prompt)
print(response)

