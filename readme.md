# Klotski Solver 华容道解决器

本代码利用MATLAB实现了经典游戏——华容道的解决路径搜索。

## 华容道简介

>华容道（英语：Klotski，来自波兰文的klocki，意为木块）是一种滑块类游戏，由放在方形盘中的10块方片拼成，目标是在只滑动方块而不从棋盘中拿走的情况下，将最大的一块移到底部出口。流行于中国的华容道是由英国人John Harold Fleming在1932年所发明，然后本土化加上三国背景。国内国外都有一些华容道的爱好者研究者。
——维基百科

## 环境与运行

编写环境为`MATLAB R2019b`，不能保证较低版本能正常运行。

实例代码为`klotski.m`，运行即可看到实例结果。

## 代码基本逻辑

此代码实现了三个基本类：`Piece`、`CheckerBoard`、`BoardSearcher`，分别对应棋子、棋盘（单一棋局状态）和路径搜索器。

 *  `Piece`为基本棋子类，模拟棋子移动，返回棋子移动后的坐标；
 *  `ChekerBoard`是棋盘类，模拟移动过程中某一个棋局状态。其通过调用棋子类可给出所有可能的下一局面；
 *  `BoardSearcher`棋局路径搜索器，用广度优先搜索找到棋局状态间最短路径。

## 附加说明

 * 关于移动步数的讨论：此搜索器与传统计步逻辑有差异。传统计步是一个棋子移动一次（可以移动多格）计为一步，此程序中一个棋子移动一格计为一步，连续移动多格计为多步。由于广度优先搜索的性质，可以保证最优路径与传统最优路径再此程序记步法中结果一致。