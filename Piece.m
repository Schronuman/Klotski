classdef Piece < handle
    %PIECE ����������
    %   ģ�������ƶ������������ƶ��������
    
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
            %PIECE ��������ʵ��
            %   Ĭ�Ϲ��캯��
        end
        
        function self = addPosition(self, nx, ny)
            % �����������λ��
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
            % ���ӵ����п����ƶ�������
            move = {self.left, self.right, self.up, self.down};
        end
        
        function pos = get.position(self)
            pos = [self.x; self.y]';
        end
        
        function flag = eq(a, b)
            % �ж������Ƿ�����ͬһ��״
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

