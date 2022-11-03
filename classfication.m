
x = zeros(1707,1);
for i = 1:1707   %get a list x of each column's digit
    x(i)=dzip(i);
end 
class_column = cell(10,1);
for u = 0:9
    class_column{u+1} = find(ismember(x,u)); % we can see 1707 columns have digits 0 to 9. 
end 
% Then we get different classes' columns's index for digits 0 to 9 in
% class_column cell.

digit = unique(x);
n = histc(x,digit); % numbers of columns in each group(0 to 9)
class = cell(10,1);
for j = 1:10
    M = zeros(256,n(j));
    a = class_column{j};
    for k = 1:n(j)
        M(:,k) = azip(:,a(k));
    end 
    class{j} = M;
end 
%then classify each class with same digit columns. The class matrixs from 0
%to 9 is in class cell. 

%calculate the svd of each class matrix, use(5,10,20)singular vector(left)
%as basis of a class.
U = cell(10,1);
S = cell(10,1);
V = cell(10,1);
for j = 1:10
    [U{j},S{j},V{j}] = svd(class{j});
end 
class_basis5 = cell(10,1);
class_basis10 = cell(10,1);
class_basis20 = cell(10,1);
for j = 1:10
    class_basis5{j} = U{j}(:,[1:5]);
    class_basis10{j} = U{j}(:,[1:10]);
    class_basis20{j} = U{j}(:,[1:20]);
end

%Then we calculate the norm of the residuals of each column and norm of the
%original image. then we get the relative residual vector, which is used to
%predict the classfication of unknow test digits data for three (5,10,20) different
%singular vectors basises.

d = zeros(10,1);% for basis 5/10/20
D = zeros(10,2007);
for m = 1:2007
    for j = 1:10
        d(j) = norm(testzip(:,m)-class_basis20{j}*(class_basis20{j}'*testzip(:,m)));
    end
    D(:,m) = d;
end 
I = zeros(2007,1);
for m = 1:2007
    [E,p] = min(D(:,m));
    I(m,1)= p;
end

l = zeros(1,2007);
for m = 1:2007
    if I(m) == dtest(m)+1
        l(m) = 1;
    else 
        l(m) = 0;
    end 
end 
 percentage = 1/2007*sum(l);

 X=[5,10,20];Y=[0.9028,0.9317,0.9397];
 plot(X,Y)
 xlabel('numbers of basis vector')
 ylabel('percentage of correctly classified')
 title('Plot of accuracy of classfication')
 
