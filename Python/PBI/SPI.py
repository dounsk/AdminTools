'''
Author       : Kui.Chen
Date         : 2023-08-10 15:16:00
LastEditors  : Kui.Chen
LastEditTime : 2023-08-11 16:15:41
FilePath     : \PBI\SPI.py
Description  : 
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
# Given the client ID and tenant ID for an app registered in Azure,
# provide an Azure AD access token and a refresh token.

# If the caller is not already signed in to Azure, the caller's
# web browser will prompt the caller to sign in first.
# pip install msal
# import msal
# import sys

# You can hard-code the registered app's client ID and tenant ID here,
# or you can provide them as command-line arguments to this script.
# client_secret='-U88.eW5XTUsFW11KXB0b5~76wYp_.nIAD'client_secret='947R16.-8bTk5.-64kCpoHpFLxca_2dT~Y'
# client_secret='1IeuLxEn.-d-sM1X3EjksN546Im-~LVd2U'
# tenant_id = 'a6c1b34e-d17f-48de-83b8-8e248b0f0360'
# client_id='593510d4-cf8b-4a3f-a206-f53381991cd6'
# -d 'grant_type=client_credentials' \
# -d 'scope=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d%2F.default' \
# -d 'client_secret=abc1D~Ef...2ghIJKlM3'
# Do not modify this variable. It represents the programmatic ID for
# Azure Databricks along with the default scope of '/.default'.
# scopes = [ 'https://analysis.chinacloudapi.cn/powerbi/api/.default' ]

# def getTokenspi():
#   app = msal.ConfidentialClientApplication(
#   client_id,
#   authority='https://login.partner.microsoftonline.cn/%s' % tenant_id,
#   client_credential=client_secret)

#   result = app.acquire_token_for_client(scopes=scopes)

#   print("gett token....from spi",result)
#   return result['access_token']


import msal
scopes = [ 'https://analysis.chinacloudapi.cn/powerbi/api/.default' ]
client_secret='1IeuLxEn.-d-sM1X3EjksN546Im-~LVd2U'
tenant_id = 'a6c1b34e-d17f-48de-83b8-8e248b0f0360'
client_id='593510d4-cf8b-4a3f-a206-f53381991cd6'
def getTokenspi():
    """
    获取 SPI 的访问令牌
    """
    app = msal.ConfidentialClientApplication(
        client_id,
        authority='https://login.microsoftonline.com/%s' % tenant_id,
        client_credential=client_secret
    )
    result = app.acquire_token_for_client(scopes=scopes)
    print("Getting token from SPI:", result)
    return result['access_token']
