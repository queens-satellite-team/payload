function focal = example1()
clear;
close all;
%
% test the basic functionality of the  Optometrika library 
%
%
% Copyright: Yury Petrov, 2016
%

% create a container for optical elements (Bench class)
bench = Bench;

% add optical elements in the order they are encountered by light rays

% aperture
aper = Aperture( [ 5 0 0 ], [ 25 80 ] ); % circular aperture
bench.append( aper );

% front lens surface
lens1 = Lens( [ 20 0 0 ], 40, 60, 0, { 'air' 'bk7' } ); % parabolic surface
% back lens surface
lens2 = Lens( [ 30 0 0 ], 40, -60, 0, { 'bk7' 'air' } ); % concave hyperbolic surface
bench.append( { lens1, lens2 } );


% front lens surface
lens3 = Lens( [30+2*45.198  0 0 ], 40, 60, 0, { 'air' 'bk7' } );
% back lens surface
lens4 = Lens( [ 40+2*45.198 0 0 ], 40, -60, 0, { 'bk7' 'air' } );
bench.append( { lens3, lens4 } );

% screen
screen = Screen( [ 50.3 0 0 ], 100, 100, 512, 512 );
bench.append( screen );

%bench.rotate( [ 0 0 1 ], 0.15 );

% create some rays
nrays = 500;
% rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 -0.1 0 ], 58, 'hexagonal' );
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'hexagonal' );

tic;

npos = 50;
dv = zeros( npos, 1 );
scr_x = linspace( lens2.r(1) + 30, lens2.r(1) + 60, npos );
for i = 1 : npos % loop over different screen distances
    screen.r(1) = scr_x( i );   % note that one can change element parameters after it was added to a Bench   
    rays_through = bench.trace( rays_in ); % trace rays    
    [ ~, dv( i ) ] = rays_through( end ).stat; % get stats on the last ray bundle
end

[ mdv, mi ] = min( dv );
focal = scr_x( mi );
fprintf( 'Back focal distance minimizing bundle std: %.3f\n', focal  - lens2.r(1) );
fprintf( 'Bundle std: %.3f\n', mdv );

%find the tightest focus position
f = rays_through( end - 1 ).focal_point;
fprintf( 'Back focal distance based on convergence: %.3f\n', f(1)  - lens2.r(1) );

% display focusing
figure( 'Name', 'Optical system focusing', 'NumberTitle', 'Off' );
plot( scr_x - lens2.r(1), dv, '-*' );
xlabel( 'Screen distance from the back lens surface', 'FontSize', 16 );
ylabel( 'Bundle focus (standard deviation)', 'FontSize', 16 );

% draw rays for the tightest focus
% screen.r(1) = scr_x( mi );           % set distance for which the spread was minimal
% screen.r(1) = f(1);           % set distance for which the spread was minimal

% % front lens surface
% lens3 = Lens( [100  0 0 ], 40, 40, 0, { 'air' 'bk7' } );
% % back lens surface
% lens4 = Lens( [ 120 0 0 ], 40, -40, 0, { 'bk7' 'air' } );
% bench.append( { lens3, lens4 } );

screen.r(1) = 150;

rays_through = bench.trace( rays_in );    % repeat to get the min spread rays

% draw bench elements and draw rays as arrows
bench.draw( rays_through, 'lines' );  % display everything, the other draw option is 'lines'
scatter3( f(1), f(2), f(3), 'w*' ); % draw the convergence focal point as a white *
scatter3( focal, 0, 0, 'y*' ); % draw the standard deviation focal point as a yellow *

% get the screen image in high resolution for both types of focal points
%nrays = 10000;
%rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'hexagonal' );
%bench.trace( rays_in );
figure( 'Name', 'Image on the screen, convergence focal point', 'NumberTitle', 'Off' );
imshow( screen.image, [] );

%screen.r(1) = focal;
%bench.trace( rays_in );
%figure( 'Name', 'Image on the screen, std focal point', 'NumberTitle', 'Off' );
%imshow( screen.image, [] );

toc;
end

