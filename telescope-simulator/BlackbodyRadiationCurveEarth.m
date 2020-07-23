% calculating and plotting black body radiation curve for Earth

%% constants:
h = 6.62607015e-34; %Planck's constant; J*s
c = 299792458; %speed of light in a vacuum; m/s
k = 1.380649e-23; %Boltzmann's constant; J/K
T = 300; %assuming absolute surface temp; K

%% Camera specs

wavelength = [300, 315, 400, 500, 600, 700, 800, 900, 1000, 1100];
qe = [5, 4, 55, 78, 60, 39, 22, 9, 3, 0];
p = polyfit(wavelength, qe, 10);
QE = poly2sim(p); % Symbolic polynomial for quantum efficiency

wave = 300:1:1100;
wavem = wave.*1e-9; %putting wavelength into metres

syms  lambda Bv(lambda) PE(lambda) QE(lambda)

Bv(lambda) = (2*h*c*c)/((lambda^5)*(exp((h*c)/(k*T*lambda))-1));

% figure
% plot(wavem,Bv)
% title('Blackbody Radiation Curve of Earth at 300K')
% xlabel('Wavelength [m]')
% ylabel('Blackbody Radiation [W/sr*m3]')

PE(lambda) = (h*c)/lambda; %photon energy [J]

% figure
% plot(wavem,PE)
% title('Photon Energy for Earth at 300K')
% xlabel('Wavelength [m]')
% ylabel('Photon Energy [J]')

alpha = 60000; %m
beta = 60000; %m
d = 400000; %m

%calculating square solid angle
Omega = 4*atan((alpha*beta)/2*d*sqrt(4*d^2+alpha^2+beta^2)); % units: sr, steradians
FOV = alpha*beta; %m2

integrandpart1 = (Bv*Omega*FOV)/PE; %first section of integrand, then need to multiply by the QE curve from sensor
QE(lambda) = 1.653e+3 - 2e+1*lambda +9.10e-2*lambda^2 - 2e-4*lambda^3 + 2.32e-7*lambda^4 - 1.35e-10*lambda^5 + 3.16e-14*lambda^6;

integrand = integrandpart1*(QE/100); %defining integrand

integrated = int(integrand,lambda,[3e-07 11e-7]) %taking integral of function


% subs(integrated,lambda,wavem)
% value = ans(integrated)
% 
% add = sum(value)
% vpa(add,5)
% 
% fplot(integrated,[3.0e-07 1.1e-06])