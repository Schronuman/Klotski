classdef BoardSearcher < handle
    %BoardSearcher ���·��������
    %   �ù�����������ҵ����״̬�����·��
    
    properties(Access=private)
        start
        target
        doneFlag
        result
        fatherBoard = containers.Map('KeyType', 'char', 'ValueType', 'char');       % ���ڵ�ӳ�䣬���ڻ�������·��
        piecesClass = containers.Map('KeyType', 'char', 'ValueType', 'char');       % ��������ӳ�䣬���ڴ������Ӷ�Ӧ��״����
        searchStates = containers.Map('KeyType', 'char', 'ValueType', 'logical');   % �Ƿ�����ӳ�䣬���ڱ����ظ�������֦
        searchList = CheckerBoard.empty;                                            % �������У��Ƚ��ȳ������ڹ����������
    end
    
    properties(Dependent)
        startBoard
        targetBoard
        searchFlag
    end
    
    methods(Access=private)
        
        function res = getFather(self)
            % ���ݸ��ڵ�������·��
            res = [self.searchList(1),];
            father = self.fatherBoard(res(end).String);
            while convertCharsToStrings(father) ~= "0"
                res = [res, CheckerBoard(father)];
                father = self.fatherBoard(res(end).String);
            end
        end
        
        function str = getClassStr(self, str)
            % �����̶�Ӧ�ַ�����ͬ�������滻Ϊ�����ͺţ����ڼ�֦
            t = self.piecesClass.keys;
            for i = 1:length(t)
                tt = cell2mat(t(i));
                str = strrep(str,tt,self.piecesClass(tt));
            end
        end
        
    end
    
    methods
        
        function obj = BoardSearcher(start, target)
            %BoardSearcher ��������ʵ��
            %   ������CheckerBoardʵ�����죬�ֱ��Ӧ��ʼ״̬�ͽ���״̬
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
            % �����������������ֵΪ�Ƿ������ɹ�������·��
            
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
            front = 0;      % ����ͷβ
            rear = length(self.searchList);
            h = waitbar(0,"�����У���ȴ�:"+num2str(step)+"/"+num2str(maxStep)+"��");
            while true
                if self.searchList(front+1) == self.target
                    % �ҵ�Ŀ��
                    self.searchList = [self.searchList(front+1),];
                    done = true;
                    break;
                end                
                if rear == front
                    % ��ǰ�����������
                    step = step + 1;
                    self.searchList = self.searchList(front+1:end);
                    if isempty(self.searchList)
                        error('�޷��ҵ�·����');
                    end
                    rear = length(self.searchList);
                    front = 0;
                    waitbar(step/maxStep, h, "�����У���ȴ�:"+num2str(step)+"/"+num2str(maxStep)+"������ǰ����"+num2str(rear)+"״̬");
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
                waitbar(1, h, "�����ɹ�");
                pause(0.5);
            else
                waitbar(1, h, "δ������Ŀ�꣬��׷����������");
                pause(0.5);
            end
            close(h);
        end
               
        function plotResult(self)
            % ����heatmap��̬չʾ�������
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
                error('����δ���!');
            end
        end
        
        function writeResult(self, filename)
            % ������Ծ���д���ļ�
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
                error('����δ���!');
            end
        end
        
    end
end

