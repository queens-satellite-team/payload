clear;
close all;
% Modified from example 1

% create a container for optical elements (Bench class)
bench = Bench;

% add optical elements in the order they are encountered by light rays

% aperture
aper = Aperture( [ 5 0 0 ], [ 25 80 ] ); % circular aperture
bench.append( aper );

% Constant lens parameters
cc = 0;                 % Conic coefficient 
frontSurface =  { 'air' 'bk7' };
backSurface = { 'bk7' 'air' };


% LENS #1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% front lens surface
pos1x = 20;
diam1 = 40;
spRad = 60;
lens1 = Lens( [ pos1x 0 0 ], diam1, spRad, cc, frontSurface );

% back lens surface
CT2 = 10;
diam2 = diam1;
lens2 = Lens( [ pos1x+CT2 0 0 ], diam2, -spRad, cc, backSurface ); 
bench.append( { lens1, lens2 } );

% LENS #2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% front lens surface
pos2x = pos1x + 80;
diam3 = 20;
spRad2 = 22; 
lens3 = Lens( [pos2x  0 0 ], diam3, spRad2, cc, frontSurface );
% back lens surface
diam4 = diam3;
CT4 = 5;
lens4 = Lens( [ pos2x+CT4 0 0 ], diam4, -spRad2, cc, backSurface );
bench.append( { lens3, lens4 } );

% screen
screen = Screen( [ 50 0 0 ], 50, 50, 512, 512 );
bench.append( screen );

% create some rays
nrays = 500;
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 58, 'hexagonal' );

npos = 50; % # of positions to calculate
dv = zeros( npos, 1 );
scr_x = linspace( lens2.r(1) + 20, lens2.r(1) + 60, npos );
for i = 1 : npos % loop over different screen distances
    screen.r(1) = scr_x( i );   % note that one can change element parameters after it was added to a Bench   
    rays_through = bench.trace( rays_in ); % trace rays    
    [ ~, dv( i ) ] = rays_through( end ).stat; % get stats on the last ray bundle
end

% dv is the std of the ray bundle
% mdv = minimum element value
% mi = minimum element index
[ mdv, mi ] = min( dv );
focal2 = scr_x( mi );
fprintf( 'Lens 2 Back focal distance minimizing bundle std: %.3f\n', focal2  - lens2.r(1) );
fprintf( 'Lens 2 Bundle std: %.3f\n', mdv );

%find the tightest focus position
f = rays_through( end - 1 ).focal_point;
fprintf( 'Lens2 Back focal distance based on convergence: %.3f\n', f(1)  - lens2.r(1) );

% display focusing
figure( 'Name', 'Optical system focusing', 'NumberTitle', 'Off' );
plot( scr_x - lens2.r(1), dv, '-*' );
xlabel( 'Screen distance from lens 2 surface', 'FontSize', 16 );
ylabel( 'Bundle focus (standard deviation)', 'FontSize', 16 );

% draw rays for the tightest focus
% screen.r(1) = scr_x( mi );           % set distance for which the spread was minimal
% screen.r(1) = f(1);           % set distance for which the spread was minimal

% constant
screen.r(1) = 130;

rays_through = bench.trace( rays_in );    % repeat to get the min spread rays

% draw bench elements and draw rays as arrows
bench.draw( rays_through, 'lines' );  % display everything, the other draw option is 'lines'
%scatter3( f(1), f(2), f(3), 'w*' ); % draw the convergence focal point as a white *
%scatter3( focal, 0, 0, 'y*' ); % draw the standard deviation focal point as a yellow *

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
% 
% 
% % Find focus of lens 3/4
% npos = 50;
% dv = zeros( npos, 1 );
% scr_x = linspace( lens3.r(1) - 60, lens3.r(1) - 30, npos );
% for i = 1 : npos % loop over different screen distances
%     screen.r(1) = scr_x( i );   % note that one can change element parameters after it was added to a Bench   
%     rays_through = bench.trace( rays_in ); % trace rays    
%     [ ~, dv( i ) ] = rays_through( end ).stat; % get stats on the last ray bundle
% end
% 
% [ mdv, mi ] = min( dv );
% focal3 = scr_x( mi );
% fprintf( 'Lens 3 Back focal distance minimizing bundle std: %.3f\n', focal3  - lens3r(1) );
% fprintf( 'Lens 3 Bundle std: %.3f\n', mdv );
% 
% %find the tightest focus position
% f = rays_through( end - 1 ).focal_point;
% fprintf( 'Lens 3 Back focal distance based on convergence: %.3f\n', f(1)  - lens3.r(1) );
% 
% % display focusing
% figure( 'Name', 'Optical system focusing', 'NumberTitle', 'Off' );
% plot( scr_x - lens3.r(1), dv, '-*' );
% xlabel( 'Screen distance from lens 3 surface', 'FontSize', 16 );
% ylabel( 'Bundle focus (standard deviation)', 'FontSize', 16 );
% 
% 
