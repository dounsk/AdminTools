# -*- coding: utf-8 -*-
import os
import re
import threading
from queue import Queue
import requests
from lxml import etree
from urllib import parse

def choose():
    search = int(input("请输入壁纸查询方式 1·····类别模糊查询||2·····关键词查询"))
    if search == 1:
        category = "https://wall.alphacoders.com/by_category.php?id="
        print("[INFO]下面是序号所对应的壁纸类别：\n"
              "  1·····抽象   2·····动物   3·····动漫   4·····艺术   7·····名人   8·····漫画\n"
              "  9·····黑暗  10·····自然  11·····奇幻  12·····食物  13·····幽默  14·····游戏\n"
              " 15·····节日  16·····人造  17·····人类  18·····军事  19·····综合  20·····电影\n"
              " 22·····音乐  24·····摄影  25·····产品  26·····宗教  27·····科幻  28·····运动\n"
              " 29·····电视  30·····技术  31·····座驾  32·····游戏  33·····女性  34·····武器")
        category_id = int(input("请输入你想爬取的壁纸类别序号："))
        # 判断用户输入的数据是否正确
        while True:
            if category_id in range(1, 35):
                break
            else:
                print("看清楚提示，哈麻皮！！！")
                category_id = int(input("请输入你想爬取的壁纸类别序号："))
        name=category_name(category_id)
        print("你选择的类别是%s" % name)
        category_url = category + str(category_id) + "&lang=Chinese"
        print(category_url)
        return category_url,name
    elif search == 2:
        search_ = "https://wall.alphacoders.com/search.php?search="
        key = input("输入你要获取的壁纸关键字：")
        key_ = parse.quote(key)
        search_url = search_ + key_ + "&lang=Chinese"
        print(search_url)
        return search_url,key
    else:
        print("看清楚提示，哈麻皮！！！")
def category_name(name):
    if name == 1:
        category_name='抽象'
        return category_name
    if name == 2:
        category_name= '动物'
        return category_name
    if name == 3:
        category_name=  '动漫'
        return category_name
    if name == 4:
        category_name=  '艺术'
        return category_name
    if name == 5:
        category_name=  '名人'
        return category_name
    if name == 6:
        category_name=  '漫画'
        return category_name
    if name == 7:
        category_name=  '黑暗'
        return category_name
    if name == 8:
        category_name=  '自然'
        return category_name
    if name == 9:
        category_name=  '奇幻'
        return category_name
    if name == 10:
        category_name=  '食物'
        return category_name
    if name == 11:
        category_name=  '游戏'
        return category_name
    if name == 12:
        category_name=  '节日'
        return category_name
    if name == 13:
        category_name=  '幽默'
        return category_name
    if name == 14:
        category_name=  '人造'
        return category_name
    if name == 15:
        category_name=  '人局'
        return category_name
    if name == 16:
        category_name=  '军事'
        return category_name
    if name == 17:
        category_name=  '综合'
        return category_name
    if name == 18:
        category_name=  '电影'
        return category_name
    if name == 19:
        category_name=  '音乐'
        return category_name
    if name == 20:
        category_name=  '摄影'
        return category_name
    if name == 21:
        category_name=  '产品'
        return category_name
    if name == 22:
        category_name=  '宗教'
        return category_name
    if name == 23:
        category_name=  '科幻'
        return category_name
    if name == 24:
        category_name=  '运动'
        return category_name
    if name == 25:
        category_name=  '艺术'
        return category_name
    if name == 26:
        category_name=  '电视'
        return category_name
    if name == 27:
        category_name=  '座驾'
        return category_name
    if name == 28:
        category_name=  '游戏'
        return category_name
    if name == 29:
        category_name=  '武器'
        return category_name
    if name == 30:
        category_name=  '女性'
        return category_name
    
class GetImgUrl(threading.Thread):
    def __init__(self,PageQueue,ImgQueue):
        super(GetImgUrl, self).__init__()
        self.PageQueue=PageQueue
        self.ImgQueue=ImgQueue
        self.headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36'}
    def run(self):
        while True:
            # if self.ImgQueue.empty():
            #     break
            #从队列中获取一个数据
            page_url=self.PageQueue.get()
            print(page_url)
            self.parse(page_url)
    def parse(self,page_url):
        response=requests.get(page_url,headers=self.headers)
        #获取重定向后的链接
        url=response.url
        html=requests.get(url,headers=self.headers).text
        html=etree.HTML(html)
        img_list=html.xpath('//div[@class="boxgrid"]')
        for img in img_list:
            title=img.xpath("./a/@href")[0]
            '''
                 这里的xpath是定位到class=boxgrid 然后定位到img
                 浏览器能看到数据，解析却不行，直接输出etree.HTML()后的源码发现
                 这个网站有很多"语法错误"，许多标签没有</*>表示结束，例如<source> 导致解析的路径和Chrome浏览器获取的路径不一样
                 离谱呀
            '''
            src = img.xpath("./a/picture/source/source/source/img/@src")[0]
            # 匹配不是数字的其他字符
            drop = re.compile("[^0-9]")
            # 将中匹配到的字符替换成空字符
            title = drop.sub('', title)
            #获取高清图片链接 这里直接把 thumbbig- 替换为空就得到链接
            src=src.replace('thumbbig-','')
            #获取图片格式
            suffix = os.path.splitext(src)[1]
            #最后的文件名
            filename=str(title)+suffix
            #存到队列
            self.ImgQueue.put((filename,src))
class DownloadImg(threading.Thread):
    def __init__(self,ImgQueue,name):
        super(DownloadImg, self).__init__()
        self.ImgQueue = ImgQueue
        self.name=name
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36'}
    def run(self):
        while True:
            #获取一个数据
            filename,img=self.ImgQueue.get()
            self.Dwonload(filename,img)
    def Dwonload(self,filename,img):
        try:
            resp = requests.get(img, headers=self.headers)
            if resp.status_code!=200:
                print("恭喜你请求失败了！！！"%resp.status_code)
            #设置保存路径 +选择的壁纸类别+文件名为图片id
            path='./py/PNG/Wallpaper/'+self.name+'/'
            #如果目录不存在则创建目录
            if not os.path.exists(path):
                os.makedirs(path)
            with open(path+ filename, 'wb') as file:
                file.write(resp.content)
                print('[INFO] 保存%s成功' % filename)
        except Exception as e:
            print(e)
            print('[INFO]保存失败的图片地址:%s '%img)
def main():
    #choose()函数的返回值是用户选择的图片检索方式对应的链接 返回值是一个元组类型 (url,name)
    tuple_=choose()
    url=tuple_[0]
    name=tuple_[1]
    #创建页面链接队列和图片链接队列
    PageQueue=Queue(100)
    ImgQueue=Queue(1000)
    start=int(input("输入开始页数："))
    end=int(input("输入结束页数："))
    for i in range(start,end):
        page_url=url+'&page='+str(i)
        #存到队列
        PageQueue.put(page_url)
    #设置线程数量
    for i in range(5):
        t1=GetImgUrl(PageQueue,ImgQueue)
        t1.start()
    for i in range(5):
        t2=DownloadImg(ImgQueue,name)
        t2.start()
if __name__ == '__main__':
    main()