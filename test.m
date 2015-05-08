%% Isotropic
% select dimension N
N = 3;
%
F = @(t,X) zeros(N,1);
G = @(t,X) eye(N);
S = sde(F,G,'startState',zeros(N,1));

% X = S.simByEuler(10000,'ntrials',1,'Z',@(t,X) RandDir(N));
% 
% comet3(X(:,1),X(:,2),X(:,3));
% plot3(X(:,1),X(:,2),X(:,3));
% grid on;
% axis equal
%% run 1 trial
M = 1;
% for jj = 1:size(M)
    X = S.simByEuler(1000,'ntrials',M,'Z',@(t,X) RandDir(N));
    
    figure('color','w');
    hold on;
    
    view(3)
    shg
    for ii = 1:M
        line(X(:,1,ii),X(:,2,ii),X(:,3,ii),'color',rand(1,3));
        drawnow
        pause(.1);
    end
    
    axis equal
    hold off;
    Lim = [-100 100];
    axis([Lim Lim Lim])
    set(gca,'xtick',[-100 0 100],'ytick',[-100 0 100],...
        'ztick',[-100 0 100])
    grid
%     title('Random Walk 1 cell')
% end
%% run 100 trial
M = 1;
X = S.simByEuler(1000,'ntrials',M,'Z',@(t,X) RandDir(N));

figure('color','w');
view(3)
shg
for ii = 1:M
    line(X(:,1,ii),X(:,2,ii),X(:,3,ii),'color',rand(1,3));
    drawnow
    pause(.1);
end
axis equal
hold off;
Lim = [-100 100];
axis([Lim Lim Lim])
set(gca,'xtick',[-100 0 100],'ytick',[-100 0 100],...
    'ztick',[-100 0 100])
grid

% title('Random Walk 10000 cells')

%% Anisotropic condition
figure('color','w');
view(3)
shg
hold on;

% viscircles([0,0], Radius,'Linestyle',':')
% scatter3(0, 0, 0,10^29)

N = 3;
M = 1000;
Radius = 20;
StartingPoint = [0,0,0];

for jj = 1:10000;
    X = zeros(M,N);
    X(1,:) = StartingPoint;
    for ii = 2:M
        Y = X(ii-1,:)+RandDir(N)';
        if Y(1,1)^2 + Y(1,2)^2 < Radius^2;
            X(ii,:)=Y;
        else
            while Y(1,1)^2 + Y(1,2)^2 > Radius^2;
                Y = X(ii-1,:)+RandDir(N)';
            end
        end
        X(ii,:)=Y; 
    end
    
    % comet3(X(:,1),X(:,2),X(:,3));
    line(X(:,1),X(:,2),X(:,3),'color',rand(1,3));
    clear X;
end

% adjusting axes
axis equal
hold off;
Lim = [-100 100];
axis([Lim Lim Lim])
set(gca,'xtick',[-100 0 100],'ytick',[-100 0 100],...
    'ztick',[-100 0 100])
grid
% view([-37.5 30])
%% save
saveas(gcf,['RW_Anisotropic', num2str(Radius),'.png'])
saveas(gcf,['RW_Anisotropic', num2str(Radius),'.eps'],'psc2')
