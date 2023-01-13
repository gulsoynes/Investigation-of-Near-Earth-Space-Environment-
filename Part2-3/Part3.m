%%% LABWORK 3 %%%
%%%Neslihan Gülsoy
clear; clc; close all;

%Magnetic Field Data
A = readtable('THB_L2_FGM_39760.csv','VariableNamingRule','preserve');
A = rmmissing(A);   %Remove NaN Values
A.Properties.VariableNames = {'Date','Btot','Bx','By','Bz'};

%MOM Data
X = readtable ('THB_L2_MOM_39760.csv','VariableNamingRule','preserve');
X = rmmissing(X);   %Remove NaN Values
X.Properties.VariableNames = ...
    {'Date','Density','Vx','Vy','Vz', 'T1','T2','T3'};

% Time Vector
t1 = cell2mat(A.Date);
time1 = t1(1:10634,12:23);
t2 = cell2mat(X.Date);
time2 = t2(:,12:23);

Btot = table2array(A(1:10634,2));  %(nT)
Bz = table2array(A(:,5));  %(nT)
Bz = Bz(Bz<10e5 & Bz>-10e5);  %To Remove Flag Data

density = table2array(X(:,2));  %Proton Number Density (#/cm^3)

V = sqrt(table2array(X(:,3)).^2 + table2array(X(:,4)).^2 +...
    table2array(X(:,5)).^2 );   %Total Velocity (km/s)

%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% To Determinate Magnetopause Time (Pdyn = Pmag)
mu_0 = 4e-7 * pi;   %(Henry/m)
m_p = 1.67e-27;     %(kg)
B0 = 0.3e-4;        %Magnitude of Earth Magnetic Field at Eq. (Tesla)

Pmag = (Btot * 10^-9).^2 / (2 * mu_0) *10^9; %(nPa)
%Dynamic Pressure Calculation
Pdyn1 = 2 * density .* m_p .* (V) .^2 * 10^21;    %(nPa)

%Due to Time Series Plot Consider a Spesific Interval
for i = 8600:9200
    for j = 8600:9200
        if round(Pmag(i),2,'significant') == round(Pdyn1(j),2,'significant')
            if strcmp(time1(i,1:5),time2(j,1:5)) == 1
            MP1 = i;
            MP2 = j;
            end
        end
    end
end
fprintf('Magnetopause occured at %s (hh:mm:ss)\n', time2(MP2,:))

BS = 2469;      %Found at Labwork 2

%%% Magnetosheath Properties
Mst.time = time2(BS:MP2,:);
Mst.Bz = Bz(BS:MP2);
Mst.Bzp = Mst.Bz(Mst.Bz>=0);
Mst.Bzm = Mst.Bz(Mst.Bz<0);
Mst.Vtot = V(BS:MP2);
Mst.density = density(BS:MP2);


%Dynamic Pressure Calculation
Pdyn = Mst.density .* m_p .* (Mst.Vtot) .^2 * 10^21;    %(nPa)

%Magnetopause Distance Calculation
Rmp = ( B0^2 ./ (mu_0 .* m_p .* Mst.density .* 10^6 .* ...
    (Mst.Vtot .* 10^3).^2 ) ).^(1/6);                   %(Re)

%Auroral Latitude Calculation
Latitude = acosd(1./sqrt(Rmp));                         %(deg)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%% Statistic Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T.name = ["Bzp"; "Bzm"; "Pdyn"; "Rmp"; "Latitude"];
T.Mean = [mean(Mst.Bzp) ; mean(Mst.Bzm) ; mean(Pdyn); mean(Rmp);...
    mean(Latitude)];
T.Med = [median(Mst.Bzp) ; median(Mst.Bzm) ; median(Pdyn); ...
    median(Rmp); median(Latitude)];
T.Max = [max(Mst.Bzp) ; max(Mst.Bzm) ; max(Pdyn); max(Rmp); max(Latitude)];
T.Min = [min(Mst.Bzp) ; min(Mst.Bzm) ; min(Pdyn); min(Rmp); min(Latitude)];
T.Std = [std(Mst.Bzp) ; std(Mst.Bzm) ; std(Pdyn); std(Rmp); std(Latitude)];
Table = struct2table( T );
disp(Table) %Display Outputs
% 
% writetable(Table,'table.xls')
% 
%To Create Time Array
j = 0;

for i = 1:length(Mst.time)-1
    if strcmp(Mst.time(i,1:5),Mst.time(i+1,1:5)) == 0
        if strcmp(Mst.time(i+1,5),'2') == 1
            j = j+1;
            val(j) = i;
            tx(j,1) = convertCharsToStrings(Mst.time(i+1,:));
        end
    end
end

tx = [Mst.time(1,:); tx; Mst.time(end,:)];
val = [1 val length(Mst.time)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% %PLOTTING% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure1 = figure;
axes1 = axes('Parent',figure1,...
    'Position',[0.1 0.7 0.85 0.2]);
hold(axes1,'on');

[m1 z1] = min(Mst.Bz);
[m2 z2] = max(Mst.Bz);

plot(Mst.Bz,'Parent',axes1);
hold on 
plot(z1,m1, '*','Parent',axes1)
hold on
plot(z2,m2, '*','Parent',axes1)
ylabel('$B_{z}$ $[nT]$','Interpreter','latex')
xlim(axes1,[1 length(Mst.time)]);
ylim(axes1,[-40 40]);
hold on
plot(zeros(1,length(Mst.time)),'LineWidth',1.5)
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'XGrid','on','XMinorTick','on','XTick',...
    val,...
    'XTickLabel',...
    {});

axes2 = axes('Parent',figure1,...
    'Position',[0.1 0.45 0.85 0.2]);
hold(axes2,'on');

[m1 z1] = min(Pdyn);
[m2 z2] = max(Pdyn);

plot(Pdyn,'Parent',axes2);
hold on 
plot(z1,m1, '*','Parent',axes2)
hold on
plot(z2,m2, '*','Parent',axes2)
ylabel('$P_{dyn}$ $[nPa]$','Interpreter','latex')
xlim(axes2,[1 length(Mst.time)]);
hold(axes2,'off');
% Set the remaining axes properties
set(axes2,'XGrid','on','XMinorTick','on','XTick',...
    val,...
    'XTickLabel',...
    {});
axes3 = axes('Parent',figure1,...
    'Position',[0.1 0.2 0.85 0.2]);
hold(axes3,'on');

[m1 z1] = min(Rmp);
[m2 z2] = max(Rmp);
% Create plot
plot(Rmp,'Parent',axes3);
hold on 
plot(z1,m1, '*','Parent',axes3)
hold on
plot(z2,m2, '*','Parent',axes3)
ylabel('$R_{mp}$ $[Re]$','Interpreter','latex')

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes3,[1 length(Mst.time)]);
ylim(axes3,[0 50]);
hold(axes3,'off');
% Set the remaining axes properties
set(axes3,'XGrid','on','XMinorTick','on','XTick',...
    val,...
    'XTickLabel',tx, ...
    'XTickLabelRotation',90);

saveas(gcf,'Lw3fig1.jpg')
saveas(gcf,'Lw3fig1.fig')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure2 = figure;
scatter(Pdyn,Rmp,'filled')
title(...
    'Scatter Plot of Dynamic Pressure ($P_{dyn}$) versus Magnetopause Distance ($Rmp$)'...
    ,'Interpreter','latex')
ylabel('$Rmp$ $[Re]$','Interpreter','latex');
xlabel('$P_{dyn}$ $[nPa]$','Interpreter','latex');
ax = gca;
ax.XTick = (floor(min(Pdyn)):0.5:ceil(max(Pdyn)));
ax.XGrid = 'on';

saveas(gcf,'Lw3fig2.jpg')
saveas(gcf,'Lw3fig2.fig')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure3 = figure;
scatter(Mst.Bz,Rmp,'filled')
title(...
    'Scatter Plot of Shocked IMF $B_z$ versus Magnetopause Distance $(Rmp)$'...
    ,'Interpreter','latex')
ylabel('$Rmp$ $[Re]$','Interpreter','latex');
xlabel('$B_{z}$ $[nT]$','Interpreter','latex');
ax = gca;
ax.XLim =[-40 40];
ax.XGrid = 'on';
hold on
plot(zeros(length(5:45),1),(5:45),'LineWidth',1.5)

annotation(figure3,'textbox',...
     [0.278571428571428,0.83,0.181428571428572,0.070476190476191],...
    'String',{'IMF $B_z < 0$'},...
    'FontSize',12,...
    'Interpreter','latex',...
    'FitBoxToText','off');

annotation(figure3,'textbox',...
    [0.56,0.83,0.181428571428572,0.070476190476191],...
    'String','IMF $B_z \geq 0$',...
    'FontSize',12,...
    'Interpreter','latex',...
    'FitBoxToText','off');

saveas(gcf,'Lw3fig3.jpg')
saveas(gcf,'Lw3fig3.fig')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure4 = figure;
scatter(Rmp,Latitude,'filled')
title(...
    'Scatter Plot of Magnetopause Distance ($Rmp$) versus Auroral Latitude ($\Lambda$)'...
    ,'Interpreter','latex')
xlabel('$Rmp$ $[Re]$','Interpreter','latex');
ylabel('$\Lambda$ $[deg]$','Interpreter','latex');
ax = gca;
ax.XGrid = 'on';

saveas(gcf,'Lw3fig4.jpg')
saveas(gcf,'Lw3fig4.fig')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure5 = figure;
scatter(Pdyn,Latitude,'filled')
title(...
    'Scatter Plot of Dynamic Pressure ($P_{dyn}$) versus Auroral Latitude ($\Lambda$)'...
    ,'Interpreter','latex')
xlabel('$P_{dyn}$ $[nPa]$','Interpreter','latex');
ylabel('$\Lambda$ $[deg]$','Interpreter','latex');
ax = gca;
ax.XGrid = 'on';

saveas(gcf,'Lw3fig5.jpg')
saveas(gcf,'Lw3fig5.fig')