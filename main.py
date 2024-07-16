# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 2024/7/15 下午4:17 星期一
Project      : AdminTools
FilePath     : /main
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
from fastapi import FastAPI
from admin_tools.api.items import router as items_router

app = FastAPI()

app.include_router(items_router, prefix="/items/{item_id}")


@app.get("/")
def read_root():
    return {"Hello": "World"}
