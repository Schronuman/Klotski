classdef CheckerBoard
    %CheckerBoard ������
    %  ����ʵ�����̣���ģ���ƶ�������ĳһ�����״̬����ͨ������������ɸ������п��ܵ���һ����
    
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
            % ����������ͬ�������ӽ��з��࣬���������ӱ�������ͱ�ŵ�ӳ��
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
            % ͨ�����������ҳ����������λ���ڵ����ӣ�������Piece��
            
            % Ѱ�ҿ�λ�����������λ����
            tpieces = Piece.empty;
            for i = 1:self.boardSize(1)
                for j = 1:self.boardSize(2)
                    if self.board(i,j) == 0
                        tpieces(end+1) = Piece();
                        tpieces(end).addPosition(i,j);
                    end
                end
            end
            
            % Ѱ�����λ���ڵĿɶ����ӣ�������Piece��
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
            
            % ������λ�������ӵ���������
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
            %CheckerBoard ��������ʵ��
            %   ͨ�����̾�����ַ���������ת�����ַ������������״̬
            if ischar(init)
                obj.str = init;
                obj.board = CheckerBoard.str2board(init);
            elseif isnumeric(init)
                obj.board = init;
                obj.str = CheckerBoard.board2str(init);
            else
                error('��Ч�������');
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
            % �ƶ���λ��Χ���ӣ�������ƶ��Ϸ��ԣ��������п��ܵ���һ���״̬
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
            % ����==���ţ��ж����״̬�Ƿ���ͬ
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

