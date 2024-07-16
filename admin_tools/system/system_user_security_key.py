# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V0.1.0
CreateDate   : 1/19/2024 11:47 AM Friday
Project      : fastApiProject
FilePath     : scripts/generate_user_security_key
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
import hashlib
import uuid
from config.config import GLOBAL_APPROVAL_CODE


def generate_key(username, approval_code):
    if approval_code in GLOBAL_APPROVAL_CODE:
        random_code = str(uuid.uuid4())
        user_security_key = hashlib.md5(random_code.encode('utf-8')).hexdigest()

        key_verification = hashlib.md5(user_security_key.encode('utf-8')).hexdigest()
        user_id = hashlib.md5(username.encode('utf-8')).hexdigest()
        file_path = f"./config/token/user_security_key_{user_id}"
        with open(file_path, "w") as security_key_file:
            security_key_file.write(key_verification)
        return {"message": "Successful",
                "detail": f"The user's private key has been successfully generated and notified {username}@lenovo.com by email"}
    else:
        return {"error": "Access Denied.", "detail": "Invalid Approval Code"}


def verify_key(username, input_security_key):
    hash_username = hashlib.md5(username.encode('utf-8')).hexdigest()
    file_path = f"./config/token/user_security_key_{hash_username}"
    with open(file_path, "r") as security_key_file:
        saved_security_key = security_key_file.read().strip()
    input_hash_security_key = hashlib.md5(input_security_key.encode('utf-8')).hexdigest()
    if saved_security_key == input_hash_security_key:
        return True
    else:
        return False
