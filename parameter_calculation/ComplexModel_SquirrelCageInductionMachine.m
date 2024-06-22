%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Complex Model for Squirrel-Cage Induction Machine
%                               Florin Iov 2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Induction Machine Parameters from data sheet

%Rated power
Pn=5.5e3;

%Rated voltage [V] delta connection
Us=400;

%Rated speed
nn=1520;

%Number of pole pairs
p=2;

%Rated line current
In=10;

%Rated Efficiency
etan=0.94;

%Rated Power factor
cosfin=0.7;

%Rated frequency
fs=50;

%rotor speed
omg_r=2*pi*nn/60;

%synchronous mechanical speed
omg_s=2*pi*fs/p;

%electrical synchronous speed
omg_synch=2*pi*fs;

%rated slip
slip_n=(omg_s-omg_r)/omg_s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Machine parameters
	
%stator resistance
Rs=2/3*3.67;
	
%rotor resistance
Rr=2.32;
	
%Stator leakage reactance
Xsgm_s=2*pi*fs*0.0092;
	
%Rotor leakage reactance
Xsgm_r=2*pi*fs*0.01229;
	
%Magnetizing reactance
Xm=2*pi*fs*0.235;

%Machine Inductances
Xs=Xsgm_s+Xm;
Xr=Xsgm_r+Xm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rated parameters 
Tn=Pn/omg_r/etan
Sn=3*Us*In
Qn=sqrt(Sn^2-Pn^2)
Pel_n=Pn/etan

%slip
slip=-0.3:0.001:1;

%Stator voltage
fi_us=-pi/2;
Us_cmp=sqrt(2)*Us*exp(j*fi_us);

%Rotor voltage
Ur=0;
fi_ur=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:length(slip),
    
    %Complex Impedances
    z11=Rs+j*Xs;
    z12=j*Xm;
    z21(k)=j*slip(k)*Xm;
    z22(k)=Rr+j*slip(k)*Xr;

    %Complex Impedance Matrix 
    z(:,:,k)=[z11, z12; z21(k), z22(k)];

    %Complex Admitance Matrix
    y(:,:,k)=inv(z(:,:,k));
   
    %Voltage vector
    U(:,k)=[sqrt(2)*Us*exp(j*sign(slip(k))*fi_us);Ur*exp(j*fi_ur)];
    
    %Solving currents
    I(:,k)=y(:,:,k)*U(:,k);
    
    %Extracting stator current
    Is(k)=I(1,k);
    
    %Extracting rotor current
    Ir(k)=I(2,k);
    
    %phase for stator current
    phase_s(k)=(angle(Is(k)));
    
    %modulus for stator current
    Is_mod(k)=abs(Is(k))/sqrt(2);
    
    %Electromagnetic torque
    Te_complex(k)=1.5*p*Xm*(real(j*conj(Is(k))*Ir(k)))/omg_synch;
    
    %Stator apparent power
    Ss(k)=1.5*(Us_cmp)*conj(Is(k));
        
    %Stator active power 
    Ps(k)=real(Ss(k));
    
    %Stator reactive power
    Qs(k)=imag(Ss(k));
    
    fis(k)=atan(Qs(k)/Ps(k));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Electromagnetical Torque
figure(1)    
plot( slip,Te_complex,'r-',slip_n,Tn,'bd',...
      'LineWidth',1.5)

xlabel('slip',...
      'FontSize',12,...
      'FontWeight','bold','Interpreter','latex')
ylabel('T_e [pu]',...
      'FontSize',12,...
      'FontWeight','bold','Interpreter','latex')
%axis([-0.3 0.3 -3.1 3.1])
grid

% Current and Flux
figure(2)
subplot(2,1,1)
plot(slip,Is_mod,'r-',slip_n,In,'bd',...
      'LineWidth',2)

ylabel('I_s [pu]',...
      'FontSize',12,...
      'FontWeight','bold')
grid
subplot(2,1,2)
plot(slip,-fis*180/pi,'r-',...
      'LineWidth',2)

xlabel('slip',...
      'FontSize',12,...
      'FontWeight','bold')
ylabel('\phi_s [deg]',...
      'FontSize',12,...
      'FontWeight','bold')
grid

% Active and Reactive Power
figure(3)
subplot(2,1,1)
plot(slip,Ps,'r-',slip_n,Pel_n,'bd',...
      'LineWidth',2)

ylabel('P_s [pu]',...
      'FontSize',12,...
      'FontWeight','bold')
grid
subplot(2,1,2)
plot(slip,Qs/Sn,'r-',...
      'LineWidth',2)

ylabel('Q_s [pu]',...
      'FontSize',12,...
      'FontWeight','bold')
xlabel('slip',...
      'FontSize',12,...
      'FontWeight','bold')
grid

