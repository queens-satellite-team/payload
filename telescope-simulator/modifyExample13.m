function modifyExample13()
%
% Modified by Piper Steffen 
%
% test refraction through the lens edge and backward rays refraction using the sub-aperture Maksutov-Cassegrain
% telescope design
%
% Copyright: Yury Petrov, 2016
%

% close existing windows
close all;

% create a container for optical elements (Bench class)
bench = Bench;

% constants
hD = 15; % diameter of the hole in the concave spherical mirror (primary)
D = 100;  % distance to the concave mirror (primary) 
d = D - 98;  % distance to the convex mirror (Secondary)

% add optical elements in the order they are encountered by light rays

% Add our own lens in front of the secondary (convex) mirror
pos = [d-5 0 0];
diam = 40;
spRad = -220;
conicCoeff = 0;
glass = {'bk7' 'air'};
lens1 = Lens ( pos, diam, spRad, conicCoeff, glass);
bench.append(lens1);

% ???? 
% Need to properly align with curved lens surfaces... 
% is that was 'sag' was in the original?
sag = surface_sag( 40, -220, 0);
cylin = CylinderLens( [d-5-sag 0 0 ], 40, 5, { 'bk7' 'air' } );
bench.append(cylin);

pos = [d 0 0];
diam = 40;
spRad = -220;
conicCoeff = 0;
glass = { 'air' 'bk7'};
lens2 = Lens ( pos, diam, spRad, conicCoeff, glass);
bench.append(lens2);

% back surface of the SECONDARY MIRROR (convex mirrror)
pos = [ d 0 0 ];
diam = hD;
spRad = -220;
conicCoeff = 0;
glass = {'mirror' 'air'};
mirror1 = Lens( pos, diam, spRad, conicCoeff, glass ); % pay attention to the glass order here!
bench.append( mirror1 );

% PRIMARY MIRROR (concave mirror)
pos = [ D 0 0 ];
diam = [hD 40];
spRad = -220;
conicCoeff = 0;
glass = {'air' 'mirror'};
mirror2 = Lens( pos, diam, spRad, conicCoeff, glass ); % pay attention to the glass order here!
bench.append( mirror2 );

% Is this where our lens is??? 
% Why the cylinder?? 
% What is surface_sag?

% % meniscus lens on the way from concave to convex mirror (prim to sec)
% lens1 = Lens( [ d + 2 0 0 ], hD, 100, 0, { 'bk7' 'air' } ); % pay attention to the glass order here!
% lens2 = Lens( [ d + 1 0 0 ], hD, 105, 0, { 'air' 'bk7' } ); % pay attention to the glass order here!
% lens2sag = surface_sag( hD, 105, 0 );
% cylin = CylinderLens( [ d + 1 + lens2sag 0 0 ], hD, 1, { 'bk7' 'air' } ); % cylindrical lens equator surface
% bench.append( lens1 );
% bench.append( cylin );
% bench.append( lens2 );

% front surface of the SECONDARY MIRROR (convex mirror)
pos = [ d 0 0 ];
diam = hD;
spRad = -28;
conicCoeff = 0;
glass = { 'mirror' 'air'};
mirror3 = Lens( pos, diam, spRad, conicCoeff, glass ); % pay attention to the glass order here!
bench.append( mirror3 );

% meniscus lens on the way from convex mirror to the screen
%
% FOR BOTH FORWARD (ALONG POSITIVE X-AXIS) AND BACKWARD (ALONG NEGATIVE X-AXIS) RAYS 
% ORDER INTERFACE MATERIAL AS IF FOR FORWARD RAY
% DIRECTION!!! HENCE, CAN REUSE THE LENS SURFACES.
%
% bench.append( lens2 ); % pay attention to the order of surfaces here
% bench.append( lens1 );

% screen
screen = Screen( [ D+10 0 0 ], 10, 10, 512, 512 );
bench.append( screen );

% create collimated rays
nrays = 100;
rays_in = Rays( nrays, 'collimated', [ -20 0 0 ], [ 1 0 0 ], 40, 'hexagonal' );

fprintf( 'Tracing rays...\n' );
rays_through = bench.trace( rays_in, 0 ); % the second parameter set to 0 enables ray tracing for rays missing some elmeents on the bench

% draw bench elements and draw rays as arrows
bench.draw( rays_through, 'lines', [], [ 3 0 2 1 .1 ] );  % display everything, specify arrow length for each bench element
fp = rays_through( end ).focal_point;
fprintf( 'The focal point of the system at: %.3f\n', fp(1) );

% get the screen image in high resolution
nrays = 10000;
rays_in = Rays( nrays, 'collimated', [ 0 0 0 ], [ 1 0 0 ], 40, 'hexagonal' );
bench.trace( rays_in, 0 );
figure( 'Name', 'Image on the screen', 'NumberTitle', 'Off' );
imshow( screen.image, [] );

end
