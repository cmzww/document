A=imread('self_test_refl_1.tif');
% A=double(A);
M=A(1:280,164:443,:);
M=double(M);
% imshow(A(:,:,1));
B=zeros(280,280);
ND=280;
NN=280*279/2;
for i=1:280;
for j=1:280;
    if j>=i
        f=hyperConvert2d(M(i,i,:));
        d=hyperConvert2d(M(i,j,:));
        y=dot(f,d)/(norm(f)*norm(d));
        ang = acos(y)*180/pi;
        %求角公式
        B(i,j)=ang;
    else
        B(i,j)=B(j,i);
    end
end
end
imshow(B,[]); 
colorbar;
colormap(gray);title('Angle');
C=B(:);
N=size(C(:,1));
%% 确定 dc

percent=2;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

position=round(78400*percent/100); %% round 是一个四舍五入函数
sda=sort(C); %% 对所有光谱角作升序排列
dc=sda(position);
%% 计算局部密度 rho (利用 Gaussian 核)

fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

%% 将每个数据点的 rho 值初始化为零
for i=1:280
  rho(i)=0;
end

% Gaussian kernel
for i=1:279
  for j=i+1:280
     rho(i)=rho(i)+exp(-(B(i,j)/dc)*(B(i,j)/dc));
     rho(j)=rho(j)+exp(-(B(i,j)/dc)*(B(i,j)/dc));
  end
end

% "Cut off" kernel
%for i=1:N-1
%  for j=i+1:N
%    if (B(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
%end

%% 先求矩阵列最大值，再求最大值，最后得到所有距离值中的最大值
maxd=max(max(B)); 

%% 将 rho 按降序排列，ordrho 保持序
[rho_sorted,ordrho]=sort(rho,'descend');
 
%% 处理 rho 值最大的数据点
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

%% 生成 delta 和 nneigh 数组
for ii=2:280
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(B(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=B(ordrho(ii),ordrho(jj));
        nneigh(ordrho(ii))=ordrho(jj); 
        %% 记录 rho 值更大的数据点中与 ordrho(ii) 距离最近的点的编号 ordrho(jj)
     end
   end
end

%% 生成 rho 值最大数据点的 delta 值
delta(ordrho(1))=max(delta(:));

%% 决策图

disp('Generated file:DECISION GRAPH') 
disp('column 1:Density')
disp('column 2:Delta')

fid = fopen('DECISION_GRAPH', 'w');
for i=1:280
   fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
end
%% 选择一个围住类中心的矩形
disp('Select a rectangle enclosing cluster centers')

%% 每台计算机，句柄的根对象只有一个，就是屏幕，它的句柄总是 0
%% >> scrsz = get(0,'ScreenSize')
%% scrsz =
%%            1           1        1280         800
%% 1280 和 800 就是你设置的计算机的分辨率，scrsz(4) 就是 800，scrsz(3) 就是 1280
scrsz = get(0,'ScreenSize');

%% 人为指定一个位置，感觉就没有那么 auto 了 :-)
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
%% 利用 rho 和 delta 画出一个所谓的“决策图”

subplot(2,1,1)
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('Decision Graph','FontSize',15.0)
xlabel ('\rho')
ylabel ('\delta')

subplot(2,1,1)