%%% LABWORK 2 %%%
%%%Initials of events should be find manually
%%%Neslihan Gülsoy

%%% Remove btw 16:10 and 17:00; and 23:30 and 23:50

clear; clc;

%Magnetic Field Data
A = readtable('THB_L2_FGM_134858.csv','VariableNamingRule','preserve');
A = rmmissing(A);   %Remove NaN Values
A.Properties.VariableNames = {'Date','Btot','Bx','By','Bz'};

Btot = table2array(A(:,2));  %(nT)

Bz = table2array(A(:,5));  %(nT)
Bz = Bz(Bz<10e5 & Bz>-10e5);  %To Remove Flag Data

%MOM Data
X = readtable ('THB_L2_MOM_134858.csv','VariableNamingRule','preserve');
X = rmmissing(X);   %Remove NaN Values
X.Properties.VariableNames = ...
    {'Date','Density','Vx','Vy','Vz', 'T1','T2','T3'};

density = table2array(X(:,2));  %Proton Number Density (#/cm^3)

V = sqrt(table2array(X(:,3)).^2 + table2array(X(:,4)).^2 +...
    table2array(X(:,5)).^2 );   %Total Velocity (km/s)

T = sqrt(table2array(X(:,6)).^2 + table2array(X(:,7)).^2 +...
    table2array(X(:,8)).^2 );   %Temperature (eV)

%Time Vector
t1 = cell2mat(A.Date);
time1 = t1(:,12:23);
t2 = cell2mat(X.Date);
time2 = t2(:,12:23);

j1 = 0;
j2 = 0;

for i = 1:length(time1)-1
    %To Create Ten Minutes Resolution
    if strcmp(time1(i,1:4),time1(i+1,1:4)) == 0
        j1 = j1+1;
        val1(j1) = i;
        tx1(j1,1) = convertCharsToStrings(time1(i+1,:));
    end
end


for i = 1:length(time2)-1
    
    if strcmp(time2(i,1:4),time2(i+1,1:4)) == 0
        j2 = j2+1;
        val2(j2) = i;
        tx2(j2,1) = convertCharsToStrings(time2(i+1,:));
    end
    
end

tx1 = [time1(1,:); tx1 ; time1(length(time1),:)];
val1 = [1 val1 length(time1)];

tx2 = [time2(1,:); tx2 ; time2(length(time2),:)];
val2 = [1 val2 length(time2)];


%To Find BowShock Time
BS = 2469;
fprintf('Bow Shock occured at %s (hh:mm:ss)\n', time1(BS,:))

%To Find Magnetopause Time
MP = 8850;
fprintf('Magnetopause occured at %s (hh:mm:ss)\n', time2(MP,:))

%%% Solar Wind Properties
SW.Btot = table2array(A(1:BS,2));
SW.Bz = Bz(1:BS);
SW.Bzp = SW.Bz(SW.Bz>=0);
SW.Bzm = SW.Bz(SW.Bz<0);
SW.Vtot = V(1:BS);
SW.density = density(1:BS);
SW.Temp = T(1:BS);

%%% Magnetosheath Properties
Mst.Btot = table2array(A(BS:MP,2));
Mst.Bz = Bz(BS:MP);
Mst.Bzp = Mst.Bz(Mst.Bz>=0);
Mst.Bzm = Mst.Bz(Mst.Bz<0);
Mst.Vtot = V(BS:MP);
Mst.density = density(BS:MP);
Mst.Temp = T(BS:MP);

%%% Magnetosphere Properties
Msp.Btot = table2array(A(MP:end,2));
Msp.Bz = Bz(MP:end);
Msp.Bzp = Msp.Bz(Msp.Bz>=0);
Msp.Bzm = Msp.Bz(Msp.Bz<0);
Msp.Vtot = V(MP:end);
Msp.density = density(MP:end);
Msp.Temp = T(MP:end);

%%% Statistic Analysis for Btot
BTot.name = "Btot";
BTot.SW = [mean(SW.Btot),std(SW.Btot),median(SW.Btot),max(SW.Btot),...
    min(SW.Btot)];

BTot.Mst = [mean(Mst.Btot),std(Mst.Btot),median(Mst.Btot),max(Mst.Btot),...
    min(Mst.Btot)];

BTot.Msp = [mean(Msp.Btot),std(Msp.Btot),median(Msp.Btot),max(Msp.Btot),...
    min(Msp.Btot)];

Table(1,:) = struct2table(BTot);

%%% Statisic Analysis for Bzp
Bzp.name = "Bzp";
Bzp.SW = [mean(SW.Bzp),std(SW.Bzp),median(SW.Bzp),max(SW.Bzp),...
    min(SW.Bzp)];

Bzp.Mst = [mean(Mst.Bzp),std(Mst.Bzp),median(Mst.Bzp),max(Mst.Bzp),...
    min(Mst.Bzp)];

Bzp.Msp = [mean(Msp.Bzp),std(Msp.Bzp),median(Msp.Bzp),max(Msp.Bzp),...
    min(Msp.Bzp)];

Table(2,:) = struct2table(Bzp);

%%% Statistic Analysis for Bzm
Bzm.name = "Bzm";
Bzm.SW = [mean(SW.Bzm),std(SW.Bzm),median(SW.Bzm),max(SW.Bzm),...
    min(SW.Bzm)];

Bzm.Mst = [mean(Mst.Bzm),std(Mst.Bzm),median(Mst.Bzm),max(Mst.Bzm),...
    min(Mst.Bzm)];

Bzm.Msp(1:5) = NaN;

Table(3,:) = struct2table(Bzm);

%%% Statistic Analysis for Vtot
Vtot.name = "Vtot";
Vtot.SW = [mean(SW.Vtot),std(SW.Vtot),median(SW.Vtot),max(SW.Vtot),...
    min(SW.Vtot)];

Vtot.Mst = [mean(Mst.Vtot),std(Mst.Vtot),median(Mst.Vtot),max(Mst.Vtot),...
    min(Mst.Vtot)];

Vtot.Msp = [mean(Msp.Vtot),std(Msp.Vtot),median(Msp.Vtot),max(Msp.Vtot),...
    min(Msp.Vtot)];

Table(4,:) = struct2table(Vtot);

%%% Statistic Analysis for Density
Density.name = "Density";
Density.SW = [mean(SW.density),std(SW.density),median(SW.density),...
    max(SW.density),...
    min(SW.density)];

Density.Mst = [mean(Mst.density),std(Mst.density),median(Mst.density),...
    max(Mst.density),...
    min(Mst.density)];

Density.Msp = [mean(Msp.density),std(Msp.density),median(Msp.density),...
    max(Msp.density),...
    min(Msp.density)];

Table(5,:) = struct2table(Density);

%%% Statistic Analysis for Temperature
Temp.name = "Temp";
Temp.SW = [mean(SW.Temp),std(SW.Temp),median(SW.Temp),max(SW.Temp),...
    min(SW.Temp)];

Temp.Mst = [mean(Mst.Temp),std(Mst.Temp),median(Mst.Temp),max(Mst.Temp),...
    min(Mst.Temp)];

Temp.Msp = [mean(Msp.Temp),std(Msp.Temp),median(Msp.Temp),max(Msp.Temp),...
    min(Msp.Temp)];

Table(6,:) = struct2table(Temp);

writetable(Table,'table.xls')

% %%%Time Series Plot
figure1 = figure;%('WindowState','maximized');

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.800677966101695 0.82 0.15]);
hold(axes1,'on');

% Create plot
plot(Btot,'Parent',axes1);
ylabel('$B_{tot}$ $[nT]$','Interpreter','latex')
% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[1 length(time2)]);
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'XGrid','on','XMinorTick','on','XTick',...
    val2,...
    'XTickLabel',...
    {});

axes2 = axes('Parent',figure1,...
    'Position',[0.13 0.625338983050847 0.82 0.15]);
hold(axes2,'on');

plot(Bz,'Parent',axes2);
ylabel('$B_{z}$ $[nT]$','Interpreter','latex')
xlim(axes2,[1 length(time2)]);
hold on
plot(zeros(1,length(time2)),'LineWidth',1.5)
hold(axes2,'off');
% Set the remaining axes properties
set(axes2,'XGrid','on','XMinorTick','on','XTick',...
    val2,...
    'XTickLabel',...
    {});

axes3 = axes('Parent',figure1,...
    'Position',[0.13 0.455338983050847 0.82 0.15]);
hold(axes3,'on');

% Create plot
plot(V,'Parent',axes3);
ylabel('$V_{tot}$ $[km/sec]$','Interpreter','latex')

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes3,[1 length(time2)]);
hold(axes3,'off');
% Set the remaining axes properties
set(axes3,'XGrid','on','XMinorTick','on','XTick',...
    val2,...
    'XTickLabel',...
    {});
axes4 = axes('Parent',figure1,...
    'Position',[0.13 0.282669491525424 0.82 0.15]);
hold(axes4,'on');

% Create plot
plot(density,'Parent',axes4);
ylabel('$Density$ $[\#/cm^3]$','Interpreter','latex')

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes4,[1 length(time2)]);
ylim(axes4,[-10 80])
hold(axes4,'off');
% Set the remaining axes properties
set(axes4,'XGrid','on','XMinorTick','on','XTick',...
    val2,...
    'XTickLabel',...
    {});
axes5 = axes('Parent',figure1,...
    'Position',[0.13 0.11 0.82 0.15]);
hold(axes5,'on');

% Create plot
plot(T,'Parent',axes5);
ylabel('$Temp.$ $[eV]$','Interpreter','latex')

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes5,[1 length(time2)]);
ylim(axes5,[-1000 6000])
hold(axes5,'off');
% Set the remaining axes properties
set(axes5,'XGrid','on','XMinorTick','on','XTick',...
    val2,...
    'XTickLabel',tx2, ...
    'XTickLabelRotation',90);


%%%%%%%%% Annotation 
annotation(figure1,'textbox',...
    [0.849999999999999 0.861579280679876 0.0709636743335705 0.0343551802080732],...
    'String',{'Magnetosphere'},...
    'Interpreter','latex',...
    'FitBoxToText','off');


% Create textbox
annotation(figure1,'textbox',...
    [0.556249999999997 0.909090909090909 0.0770833333333315 0.0407547568710348],...
    'VerticalAlignment','baseline',...
    'String',{'Magnetostaeth'},...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.1921875 0.915490485753869 0.0569301060935582 0.0343551802080733],...
    'VerticalAlignment','baseline',...
    'String',{'Solar Wind'},...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.297395833333332 0.956716701398691 0.0713541666666666 0.0386405919661729],...
    'VerticalAlignment','baseline',...
    'String',{'Bow Shock'},...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
    'EdgeColor',[1 0 0]);


% Create textbox
annotation(figure1,'textbox',...
    [0.7921875 0.956716701398691 0.0713541666666666 0.0386405919661729],...
    'VerticalAlignment','baseline',...
    'String',{'Magnetopause'},...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
     'EdgeColor',[1 0 0]);


% Create line
annotation(figure1,'line',[0.815943987 0.815943987],...
    [0.950317124735728 0.110993657505285],...
    'Color',[0.501960784313725 0.501960784313725 0.501960784313725],...
    'LineWidth',1);


% Create line
annotation(figure1,'line',[0.321354166666665 0.321354166666666],...,...
    [0.950317124735728 0.110993657505285],...
    'Color',[0.501960784313725 0.501960784313725 0.501960784313725],...
    'LineWidth',1);
