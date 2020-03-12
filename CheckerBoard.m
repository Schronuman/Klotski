classdef CheckerBoard
    %CheckerBoard 棋盘类
    %  此类实现棋盘，以模拟移动过程中某一个棋局状态。其通过调用棋子类可给出所有可能的下一局面
    
    properties (Access=private)
        str
        board
        pieces = Piece.empty;
        piecesIndex = uint32.empty;
    end
    
    properties(Dependent)
        Board
        String
        piecesNum
    end
    
    properties
        boardSize
    end
    
    methods(Static)
        
        function str = board2str(board)
            str = mat2str(board);            
        end
        
        function board = str2board(str)
            board = str2num(str);
        end
        
        function classes = classifyPieces(self)
            % 对棋盘中相同类型棋子进行分类，并返回棋子编号至类型编号的映射
            classes = containers.Map('KeyType', 'char', 'ValueType', 'char');
            tpieces = Piece.empty;
            for i = 1:self.boardSize(1)
                for j = 1:self.boardSize(2)
                    if self.Board(i,j) > 0
                        if length(tpieces) < self.Board(i,j)
                            tpieces(self.Board(i,j)) = Piece();
                        end
                        tpieces(self.Board(i,j)).addPosition(i,j);
                    end
                end
            end
            classes('1')='1';
            for i = 2:length(tpieces)
                flag = false;
                for j = 1:i-1
                    if tpieces(i)==tpieces(j)
                        classes(num2str(i)) = num2str(j);
                        flag = true;
                        break;
                    end
                end
                if ~flag
                    classes(num2str(i)) = num2str(i);
                end
            end
        end
        
    end
    
    methods(Access=private)
        function self=placePieces(self)
            % 通过遍历矩阵，找出棋盘中与空位相邻的棋子，并构造Piece类
            
            % 寻找空位，构造虚拟空位棋子
            tpieces = Piece.empty;
            for i = 1:self.boardSize(1)
                for j = 1:self.boardSize(2)
                    if self.board(i,j) == 0
                        tpieces(end+1) = Piece();
                        tpieces(end).addPosition(i,j);
                    end
                end
            end
            
            % 寻找与空位相邻的可动棋子，并构造Piece类
            index = zeros(1,self.boardSize(1)*self.boardSize(2),'uint32');
            for i = 1:length(tpieces)
                t = tpieces(i).getMove();
                for j = 1:length(t)
                    tt = cell2mat(t(j));
                    for k = 1:size(tt,1)
                        if tt(k,1)>0 && tt(k,1)<=self.boardSize(1)  ...
                        && tt(k,2)>0 && tt(k,2)<=self.boardSize(2) ...
                        && self.Board(tt(k,1),tt(k,2))~=0 ...
                        && index(self.Board(tt(k,1),tt(k,2))) == 0
                            self.pieces(end+1) = Piece();
                            self.piecesIndex(length(self.pieces)) = self.Board(tt(k,1),tt(k,2));
                            index(self.Board(tt(k,1),tt(k,2))) = length(self.pieces);
                        end
                    end
                end
            end
            
            % 标记与空位相邻棋子的所有坐标
            for i = 1:self.boardSize(1)
                for j = 1:self.boardSize(2)
                    if self.board(i,j) > 0 && index(self.board(i,j)) ~= 0
                        self.pieces(index(self.board(i,j))).addPosition(i,j);
                    end
                end
            end
        end
    end
    
    methods
        function obj = CheckerBoard(init)
            %CheckerBoard 构造此类的实例
            %   通过棋盘矩阵或字符串（矩阵转化的字符串）构造棋局状态
            if ischar(init)
                obj.str = init;
                obj.board = CheckerBoard.str2board(init);
            elseif isnumeric(init)
                obj.board = init;
                obj.str = CheckerBoard.board2str(init);
            else
                error('无效构造参数');
            end
            obj.boardSize = size(obj.Board);
        end
        
        function Board = get.Board(self)
            Board = self.board;
        end
        
        function String = get.String(self)
            String = self.str;
        end
        
        function num = get.piecesNum(self)
            num = length(self.pieces);
        end
        
        function boards = nextBoards(self)
            % 移动空位周围棋子，并检查移动合法性，返回所有可能的下一棋局状态
            self = self.placePieces();
            boards = CheckerBoard.empty;
            for i = 1:self.piecesNum
                t = self.pieces(i).getMove();
                nowPos = self.pieces(i).position;
                for j = 1:length(t)
                    tt = cell2mat(t(j));
                    flag = true;
                    for k = 1:size(tt,1)
                        if tt(k,1)<=0 || tt(k,1)>self.boardSize(1)  ...
                        || tt(k,2)<=0 || tt(k,2)>self.boardSize(2) ...
                        || (self.Board(tt(k,1),tt(k,2))~=0 ...
                        && self.Board(tt(k,1),tt(k,2))~=self.piecesIndex(i))
                            flag = false;
                            break;
                        end
                    end
                    if flag == false
                        continue;
                    end
                    newboard = self.Board;
                    for k = 1:size(nowPos,1)
                        newboard(nowPos(k,1),nowPos(k,2)) = 0;
                    end
                    for k = 1:size(tt,1)
                        newboard(tt(k,1),tt(k,2)) = self.piecesIndex(i);
                    end
                    boards(end+1) = CheckerBoard(newboard);
                end
            end
        end
        
        function flag = eq(self, b)
            % 重载==符号，判断棋局状态是否相同
            flag = false;
            comp = self.Board(:,:)>=0 & b.Board(:,:)>=0;
            if all(self.boardSize == b.boardSize) && sum(abs(self.Board(comp)-b.Board(comp)),'all') == 0
                flag = true;
            end
        end
        
        function flag = ne(self, b)
            flag = ~(self == b);
        end
            
    end
end

