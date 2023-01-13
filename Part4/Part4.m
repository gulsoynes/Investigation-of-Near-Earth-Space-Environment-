%%% LABWORK 4 %%%
%%%Neslihan Gülsoy
clear; clc; close all;

%Magnetic Field Data
B_ac = readtable('activedey1_.csv','VariableNamingRule','preserve');
B_ac.Properties.VariableNames = {'Date','Btot','Bx','By','Bz'};

C = readtable('quitday1_.csv','VariableNamingRule','preserve');
C.Properties.VariableNames = {'Date','Btot','Bx','By','Bz'};

Btot_ac = table2array(B_ac(:,2));  %(nT)
i = find(Btot_ac < -10^20 );
Btot_ac(i) = NaN;

Btot_q = table2array(C(:,2));  %(nT)
i = find(Btot_q < -10^20 );
Btot_q(i) = NaN;

Bz_ac = table2array(B_ac(:,5));  %(nT)
i = find(Bz_ac < -10^20 );
Bz_ac(i) = NaN;

Bz_q = table2array(C(:,5));  %(nT)
i = find(Bz_q < -10^20 );
Bz_q(i) = NaN;

%Plasma Data
Z = readtable ('activedey2_.csv','VariableNamingRule','preserve');
Z.Properties.VariableNames = {'Date','Pdyn','Deltime'};

X = readtable ('quitday2_.csv','VariableNamingRule','preserve');
X.Properties.VariableNames = {'Date','Pdyn','Deltime'};

Pdyn_ac = table2array(Z(:,2));  %(nT)
i = find(Pdyn_ac < -10^20 );
Pdyn_ac(i) = NaN;

Pdyn_q = table2array(X(:,2));  %(nT)
i = find(Pdyn_q < -10^20);
Pdyn_q(i) = NaN;

i = find(Pdyn_q > 20);
Pdyn_q(i) = NaN;

% Time Vector
a = Pdyn_ac;

Dst.Hour = 0:24;
Dst.A = [ 0  -1  -3  -10 -19 -16 -20 -27 -35 -43 -52 -61 -62 -67 -58 -55 -74 -97 -107 -119 -98 -87 -76 -71 -58
    ];
Dst.Q = [ 4   5   6   6   6   5   7   8    5   3   3   3   0   5   9   5    4   0   0   1   0   2   2   1  -3];

Y = readtable('AU DATA - Active Day.txt','VariableNamingRule','preserve');
AE_ac = table2array(Y(:,4));
AE_ac = AE_ac(~isnan(AE_ac));

Y2 = readtable('AU DATA - Quit Day.txt','VariableNamingRule','preserve');
AE_q = table2array(Y2(:,4));
AE_q = AE_q(~isnan(AE_q));

%%%%%%%
% figure(1)
% plot(AE_ac)
% ylabel('$AE$ $(nT)$','Interpreter','Latex');
% ax = gca;
% %ax.XTickLabels = {};
% ax.YLim = [0 2000];
% ax.XLim = [0 length(AE_ac)];
% ax.XTick = 0 : length(AE_ac)/24 : length(AE_ac);
% ax.XGrid = 'on';
% 
% ax.XTickLabel = {'14/02/18 15:00','14/02/18 16:00','14/02/18 17:00','14/02/18 18:00'...
%     ,'14/02/18 19:00','14/02/18 20:00','14/02/18 21:00','14/02/18 22:00','14/02/18 23:00',...
%     '14/02/19 00:00','14/02/19 01:00','14/02/19 02:00','14/02/19 03:00'...
%     ,'14/02/19 04:00','14/02/19 05:00','14/02/19 06:00','14/02/19 07:00'...
%     ,'14/02/19 08:00','14/02/19 09:00','14/02/19 10:00','14/02/19 11:00'...
%     ,'14/02/19 12:00','14/02/19 13:00','14/02/19 14:00','14/02/19 15:00'};
% ax.XTickLabelRotation = 90;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
subplot(5,1,1)
plot(Dst.Hour,Dst.A)
hold on
plot(Dst.Hour,zeros(length(Dst.A)),'r')
ax = gca;
ax.YLim = [-120 20];
ax.XLim = [0 24];
ax.XTick = 1:24;
ax.XTickLabels = {};
ax.XGrid = 'on';
ylabel('$Dst$ $(nT)$','Interpreter','Latex');

subplot(5,1,2)
plot(AE_ac)
ylabel('$AE$ $(Re)$','Interpreter','Latex');
ax = gca;
ax.XTickLabels = {};
ax.YLim = [0 2000];
ax.XLim = [0 length(AE_ac)];
ax.XTick = 0 : length(AE_ac)/24 : length(AE_ac);
ax.XGrid = 'on';

subplot(5,1,3)
plot(Btot_ac)
ax = gca;
ax.XTickLabels = {};
ax.XLim = [0 length(Btot_ac)];
ax.XTick = 0 : length(Btot_ac)/24 : length(Btot_ac);
ax.YLim = [0 20];
ax.XGrid = 'on';
ylabel('IMF $B_{tot}$ $(nT)$','Interpreter','Latex' )

subplot(5,1,4)
plot(zeros(length(Bz_ac)),'r')
hold on
plot(Bz_ac)
ax = gca;
ax.XTickLabels = {};
ax.XLim = [0 length(Bz_ac)];
ax.YLim = [-20 20];
ax.XTick = 0 : length(Bz_ac)/24 : length(Bz_ac);
ax.XGrid = 'on';
ylabel('IMF $B_{z}$ $(nT)$','Interpreter','Latex' )

subplot(5,1,5)
plot(a)
ax = gca;
ax.XLim = [0 length(a)];
ax.XTick = 0 : length(a)/24 : length(a);
ax.YLim = [0 15];
ax.XGrid = 'on';
ylabel('$P_{dyn}$ $(nPa)$','Interpreter','Latex' )
ax.XTickLabel = {'14/02/18 15:00','14/02/18 16:00','14/02/18 17:00','14/02/18 18:00'...
    ,'14/02/18 19:00','14/02/18 20:00','14/02/18 21:00','14/02/18 22:00','14/02/18 23:00',...
    '14/02/19 00:00','14/02/19 01:00','14/02/19 02:00','14/02/19 03:00'...
    ,'14/02/19 04:00','14/02/19 05:00','14/02/19 06:00','14/02/19 07:00'...
    ,'14/02/19 08:00','14/02/19 09:00','14/02/19 10:00','14/02/19 11:00'...
    ,'14/02/19 12:00','14/02/19 13:00','14/02/19 14:00','14/02/19 15:00'};
ax.XTickLabelRotation = 90;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
subplot(5,1,1)
plot(Dst.Hour,Dst.Q)
hold on
plot(Dst.Hour,zeros(length(Dst.Q)),'r')
ax = gca;
ax.YLim = [-120 20];
ax.XLim = [0 24];
ax.XTick = 1:24;
ax.XTickLabels = {};
ax.XGrid = 'on';
ylabel('$Dst$ $(nT)$','Interpreter','Latex');

subplot(5,1,2)
plot(AE_q)
ylabel('$AE$ $(Re)$','Interpreter','Latex');
ax = gca;
ax.XTickLabels = {};
ax.YLim = [0 2000];
ax.XLim = [0 length(AE_q)];
ax.XTick = 0 : length(AE_q)/24 : length(AE_q);
ax.XGrid = 'on';

subplot(5,1,3)
plot(Btot_q)
ax = gca;
ax.XTickLabels = {};
ax.XLim = [0 length(Btot_q)];
ax.XTick = 0 : length(Btot_q)/24 : length(Btot_q);
ax.YLim = [0 20];
ax.XGrid = 'on';
ylabel('IMF $B_{tot}$ $(nT)$','Interpreter','Latex' )

subplot(5,1,4)
plot(zeros(length(Bz_q)),'r')
hold on
plot(Bz_q)
ax = gca;
ax.XTickLabels = {};
ax.XLim = [0 length(Bz_q)];
ax.YLim = [-20 20];
ax.XTick = 0 : length(Bz_q)/24 : length(Bz_q);
ax.XGrid = 'on';
ylabel('IMF $B_{z}$ $(nT)$','Interpreter','Latex' )

subplot(5,1,5)
plot(Pdyn_q)
ax = gca;
ax.XLim = [0 length(Pdyn_q)];
ax.YLim = [0 15];
ax.XTick = 0 : length(Pdyn_q)/24 : length(Pdyn_q);
ax.XGrid = 'on';
ylabel('$P_{dyn}$ $(nPa)$','Interpreter','Latex' )
ax.XTickLabel = {'14/02/14 00:00','14/02/14 01:00','14/02/14 02:00','14/02/14 03:00'...
    ,'14/02/14 04:00','14/02/14 05:00','14/02/14 06:00','14/02/14 07:00','14/02/14 08:00',...
    '14/02/14 09:00','14/02/14 10:00','14/02/14 11:00','14/02/14 12:00'...
    ,'14/02/14 13:00','14/02/14 14:00','14/02/14 15:00','14/02/14 16:00'...
    ,'14/02/14 17:00','14/02/14 18:00','14/02/14 19:00','14/02/14 20:00'...
    ,'14/02/14 21:00','14/02/14 22:00','14/02/14 23:00','14/02/15 00:00'};
ax.XTickLabelRotation = 90;