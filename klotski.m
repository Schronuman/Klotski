clear;

% 横刀立马
start = ...
    [ 1, 2, 2, 3;
      1, 2, 2, 3;
      4, 5, 5, 6;
      4, 7, 8, 6;
      9, 0, 0, 10;];

% % 捷足先登
% start = ...
%     [ 1, 2, 2, 3;
%       4, 2, 2, 5;
%       0, 6, 6, 0;
%       7, 8, 9, 10;
%       7, 8, 9, 10;];
  
% % 峰回路转
% start = ...
%     [ 1, 3, 4, 5;
%       2, 2, 6, 5;
%       2, 2, 6, 7;
%       0, 8, 8, 7;
%       0, 10,9, 9;];

% % 简易华容道
% start = ...
%     [ 1, 1, 3, 3;
%       4, 4, 0, 0;
%       5, 5, 6, 6;
%       7, 8, 2, 2;
%       9, 10, 2, 2;];

target = ...
    [ -1, -1, -1, -1;
      -1, -1, -1, -1;
      -1, -1, -1, -1;
      -1,  2,  2, -1;
      -1,  2,  2, -1;];
 
startBoard = CheckerBoard(start);                   % 利用矩阵构造搜索初始棋盘状态
targetBoard = CheckerBoard(target);                 % 利用矩阵构造搜索目标棋盘状态
searcher = BoardSearcher(startBoard, targetBoard);  % 构造路径搜索器BoardSearcher
while ~searcher.search(50); end                     % 以50步为基本单位持续搜索，直到搜索得到最优路径
searcher.plotResult();                              % 展示最优路径
searcher.writeResult('result.txt');                 % 将最优路径写入文件