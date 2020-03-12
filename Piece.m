classdef Piece < handle
    %PIECE 基础棋子类
    %   模拟棋子移动，返回棋子移动后的坐标
    
    properties (Access=private)
        x = uint32.empty;
        y = uint32.empty;
        move
    end
    
    properties (Dependent)
        position
        left
        right
        up
        down
    end
    
    methods
        function obj = Piece()
            %PIECE 构造此类的实例
            %   默认构造函数
        end
        
        function self = addPosition(self, nx, ny)
            % 标记棋子所在位置
            self.x = [self.x, nx];
            self.y = [self.y, ny];
        end
        
        function up = get.up(self)
                up = [self.x-1; self.y]';
        end
        
        function down = get.down(self)
            down = [self.x+1; self.y]';
        end
        
        function left = get.left(self)
            left = [self.x; self.y-1]';
        end
        
        function right = get.right(self)
         right = [self.x; self.y+1]';
        end

        function move = getMove(self)
            % 棋子的所有可能移动后坐标
            move = {self.left, self.right, self.up, self.down};
        end
        
        function pos = get.position(self)
            pos = [self.x; self.y]';
        end
        
        function flag = eq(a, b)
            % 判断棋子是否属于同一形状
            flag = false;
            if length(a.x) == length(b.x) && length(a.y) == length(b.y) 
                abx = a.x - b.x;
                aby = a.y - b.y;
                if all(abx==abx(1),'all') && all(aby==aby(1),'all')
                    flag = true;
                end
            end
        end
    end
end

