clc;
clear;
% max z = 2x1+3x2
% 2x1 + x2 <=5
% x1-x2 <=1
% x2 <= 2
% x1, x2 >= 0

% this is not how we solve it cuz we need to use matrix
% x1 = 0;
% z=0;
% x2 = 0;
% tol = 0.001;
% while(x1-x2 <=1 && 2*x1 + x2 <= 5)
%     x2 = 0;
%     while(x2<=2)
%         x2 = x2 + tol;
%         z = max(2*x1 + 3*x2, z);
%     end;
%     x1 = x1+tol;
% end;
% 
% disp(z)

%phase 1
A = [2,1;1,-1;0,1];
B = [5;1;2];
C = [2,3];

%phase 2
x1 = 0:0.01:max(B);
% x2 = [(B(1,1) - A(1,1) * x1) /A(1,2); (B(2,1) - A(2,1) * x1) /A(2,2);(B(3,1) - A(3,1) * x1) /A(3,2)];
% x2(1)(x2(1)<0) = NaN;
x21 = (B(1,1) - A(1,1) * x1) /A(1,2);
x22 = (B(2,1) - A(2,1) * x1) /A(2,2);
x23 = (B(3,1) - A(3,1) * x1) /A(3,2);
x21(x21<0) = NaN;
x22(x22<0) = NaN;
x23(x23<0) = NaN;
plot(x1,x21,x1,x22,x1,x23);
grid on;

%phase 3 - Intersection points on axes
cor_pts = [0 0]
for i =1:size(A,1)
    if A(i,1) ~= 0
        x1_int = B(i)/A(i,1)
        if x1_int >=0
            cor_pts=[cor_pts; x1_int 0]
        end
    end
    if A(i,2) ~= 0
        x2_int = B(i)/A(i,2)
        if x2_int >=0
            cor_pts=[cor_pts; 0 x2_int]
        end
    end
end

%phase 4 - Intersection points between constraints
for i = 1:size(A,1)
    for j = i+1:size(A,1)
        A1 = A([i,j], :)
        B1 = B([i,j], :)

        if det(A1)~=0
            X = A1\B1
            if (X>=0)
                cor_pts = [cor_pts;X']
            end
        end
    end
end

%phase 5
for i=1:size(cor_pts,1)
    const1(i) = A(1,1) * cor_pts(i,1) + A(1,2) * cor_pts(i,2) - B(1)
    const2(i) = A(2,1) * cor_pts(i,1) + A(2,2) * cor_pts(i,2) - B(2)
    const3(i) = A(3,1) * cor_pts(i,1) + A(3,2) * cor_pts(i,2) - B(3)

    s1 = find(const1>0)   %this condition will change on the basis of given condition it is basically ulta of the given sign
    s2 = find(const2>0)   %this condition will change on the basis of given condition it is basically ulta of the given sign 
    s3 = find(const3>0)   %this condition will change on the basis of given condition it is basically ulta of the given sign
end

s = unique([s1 s2 s3])
cor_pts(s,:) = []
feas_pts = cor_pts

%phase 6 shade feasible region
k = convhull(feas_pts(:,1), feas_pts(:,2))
fill(feas_pts(k,1), feas_pts(k,2), 'y')

%phase 7 - calculate optimal solution and value
z = feas_pts * C'
[opt_val index] = max(z)   %there can be min depending on the question
x1 = feas_pts(index,1)
x2 = feas_pts(index,2)
fprintf('optimal value is %f at (%f, %f)', opt_val, x1,x2)