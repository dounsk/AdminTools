# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V0.1.0
CreateDate   : 1/17/2024 2:30 PM Wednesday
Project      : fastApiProject
FilePath     : scripts/generate_token
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import json
import jwt
from datetime import datetime, time, timedelta
from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from config.config import SECRET_KEY

TOKEN_EXPIRATION = timedelta(days=1)
security = HTTPBearer()


# 从本地 JSON 配置文件中读取权限表
def load_permissions_from_config(file_path: str) -> dict:
    with open(file_path, "r") as file:
        permissions_config = json.load(file)
    return permissions_config


# 根据用户名获取权限
def get_permissions_for_user(username: str, permissions_config: dict) -> list:
    return permissions_config.get(username, [])


def issue_token(username: str) -> dict:
    permissions_config = load_permissions_from_config("config/portal_permissions_config.json")
    user_permissions = get_permissions_for_user(username, permissions_config)
    # 如果在权限文件中没有找到用户的权限，则默认赋值为 "None"
    if not user_permissions:
        user_permissions = ["None"]
    token = generate_token(username, user_permissions)
    # expiration = datetime.now() + TOKEN_EXPIRATION
    # 控制 portal 在当天凌晨 token 过期
    last_minute_of_today = datetime.combine(datetime.now().date(), time.max) - timedelta(seconds=59)
    return {"token": token, "expired": last_minute_of_today, "permissions": user_permissions}


def generate_token(username: str, permissions: list) -> str:
    now = datetime.utcnow()
    # 颁发有效期为24小时的token
    expiration = now + TOKEN_EXPIRATION
    token_payload = {
        "iss": "https://biplatform.lenovo.com/api/access_token",
        "sub": username,
        "permissions": permissions,
        "iat": now,
        "exp": expiration,
        "ver": 1.0
    }
    token = jwt.encode(token_payload, SECRET_KEY, algorithm="HS256")
    return token


def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    if not token:
        raise HTTPException(status_code=403, detail="Token is missing")
    try:
        # jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        decoded_token = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        username = decoded_token["sub"]
        permissions = decoded_token.get("permissions", [])

        # 返回用户名和权限
        return {"username": username, "permissions": permissions}

    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=403, detail="Token has expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=403, detail="Invalid token")
