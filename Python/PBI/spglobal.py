# Given the client ID and tenant ID for an app registered in Azure,
# provide an Azure AD access token and a refresh token.

# If the caller is not already signed in to Azure, the caller's
# web browser will prompt the caller to sign in first.
# pip install msal
# import msal
# import sys
# Given the client ID and tenant ID for an app registered in Azure,
# provide an Azure AD access token and a refresh token.

# If the caller is not already signed in to Azure, the caller's
# web browser will prompt the caller to sign in first.
# pip install msal
# import msal
# import sys
# You can hard-code the registered app's client ID and tenant ID here,
# or you can provide them as command-line arguments to this script.
# scopes = [ 'https://analysis.windows.net/powerbi/api/.default' ]
# client_secret='KbQ8Q~pqoENQi6HyhnqA2fWNtqhaMCkCxrZkybvR'
# client_id = '5185160b-7c0a-49dc-84bc-abb8a60de46e'

# scopes = [ 'https://analysis.windows.net/powerbi/api/.default']

# client_secret='bUY8Q~tQRF1ixRI3U-PNIDsHMKsEmgknl3FR4cyn'
# client_id = '4b6bb6f4-abe6-4897-b06f-04d96d7bf342'

# tenant_id = '5c7d0b28-bdf8-410c-aa93-4df372b16203'

#global appcount 2

# client_id='5185160b-7c0a-49dc-84bc-abb8a60de46e'
# client_secret = '5Gc8Q~Tp5FoB25dZ2sN0GLm5zvRm3DfWEcWasad.'
# def getTokenspi():
#   app = msal.ConfidentialClientApplication(
#   client_id,
#   authority='https://login.microsoftonline.com/%s' % tenant_id,
#   client_credential=client_secret)

#   result = app.acquire_token_for_client(scopes=scopes)

#   print("gett token....from spi",result)
#   return result['access_token']


import msal

scopes = [ 'https://analysis.windows.net/powerbi/api/.default']
tenant_id = '5c7d0b28-bdf8-410c-aa93-4df372b16203'
client_id='5185160b-7c0a-49dc-84bc-abb8a60de46e'
client_secret = '5Gc8Q~Tp5FoB25dZ2sN0GLm5zvRm3DfWEcWasad.'

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