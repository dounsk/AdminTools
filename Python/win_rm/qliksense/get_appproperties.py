
import json
import websocket

api_cfg = {
    'URLS': 'wss://10.122.36.110:4747/app/',
    'm_XrfKey': '0123456789abcdef',
    'SERVER': {
        'header': {'X-Qlik-User': 'UserDirectory=INTERNAL; UserId=sa_scheduler'},
        'sslopt':
            {
                'ca_certs': '/home/kuii/scripts/Python/Data/sypqliksense14/root.pem',
                'certfile': '/home/kuii/scripts/Python/Data/sypqliksense14/client.pem',
                'keyfile': '/home/kuii/scripts/Python/Data/sypqliksense14/client_key.pem',
                'check_hostname': False
            }
    }
}

def engine_api_getinfo(app_id):
    app = [app_id]
    ws = websocket.create_connection(api_cfg['URLS'], timeout=300, **api_cfg['SERVER'])
    ws.recv()
    req1 = {
        "jsonrpc": "2.0",
        "id": 0,
        "method": "OpenDoc",
        "handle": -1,
        "params": [app_id]
    }
    try:
        ws.send(json.dumps(req1))
        ret = ws.recv()
        _ = json.loads(ret)
    except Exception as e:
        print('step1 error: ', e)
    req2 = {
        "jsonrpc": "2.0",
        "id": 3,
        "method": "GetAppProperties",
        "handle": 1,
        "params": []
    }
    try:
        ws.send(json.dumps(req2))
        ret = ws.recv()
        table_jsons = json.loads(ret)
        print(table_jsons)
    except Exception as e:
        print('step2 error: ', e)
        ws.abort()
        return [[app_id, 'error: Access denied', ''], ]

if __name__ == '__main__':
    appid = "7dc82186-e13a-4089-a59a-2bfb3a73812b"
    engine_api_getinfo(appid)
