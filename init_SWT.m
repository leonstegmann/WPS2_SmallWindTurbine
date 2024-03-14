% Init Parameters


%

% Mechanical Model

% Turine (rotor)
D_r = 0 ; % Damping (frcition constant)
K_r = 0 ; % Stiffness (torsional spring constant)
J_r = 299 ; % Inertia
N = 9 % 1:9 Gear box ratio

% Generator 
D_g = 0 ; % Damping (frcition constant)
K_g = 0 ; % Stiffness (torsional spring constant)
J_g = 0.68 ; % Inertia
pole_pairs = 2;% Number of pole-pairs
nominal_Nr =  1430 % [rpm] nominal speed rotor

% equivalent
K_eq = 101787 ; % N/m
D_eq = 8402 ; 

% General
Pnom = 16e3;% Nominal power [W]
Vm_max = 400;             % [V]
Im_max = Pnom/(3*Vm_max*sqrt(2)/2/2); % [Apeak]
%kt = 3/2*p*Fpm;             % [Nm/Apeak]
fnom = 10;                  % [Hz]
Nnom = 60*fnom/pole_pairs;           % [rpm]
w = Nnom*pi/30;             % [rad/s]

X_m = 3 ; % [pu] Magnetizing Reactance, 
X_s = 0.035 ;% pu Stator Reactance,
X_r = 0.089 ;% pu Rotor Reactance, 
R_s = 0.013 ;% pu Stator Resistance, 
R_r = 0.003; % pu Rotor Resistance, 

C_bank =258.7e-6 % uF 
Capacitor_initialVoltage = 400  % 




