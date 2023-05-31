# 创建一个表格
print("Name\tAge\tGender\nJohn\t25\tMale\nTom\t30\tMale\nLucy\t20\tFemale")
# 创建一个嵌套列表
data = [["Name", "Age", "Gender"], ["John", 25, "Male"], ["Tom", 30, "Male"], ["Lucy", 20, "Female"]]
for row in data:
    print("\t".join(str(column) for column in row))
    
# 创建一个分栏文本
print("Title\t\tAuthor\t\tYear\nAlice in Wonderland\tLewis Carroll\t1865\nThe Great Gatsby\tF. Scott Fitzgerald\t1925\nTo Kill a Mockingbird\tHarper Lee\t1960")