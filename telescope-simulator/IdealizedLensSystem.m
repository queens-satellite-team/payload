% Piper Steffen 2019-11-27

% Doesn't Run???

% Model te idealized focal lengths and configuration of a 2 lens system

clear;
close all;

b = Bench;

% APERATURE
aper = Aperture( [1 0 0], [100 120]);
b.append(aper);

% Constants for lenses
conicCoeff = 0;
frontSurface = {'air' 'bk7'};
backSurface = {'bk7' 'air'};

% LENS 1 - biconvex
d1 = 63;
R1 = 98.5;
CT1 = 31.52;
ET1 = 4;
    % Front surface 
   	frontPos1 = 10;
    lens1f = Lens([frontPos1 0 0], d1, R1, conicCoeff, frontSurface);
    % Back surface
    backPos1 = frontPos1 + CT1;
    lens1b = Lens([backPos1 0 0], d1, -R1, conicCoeff, backSurface);
b.append({lens1f, lens1b});
   
% LENS 2 - biconcave
d2 = 25;
R2 = 26.16;
CT2 = 2;
ET2 = 8.36;
    % Front surface 
   	frontPos2 = 60;
    lens2f = Lens([frontPos2 0 0], d1, -R2, conicCoeff, frontSurface);
    % Back surface
    backPos2 = frontPos2 + ET2;
    lens2b = Lens([backPos2 0 0], d2, R2, conicCoeff, backSurface);
b.append({lens2f, lens2b});    
    
% SCREEN
screen = Screen( [100 0 0], 110, 110, 512, 512);
b.append(screen);

nrays = 100;
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58);
rays_through = b.trace( rays_in );
b.draw( rays_in );
b.draw( rays_through, 'lines' );
