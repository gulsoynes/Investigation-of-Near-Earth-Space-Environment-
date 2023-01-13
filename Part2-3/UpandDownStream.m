%%%% LABWORK 2 - Mach Number and Rankie
clear; clc;

%%%%% Constants
gamma = 5/3;
k = 1.38e-23;
m_p = 1.68e-27;


X = readtable ('down_stream.csv','VariableNamingRule','preserve');
X = rmmissing(X);   %Remove NaN Values
X.Properties.VariableNames = ...
    {'Date','Density','Vx','Vy','Vz', 'T1','T2','T3'};

Y = readtable ('up_stream.csv','VariableNamingRule','preserve');
Y = rmmissing(Y);   %Remove NaN Values
Y.Properties.VariableNames = ...
    {'Date','Density','Vx','Vy','Vz', 'T1','T2','T3'};

%%%%% Downstream
density_down = table2array(X(:,2));  %Down Proton Number Density (#/cm^3)

Vtot_down = sqrt(table2array(X(:,3)).^2 + table2array(X(:,4)).^2 +...
    table2array(X(:,5)).^2 );   %Total Down Velocity (km/s)

TK_down = (sqrt(table2array(X(:,6)).^2 + table2array(X(:,7)).^2 +...
    table2array(X(:,8)).^2 )) .* 11600 ;   %Total Down Temperature (K)

P_gas_down = 2 * k * density_down .* TK_down * 10^15 ;

Cs_down = sqrt(gamma .* P_gas_down * 10^-9 ./ (density_down *...
    10^6 * m_p)) * 10^-3;
Mach_down = Vtot_down ./ Cs_down;

Down = [mean(Mach_down) , max(Mach_down) , min(Mach_down)];


%%%% Upstream
density_up = table2array(Y(:,2));  %Down Proton Number Density (#/cm^3)

Vtot_up = sqrt(table2array(Y(:,3)).^2 + table2array(Y(:,4)).^2 +...
    table2array(Y(:,5)).^2 );   %Total Down Velocity (km/s)

TK_up = (sqrt(table2array(Y(:,6)).^2 + table2array(Y(:,7)).^2 +...
    table2array(Y(:,8)).^2 )) .* 11600 ;   %Total Down Temperature (K)


P_gas_up = 2 * k * density_up .* TK_up * 10^15 ;

Cs_down = sqrt(gamma .* P_gas_up * 10^-9 ./ (density_up * 10^6 * m_p)) * 10^-3;
Mach_up = Vtot_up ./ Cs_down;

Up = [mean(Mach_up) , max(Mach_up) , min(Mach_up)];

CV = Vtot_up./Vtot_down(1:length(Vtot_up));

Cn = density_down(1:length(density_up))./density_up;