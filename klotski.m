clear;

% �ᵶ����
start = ...
    [ 1, 2, 2, 3;
      1, 2, 2, 3;
      4, 5, 5, 6;
      4, 7, 8, 6;
      9, 0, 0, 10;];

% % �����ȵ�
% start = ...
%     [ 1, 2, 2, 3;
%       4, 2, 2, 5;
%       0, 6, 6, 0;
%       7, 8, 9, 10;
%       7, 8, 9, 10;];
  
% % ���·ת
% start = ...
%     [ 1, 3, 4, 5;
%       2, 2, 6, 5;
%       2, 2, 6, 7;
%       0, 8, 8, 7;
%       0, 10,9, 9;];

% % ���׻��ݵ�
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
 
startBoard = CheckerBoard(start);                   % ���þ�����������ʼ����״̬
targetBoard = CheckerBoard(target);                 % ���þ���������Ŀ������״̬
searcher = BoardSearcher(startBoard, targetBoard);  % ����·��������BoardSearcher
while ~searcher.search(50); end                     % ��50��Ϊ������λ����������ֱ�������õ�����·��
searcher.plotResult();                              % չʾ����·��
searcher.writeResult('result.txt');                 % ������·��д���ļ�