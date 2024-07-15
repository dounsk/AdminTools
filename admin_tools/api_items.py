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
from fastapi import APIRouter

router = APIRouter()


@router.get("/", summary="Get an item", description="Retrieve an item by its ID and an optional query parameter")
def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "q": q}
