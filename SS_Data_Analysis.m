%MSE 3332
%SS Curve
%Rohan Casukhela

clc
clear all

%read-in data
start_linear = 55;
end_linear = 70;
filename = 'T6R'; %You input this string.
titlename = strcat('Stress vs. % Elongation graph for:', {' '}, filename(1:length(filename)-1));
titlename = char(titlename);
linename = strcat(filename, ' YS Offset Line');
xlRange = 'D3:E7000'; %set some ridiculous range.
num = xlsread(filename,'Exported DAQ data' ,xlRange);

loadkn = num(:,1);
extensometer = num(:,2);
load = 1000.*loadkn; %Load in Newtons
thicknessmm = xlsread(filename,'Test Report', 'B38');
widthmm = xlsread(filename,'Test Report', 'B37');
thickness = thicknessmm/1000; %convert to m.
width = widthmm/1000; %convert to m.

%cross-sectional area calculation.
area = thickness * width; %m^2.

%stress array generation
stresspa = load ./ area; %Pa.
stress = 1e-6 .* stresspa; %MPa.

% %elongation generation
exten_ini = 25.4; %1 inch, in mm.
strain = extensometer ./ exten_ini; 
percent_elongation = 100 .* strain;

%Elastic Modulus
% start_linear = input('What point to start linear regression\n\n');
% end_linear = input('What point to end linear regression\n\n');
poly = polyfit(percent_elongation(start_linear:end_linear), stress(start_linear:end_linear), 1);
Empa = poly(1); %MPa.
E = Empa * 1e-1; %GPa.
fprintf('Elastic Modulus (GPa): %f\n', E)

%Yield Strength
imax = 1000;
i = 0;
% x = [0:0.01:1000]';
x = linspace(0, percent_elongation(length(percent_elongation)), length(percent_elongation));
x = x';
% tol = input('Set tolerance (1e-3 is good start).\n\n');

for i = 1:length(x)
line(i) = Empa*(percent_elongation(i) - 0.02);
end
for j = 1:length(stress)
index(j) = stress(j) - line(j);
if index(j) < 0
fprintf('Negative Yield Found. Seeking alternative solution.\n')
if abs(index(j)) < 10
fprintf('yield strength (MPa): %f\n', stress(j))
yield_strength = stress(j);
break
end
end
end


%ultimate tensile stength
uts = max(stress);
fprintf('ultimate tensile strength (MPa): %f\n\n', uts)

% %elongation at fracture
long_at_failure = xlsread(filename,'Test Report', 'B36');
fprintf('elongation (%%) at failure: %f\n\n', long_at_failure)

fprintf('file: %s\n\n', filename)

hold on
plot(percent_elongation, stress, '*', 'DisplayName', filename)
plot(percent_elongation, line, '--', 'DisplayName', linename)
legend('Location', 'southeast')
scalenumber = max(percent_elongation)*1.01;
xlim([0 scalenumber])
ylim([0 260])
title(titlename)
ylabel('Stress (MPa)')
xlabel('% Elongation')
set(gca, 'xtick', 0:1:scalenumber)
set(gca, 'ytick', 0:20:260)
set(gca,'fontsize',20)