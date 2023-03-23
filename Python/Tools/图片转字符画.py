from PIL import Image

# 定义字符集
char_set = list(" .,:irsXA253hMHGS#9B&@")

# 打开图片并调整大小
img = Image.open("Python\Data\logo.png")
width, height = img.size
aspect_ratio = height/width
new_width = 120
new_height = int(aspect_ratio * new_width * 0.55)
img = img.resize((new_width, new_height))

# 转换图片为灰度图
img = img.convert("L")

# 将每个像素转换为对应的字符
pixels = img.getdata()
chars = [char_set[int(pixel/255*(len(char_set)-1))] for pixel in pixels]
chars = ''.join(chars)

# 将字符画输出到控制台
for i in range(0, len(chars), new_width):
    print(chars[i:i+new_width])
