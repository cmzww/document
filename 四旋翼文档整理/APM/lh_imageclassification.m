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
        %��ǹ�ʽ
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
%% ȷ�� dc

percent=2;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

position=round(78400*percent/100); %% round ��һ���������뺯��
sda=sort(C); %% �����й��׽�����������
dc=sda(position);
%% ����ֲ��ܶ� rho (���� Gaussian ��)

fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

%% ��ÿ�����ݵ�� rho ֵ��ʼ��Ϊ��
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

%% ������������ֵ���������ֵ�����õ����о���ֵ�е����ֵ
maxd=max(max(B)); 

%% �� rho ���������У�ordrho ������
[rho_sorted,ordrho]=sort(rho,'descend');
 
%% ���� rho ֵ�������ݵ�
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

%% ���� delta �� nneigh ����
for ii=2:280
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(B(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=B(ordrho(ii),ordrho(jj));
        nneigh(ordrho(ii))=ordrho(jj); 
        %% ��¼ rho ֵ��������ݵ����� ordrho(ii) ��������ĵ�ı�� ordrho(jj)
     end
   end
end

%% ���� rho ֵ������ݵ�� delta ֵ
delta(ordrho(1))=max(delta(:));

%% ����ͼ

disp('Generated file:DECISION GRAPH') 
disp('column 1:Density')
disp('column 2:Delta')

fid = fopen('DECISION_GRAPH', 'w');
for i=1:280
   fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
end
%% ѡ��һ��Χס�����ĵľ���
disp('Select a rectangle enclosing cluster centers')

%% ÿ̨�����������ĸ�����ֻ��һ����������Ļ�����ľ������ 0
%% >> scrsz = get(0,'ScreenSize')
%% scrsz =
%%            1           1        1280         800
%% 1280 �� 800 ���������õļ�����ķֱ��ʣ�scrsz(4) ���� 800��scrsz(3) ���� 1280
scrsz = get(0,'ScreenSize');

%% ��Ϊָ��һ��λ�ã��о���û����ô auto �� :-)
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
%% ���� rho �� delta ����һ����ν�ġ�����ͼ��

subplot(2,1,1)
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('Decision Graph','FontSize',15.0)
xlabel ('\rho')
ylabel ('\delta')

subplot(2,1,1)