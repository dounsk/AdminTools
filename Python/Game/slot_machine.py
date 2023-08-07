'''
Author       : Kui.Chen
Date         : 2023-05-30 17:02:14
LastEditors  : Kui.Chen
LastEditTime : 2023-05-30 17:47:16
FilePath     : \Scripts\Python\Game\slot_machine.py
Description  : 老虎机小游戏
Copyright    : Copyright (c) 2023 by Kui.Chen, All Rights Reserved.
'''
import random
# 随机生成 🎰 的三个符号
def pull_lever():
    # 可能出现的符号
    symbols = ["🍒","🍉","🍎","🍍","🍓","🥕","🌻","🍀", "🧸", "🍼","🍭","🍑"]
    # 使用循环随机生成三个符号，并返回符号列表
    return [random.choice(symbols) for _ in range(3)]
# 检查结果并返回相应的奖励
def check_win(slots):
    # 如果三个符号相同，最高奖励“Jackpot!”
    if len(set(slots)) == 1:
        return "Jackpot!"
    # 如果有两个符号相同，中等奖励“Win!”
    elif len(set(slots)) == 2:
        return "Win!"
    # 如果三个符号都不相同，失败
    else:
        return "Loss."
def play_game():
    # 初始余额为10
    balance = 10
    # 计数器
    win_count = 0
    loss_count = 0
    # print("\033[1m\033[32m 🎰 Start the game! 🎰 \033[0m")
    print("┌" + "─" * 51 + "┐")
    print("│ Two same win, and all the same wins the jackpot!  │")
    print("│ " + " " * 50 + "│")
    print("│        🎰       GOOD LUCK TO YOU!      🎰         │")
    print("└" + "─" * 51 + "┘")
    # 不断进行游戏，直到余额为0
    while balance > 0:
        # 显示当前余额
        print(f"💰 : {balance}")
        # 等待玩家输入
        user_input = input("Press enter to pull the lever...")
        if user_input.lower() == "esc":
            break
        # 从余额中减去1，并生成老虎机结果
        balance -= 1
        slots = pull_lever()
        result = check_win(slots)
        # 检查结果并显示相应的奖励
        print("╔" + "═" * 13 + "╗")
        print(f"║{' | '.join(slots)} ║ - {result}".center(18))
        print("╚" + "═" * 13 + "╝")
        # 根据结果更新余额和计数器
        if result == "Jackpot!":
            balance += 10
            win_count += 1
        elif result == "Win!":
            balance += 3
            win_count += 1
        else:
            loss_count += 1
    # 游戏结束，显示获胜和失败的次数
    print("--- Game over. ---")
    print(f"You won {win_count} times, and lost {loss_count} times.")

if __name__ == '__main__':
    play_game()