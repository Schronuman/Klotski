classdef BoardSearcher < handle
    %BoardSearcher 棋局路径搜索器
    %   用广度优先搜索找到棋局状态间最短路径
    
    properties(Access=private)
        start
        target
        doneFlag
        result
        fatherBoard = containers.Map('KeyType', 'char', 'ValueType', 'char');       % 父节点映射，用于回溯最优路径
        piecesClass = containers.Map('KeyType', 'char', 'ValueType', 'char');       % 棋子类型映射，用于储存棋子对应形状类型
        searchStates = containers.Map('KeyType', 'char', 'ValueType', 'logical');   % 是否搜索映射，用于避免重复搜索剪枝
        searchList = CheckerBoard.empty;                                            % 搜索队列，先进先出，用于广度优先搜索
    end
    
    properties(Dependent)
        startBoard
        targetBoard
        searchFlag
    end
    
    methods(Access=private)
        
        function res = getFather(self)
            % 回溯父节点获得最优路径
            res = [self.searchList(1),];
            father = self.fatherBoard(res(end).String);
            while convertCharsToStrings(father) ~= "0"
                res = [res, CheckerBoard(father)];
                father = self.fatherBoard(res(end).String);
            end
        end
        
        function str = getClassStr(self, str)
            % 将棋盘对应字符串中同型棋子替换为棋子型号，用于剪枝
            t = self.piecesClass.keys;
            for i = 1:length(t)
                tt = cell2mat(t(i));
                str = strrep(str,tt,self.piecesClass(tt));
            end
        end
        
    end
    
    methods
        
        function obj = BoardSearcher(start, target)
            %BoardSearcher 构造此类的实例
            %   以两个CheckerBoard实例构造，分别对应初始状态和结束状态
            obj.start = start;
            obj.target = target;
            obj.doneFlag = false;
            obj.fatherBoard = containers.Map('KeyType', 'char', 'ValueType', 'char');
            obj.searchStates = containers.Map('KeyType', 'char', 'ValueType', 'logical');
            obj.piecesClass = containers.Map('KeyType', 'char', 'ValueType', 'char');
            obj.searchList = CheckerBoard.empty;
            obj.searchList = [start,];
            obj.fatherBoard(start.String) = '0';
            obj.piecesClass = CheckerBoard.classifyPieces(start);
            obj.searchStates(obj.getClassStr(start.String)) = true;
        end
        
        function s = get.startBoard(self)
            s = self.start;
        end
        
        function t = get.targetBoard(self)
            t = self.target;
        end
        
        function t = get.searchFlag(self)
            t = self.doneFlag;
        end
        
        function [done, res] = search(self, maxStep)
            % 广度优先搜索，返回值为是否搜索成功和最优路径
            
            if (nargin<2)
                maxStep = 100;
            end
            done = false;
            res = CheckerBoard.empty;
            if (self.searchFlag)
                done = self.searchFlag;
                res = self.result;
                return;
            end
            
            step = 1;
            front = 0;      % 队列头尾
            rear = length(self.searchList);
            h = waitbar(0,"搜索中，请等待:"+num2str(step)+"/"+num2str(maxStep)+"步");
            while true
                if self.searchList(front+1) == self.target
                    % 找到目标
                    self.searchList = [self.searchList(front+1),];
                    done = true;
                    break;
                end                
                if rear == front
                    % 当前步骤搜索完毕
                    step = step + 1;
                    self.searchList = self.searchList(front+1:end);
                    if isempty(self.searchList)
                        error('无法找到路径！');
                    end
                    rear = length(self.searchList);
                    front = 0;
                    waitbar(step/maxStep, h, "搜索中，请等待:"+num2str(step)+"/"+num2str(maxStep)+"步，当前步骤"+num2str(rear)+"状态");
                end
                if step > maxStep
                    break;
                end
                
                nowBoard = self.searchList(front + 1);
                next = nowBoard.nextBoards();
                for i = 1:length(next)
                    key = self.getClassStr(next(i).String);
                    if self.searchStates.isKey(key)
                        continue;
                    end
                    self.fatherBoard(next(i).String) = nowBoard.String;
                    self.searchStates(key) = true;
                    self.searchList(end+1) = next(i);
                end
                front = front + 1;
            end
            if done
                self.doneFlag = true;
                res = flip(self.getFather());
                self.result = res;
                waitbar(1, h, "搜索成功");
                pause(0.5);
            else
                waitbar(1, h, "未搜索到目标，请追加搜索步骤");
                pause(0.5);
            end
            close(h);
        end
               
        function plotResult(self)
            % 利用heatmap动态展示搜索结果
            if self.doneFlag
                color = colormap(flipud(colorcube));
                hm = heatmap(self.result(1).Board, 'Colormap', color);
                pause(1)
                for i = 2:length(self.result)
                    hm = heatmap(self.result(i).Board, 'Colormap', color);
                    pause(0.2)
                end
                pause(1)
                close all;
            else
                error('搜索未完成!');
            end
        end
        
        function writeResult(self, filename)
            % 将结果以矩阵写入文件
            if self.doneFlag
                fileID = fopen(filename,'w');
                for i = 1:length(self.result)
                    fprintf(fileID, "#%d:\n[\n",i-1);
                    for j = 1:size(self.result(i).Board, 1)
                        for k = 1:size(self.result(i).Board, 2)
                            fprintf(fileID, "%d\t", self.result(i).Board(j,k));
                        end
                        fprintf(fileID, "\n");
                    end
                    fprintf(fileID, "]\n\n");
                end
            else
                error('搜索未完成!');
            end
        end
        
    end
end

