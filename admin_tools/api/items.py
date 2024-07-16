# -*- coding: utf-8 -*-
"""
Author       : ChenKui
Email        : kuichen1@lenovo.com
Version      : V1.0
CreateDate   : 2024/7/15 下午4:20 星期一
Project      : AdminTools
FilePath     : admin_tools/api_items
Description  : 
Copyright    : Copyright (c) 2024 ChenKui, All Rights Reserved.
"""
from fastapi import APIRouter, Body, HTTPException
from admin_tools.system.p404_active_script import *

router = APIRouter()


@router.get("/", summary="Get an item", description="Retrieve an item by its ID and an optional query parameter")
def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "q": q}


@router.post("/active_check", tags=['TeamPortal'], description="计划任务脚本状态自动汇总")
def create_item(body: ActiveCheck = Body(...)):
    try:
        exe_active_script_check(body.script_name, body.triggered, body.status, body.remarks)
        return True
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
