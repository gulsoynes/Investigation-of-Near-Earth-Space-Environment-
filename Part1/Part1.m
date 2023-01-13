clear; clc;

A = readtable ('AC_H0_MFI_155689.csv'); %Magnetic Field Data
A = rmmissing(A);   %Remove NaN Values

Btot = table2array(A(:,2));  %(nT)
Btot = Btot(Btot<20 & Btot>0);  %To Remove Flag Data

Bx = table2array(A(:,3));  %(nT)
Bx = Bx(Bx<20 & Bx>-20);  %To Remove Flag Data

Bxp = Bx(Bx>=0);
Bxm = Bx(Bx<0);

By = table2array(A(:,4));  %(nT)
By = By(By<20 & By>-20);  %To Remove Flag Data

Byp = By(By>=0);
Bym = By(By<0);

Bz = table2array(A(:,5));  %(nT)
Bz = Bz(Bz<20 & Bz>-20);  %To Remove Flag Data

Bzp = Bz(Bz>=0);
Bzm = Bz(Bz<0);

X = readtable ('AC_H0_SWE_155689.csv'); %
X = rmmissing(X);   %Remove NaN Values


Vtot = table2array(X(:,3));

density = table2array(X(:,2));
density2 = density(Vtot>0);
density = density(density<20 & density>0);  %To Remve Flag Data

Vx = table2array(X(:,5));
Vx = Vx(Vx>-700);

Vxp = Vx(Vx>=0);
Vxm = Vx(Vx<0);

Vy = table2array(X(:,6));
Vy = Vy(Vy>-60 & Vy<60);

Vyp = Vy(Vy>=0);
Vym = Vy(Vy<0);

Vz = table2array(X(:,7));
Vz = Vz(Vz>-60 & Vz<60);

Vzp = Vz(Vz>=0);
Vzm = Vz(Vz<0);

tempK = table2array(X(:,4));
tempK2 = tempK(Vtot>0);
tempK = tempK(tempK>0); %To Remove Flag Data
temp = tempK / 11600;    %To Convert Kelvin to eV; 

Vtot = Vtot(Vtot>0);

%%% Pressure Calculations
%Constants
k = 1.38e-23;   %Joule/Kelvin 
mu_0 = 4e-7 * pi;
m_p = 1.67e-27;
gamma = 5/3;

P_gas = 2 * k * density2 .* tempK2 * 10^15 ;

P_mag = Btot.^2 / (2 * mu_0) * 10^-9;

P_dyn = density2 .* m_p .* Vtot .^2 * 10^21;

Cs = sqrt(gamma .* P_gas * 10^-9 ./ (density2 * 10^6 * m_p)) * 10^-3;
Mach = Vtot ./ Cs;


%%% For Table
fprintf('          Mean  Med Max Min Std\n')
fprintf('Density : %.2f  %.2f  %.2f  %.2f  %.2f\n',mean(density),...
    median(density), max(density), min(density), std(density));

fprintf('Vtot : %.2f  %.2f  %.2f  %.2f  %.2f\n',mean(Vtot),...
    median(Vtot), max(Vtot), min(Vtot), std(Vtot))

fprintf('Vxp : %.2f  %.2f  %.2f  %.2f  %.2f\n',mean(Vxp),...
    median(Vxp), max(Vxp), min(Vxp), std(Vxp))

fprintf('Vxm : %.2f  %.2f  %.2f  %.2f  %.2f\n',mean(Vxm),...
    median(Vxm), max(Vxm), min(Vxm), std(Vxm))

fprintf('Vyp : %.2f  %.2f  %.2f  %.3f  %.2f\n',mean(Vyp),...
    median(Vyp), max(Vyp), min(Vyp), std(Vyp))

fprintf('Vym : %.2f  %.2f  %.3f  %.2f  %.2f\n',mean(Vym),...
    median(Vym), max(Vym), min(Vym), std(Vym))

fprintf('Vzp : %.2f  %.2f  %.2f  %.3f  %.2f\n',mean(Vzp),...
    median(Vzp), max(Vzp), min(Vzp), std(Vzp))

fprintf('Vzm : %.2f  %.2f  %.3f  %.3f  %.2f\n',mean(Vzm),...
    median(Vzm), max(Vzm), min(Vzm), std(Vzm))

fprintf('temp : %.2f  %.2f  %.2f  %.2f  %.2f\n',mean(temp),...
    median(temp), max(temp), min(temp), std(temp))

fprintf('Btot : %.2f  %.2f  %.2f  %.3f  %.2f\n',mean(Btot),...
    median(Btot), max(Btot), min(Btot), std(Btot))

fprintf('Bxp : %.3f  %.2f  %.2f  %.3f  %.2f\n',mean(Bxp),...
    median(Bxp), max(Bxp), min(Bxp), std(Bxp))

fprintf('Bxm : %.2f  %.2f  %.3f  %.2f  %.2f\n',mean(Bxm),...
    median(Bxm), max(Bxm), min(Bxm), std(Bxm))

fprintf('Byp : %.2f  %.2f  %.2f  %.3f  %.2f\n',mean(Byp),...
    median(Byp), max(Byp), min(Byp), std(Byp))

fprintf('Bym : %.2f  %.2f  %.3f  %.2f  %.2f\n',mean(Bym),...
    median(Bym), max(Bym), min(Bym), std(Bym))

fprintf('Bzp : %.2f  %.2f  %.2f  %.3f  %.2f\n',mean(Bzp),...
    median(Bzp), max(Bzp), min(Bzp), std(Bzp))

fprintf('Bzm : %.2f  %.2f  %.3f  %.2f  %.2f\n',mean(Bzm),...
    median(Bzm), max(Bzm), min(Bzm), std(Bzm))

fprintf('P_dyn : %.2f  %.2f  %.3f  %.2f  %.3f\n',mean(P_dyn),...
    median(P_dyn), max(P_dyn), min(P_dyn), std(P_dyn))

fprintf('P_gas : %.3f  %.3f  %.3f  %.3f  %.3f\n',mean(P_gas),...
    median(P_gas), max(P_gas), min(P_gas), std(P_gas))

fprintf('P_mag : %.3f  %.3f  %.3f  %.5f  %.3f\n',mean(P_mag),...
    median(P_mag), max(P_mag), min(P_mag), std(P_mag))

fprintf('Cs : %.2f  %.2f  %.3f  %.2f  %.3f\n',mean(Cs),...
    median(Cs), max(Cs), min(Cs), std(Cs))

fprintf('Mach : %.2f  %.2f  %.3f  %.2f  %.3f\n',mean(Mach),...
    median(Mach), max(Mach), min(Mach), std(Mach))

%%%%%%% BAR PLOT
figure(1)
histogram(density,'BinLimits',[0,20],'BinWidth',1)
dim = [0.1427,0.7199,0.1208,0.1755];
str = ["Mean : " + num2str(mean(density)), "Std : " + num2str(std(density)),...
   "Max : " + num2str(max(density)), "Min : "+ num2str(min(density))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');
annotation('textbox',...
    [0.1427 0.641904761904762 0.1873 0.0534952380952383],...
    'String','Bin Size : 1',...
    'Interpreter','latex',...
    'FitBoxToText','off');

xlabel('$Density$ ($\#/cm^3$)','Interpreter','LateX','FontSize', 12)

saveas(gcf,'fig1.png')
saveas(gcf,'fig1.fig')
% 
figure(2)   %Bulk Speed
histogram(Vtot,'BinLimits',[200,700],'BinWidth',20)
dim = [0.142708333333333,0.719873150105708,0.120833333333333,0.175475687103594];
str = ["Mean : " + num2str(mean(Vtot)), "Std : " + num2str(std(Vtot)),...
   "Max : " + num2str(max(Vtot)), "Min : "+ num2str(min(Vtot))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');

annotation('textbox',...
    [0.1427 0.641904761904762 0.1873 0.0534952380952383],...
    'String','Bin Size : 20',...
    'Interpreter','latex',...
    'FitBoxToText','off');

xlabel('$V_{tot}$ ($km/sec$)','Interpreter','LateX','FontSize', 12)
saveas(gcf,'fig2.png')
saveas(gcf,'fig2.fig')
% 
figure(3)   %Temp
histogram(temp,'BinLimits',[0,15],'BinWidth',1)
dim = [0.142708333333333,0.719873150105708,0.120833333333333,0.175475687103594];
str = ["Mean : " + num2str(mean(temp)), "Std : " + num2str(std(temp)),...
   "Max : " + num2str(max(temp)), "Min : "+ num2str(min(temp))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');
annotation('textbox',...
    [0.1427 0.641904761904762 0.1873 0.0534952380952383],...
    'String','Bin Size : 1',...
    'Interpreter','latex',...
    'FitBoxToText','off');
xlabel('$Temp$ ($eV$)','Interpreter','LateX','FontSize', 12)
saveas(gcf,'fig3.png')
saveas(gcf,'fig3.fig')
% 
figure(4)   %Btot
histogram(Btot,'BinLimits',[0,20],'BinWidth',1)
dim = [0.142708333333333,0.719873150105708,0.120833333333333,0.175475687103594];
str = ["Mean : " + num2str(mean(Btot)), "Std : " + num2str(std(Btot)),...
   "Max : " + num2str(max(Btot)), "Min : "+ num2str(min(Btot))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');
annotation('textbox',...
    [0.1427 0.641904761904762 0.1873 0.0534952380952383],...
    'String','Bin Size : 1',...
    'Interpreter','latex',...
    'FitBoxToText','off');
xlabel('$B_{tot}$ ($nT$)','Interpreter','LateX','FontSize', 12)
saveas(gcf,'fig4.png')
saveas(gcf,'fig4.fig')
% 
figure(5)   %Bzs

histogram(Bzp,'BinLimits',[-10,20],'BinWidth',1)
dim = [0.15,0.708235294117647,0.182521465989029,0.202834738694249];
str = ["Positive Data","Mean : " + num2str(mean(Bzp)), "Std : " + num2str(std(Bzp)),...
   "Max : " + num2str(max(Bzp)), "Min : "+ num2str(min(Bzp))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');

hold on
histogram(Bzm,'BinLimits',[-20,10],'BinWidth',1)
dim = [0.7,0.708235294117647,0.182521465989029,0.202834738694249];
str = ["Negative Data" ,"Mean : " + num2str(mean(Bzm)), "Std : " + num2str(std(Bzm)),...
   "Max : " + num2str(max(Bzm)), "Min : "+ num2str(min(Bzm))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');

annotation('textbox',...
    [0.701985714285713 0.631428571428573 0.1873 0.0534952380952384],...
    'String','Bin Size : 1',...
    'Interpreter','latex',...
    'FitBoxToText','off');

%Create line
annotation('line',[0.517142857142857 0.518571428571428],...
    [0.108571428571429 0.923809523809524],'LineWidth',1);

%Create textbox
annotation('textbox',...
    [0.151271428571429 0.630476190476191 0.1873 0.0534952380952383],...
    'String','Bin Size : 1',...
    'Interpreter','latex',...
    'FitBoxToText','off');


xlabel('IMF $B_{z}$ ($nT$)','Interpreter','LateX','FontSize', 12)

ax=gca;
ax.XDir= 'reverse';
saveas(gcf,'fig5.png')
saveas(gcf,'fig5.fig')
% 
figure(6) %Pdyn
histogram(P_dyn,'BinLimits',[0,4],'BinWidth',0.25)
dim = [0.142708333333333,0.719873150105708,0.120833333333333,0.175475687103594];
str = ["Mean : " + num2str(mean(P_dyn)), "Std : " + num2str(std(P_dyn)),...
   "Max : " + num2str(max(P_dyn)), "Min : "+ num2str(min(P_dyn))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');
annotation('textbox',...
    [0.1427 0.641904761904762 0.1873 0.0534952380952383],...
    'String','Bin Size : 0.25',...
    'Interpreter','latex',...
    'FitBoxToText','off');
xlabel('$P_{dyn}$ ($nPa$)','Interpreter','LateX','FontSize', 12)
saveas(gcf,'fig6.png')
saveas(gcf,'fig6.fig')
% 
figure(7) %Cs
histogram(Cs,'BinLimits',[0,100],'BinWidth',5)
dim = [0.142708333333333,0.719873150105708,0.120833333333333,0.175475687103594];
str = ["Mean : " + num2str(mean(Cs)), "Std : " + num2str(std(Cs)),...
   "Max : " + num2str(max(Cs)), "Min : "+ num2str(min(Cs))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');
annotation('textbox',...
    [0.1427 0.641904761904762 0.1873 0.0534952380952383],...
    'String','Bin Size : 5',...
    'Interpreter','latex',...
    'FitBoxToText','off');
xlabel('$C_s$ ($km/sec$)','Interpreter','LateX','FontSize', 12)
saveas(gcf,'fig7.png')
saveas(gcf,'fig7.fig')
% 
figure(8) %Mach

histogram(Mach,'BinLimits',[0,20],'BinWidth',1)
dim = [0.142708333333333,0.719873150105708,0.120833333333333,0.175475687103594];
str = ["Mean : " + num2str(mean(Mach)), "Std : " + num2str(std(Mach)),...
   "Max : " + num2str(max(Mach)), "Min : "+ num2str(min(Mach))];

annotation('textbox',dim,'interpreter','latex','String',str,'FitBoxToText',...
    'on');
annotation('textbox',...
    [0.1427 0.641904761904762 0.1873 0.0534952380952383],...
    'String','Bin Size : 1',...
    'Interpreter','latex',...
    'FitBoxToText','off');
xlabel('$Mach Number$','Interpreter','LateX','FontSize', 12)
saveas(gcf,'fig8.png')
saveas(gcf,'fig8.fig')
