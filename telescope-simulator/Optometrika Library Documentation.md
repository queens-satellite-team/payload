# Optometrika Library Compiled Documentation

## Class Definitions

Information given here is copied directly from files included in the library. Copyright: Yury Petrov, 2016.

### Bench
    % Bench class implements a system of optical elements
    % A complex optical system can be stored and manipulated as a whole by
    % making it a Bench instance.
    %
    % Member functions:
    %
    % b = Bench( obj )  - constructor function
    % INPUT:
    %   obj - an optical element, cell array of elements, or another bench
    % OUTPUT:
    %   b - bench object
    %
    % b.display() - displays bench b's information
    %
    % b.draw( rays, draw_fl, alpha, scale, new_figure_fl ) - draws bench b in the current axes
    % INPUT:
    %   rays - array of rays objects comprising full or partial light path
    %   draw_fl - display rays as 'arrows' (default), 'lines', or 'rays'
    %   alpha - opacity of optical surfaces from 0 to 1, default .33
    %   scale - scale of the arrow heads for the 'arrows' draw_fl
    %   new_figure_fl - 0, do not open, or 1, open (default)
    % 
    % a = b.copy() - copies bench b to bench a
    %
    % b.append( a, n ) - appends element a to bench b n times. n > 1
    % corresponds to multiple possible interactions (internal reflections
    % and such).
    %
    % b.prepend( a, n ) - prepends element a to bench b n times
    %
    % b.replace( ind, a ) - replaces an element with index ind on bench b with element a
    %
    % b.remove( inds ) - removes elements located at inds on bench b
    %
    % b.rotate( rot_axis, rot_angle, rot_fl ) - rotate the bench b with all its elements
    % INPUT:
    %   rot_axis - 1x3 vector defining the rotation axis
    %   rot_angle - rotation angle (radians)
    %   rot_fl - (0, default) rotation of the bench elements wrt to the
    %   global origin, (1) rotation wrt to the bench geometric center
    %   
    % b.translate( tr_vec ) - translate the bench b with all its elements
    % INPUT:
    %   tr_vec - 1x3 translation vector
    %
    % rays_through = b.trace( rays_in, out_fl ) - trace rays through optical elements
    % on the bench b
    % INPUT:
    %   rays_in - incoming rays, e.g., created by the Rays() function
    %   out_fl  - 0 include even rays that missed some elements on the
    %   bench,  - 1 (default) exlude such rays
    % OUTPUT:
    %   rays_through - a cell array of refracted/reflected rays of the same
    %   length as the number of optical elements on the bench.

### Rays
    % RAYS Implements a ray bundle
    % Note that for easy copying Rays doesn't inherit from handle
    %
    % Member functions:
    %
    % r = Rays( n, geometry, r, dir, D, pattern, glass, wavelength, color, diopter ) - object constructor
    % INPUT:
    %   n - number of rays in the bundle
    %   geometry - For geometry 'collimated', r defines rays origins while dir - 
    % their direction. For geometry 'source', r defines position 
    % of the point source, and dir - direction along which rays propagate. For geometry
    % 'vergent' r defines rays orignis, dir - their average direction, while diopter 
    % defines the convergence/divergence of the rays in diopters.
    %   r - 1x3 bundle source position vector
    %   dir - 1x3 bundle direction vector
    %   D - diameter of the ray bundle (at distance 1 if geometry = 'source' )
    %   pattern - (optional) pattern of rays within the bundle: 'linear' = 'linearY', 'linearZ', 'hexagonal'
    %   'square', 'sphere' or 'random', hexagonal by default
    %   glass - (optional) material through which rays propagate, 'air' by
    % default
    %   wavelength - (optional) wavelength of the ray bundle, meters, 557.7
    % nm by default
    %   color - (optional) 1 x 3 vector defining the color with which to draw
    % the ray, [ 0 1 0 ] (green) by default
    %
    % OUTPUT:
    %   r - ray bundle object

    % r.draw( scale ) - draws the ray bundle r in the current axes as arrows
    % INPUT:
    %   scale - (optional) the arrow length, 1 by default
    %
    % [ rays_out, nrms ] = r.intersection( surf ) - finds intersection
    % of the ray bundle r with a surface
    % INPUT:
    %   surf - the surface
    % OUTPUT:
    %   rays_out - rays_out.r has the intersection points, the remaining
    % structure parameters might be wrong
    %   nrms - 1x3 normal vectors to the surface at the intersection points
    %
    % rays_out = r.interaction( surf ) - finishes forming the outcoming
    % ray bundle, calculates correct directions and intensities
    % INPUT:
    %   surf - surface
    % OUTPUT:
    %   rays_out - outcoming ray bundle
    %
    % r = r.append( r1 ) - appends to bundle r bundle r1
    % INPUT:
    %   r1 - the appended ray bundle
    % OUTPUT:
    %   r - the resulting ray bundle
    % 
    % sr = r.subset( inices ) - subset of rays in bundle r
    % INPUT:
    %   indices - subset's indices in the bundle r
    % OUTPUT:
    %   sr - the resulting new ray bundle
    % 
    % r = r.truncate() - truncate all rays with zero intensity from the bundle r.
    %
    % [ av, dv, nrays ] = r.stat() - return statistics on the bundle r
    % OUTPUT:
    %   av - 1x3 vector of the mean bundle position
    %   dv - standard deviation of the ray positions in the bundle
    %   nrays - number of rays with non-zero intensity in the bundle
    %
    % [ x0, cv, ax, ang, nrays ] = r.stat_ellipse() - fit a circumscribing ellipse
    % to the bundle r in the YZ plane
    % OUTPUT:
    %   x0 - 1x3 vector of the ellipse center
    %   cv - bundle covariance matrix
    %   ax - 1x2 vector of the ellipse half-axes lengths
    %   ang - angle of rotation of the ellipse from the longer axis being
    %   oriented along the Y axis.
    %   nrays - number of rays with non-zero intensity in the bundle
    %
    % r2 = dist2rays( p ) - returns squared distances from point p to all rays
    % INPUT:
    %   p - 1x3 vector
    % OUTPUT:
    %   r2 - nrays x 1 vector of squared distances
    %
    % [ f, ff ] = r.focal_point() - find a focal point of the bundle. The focal
    % point f is defined as the mean convergence distance of the bundle
    % rays. ff gives the residual bundle crossection (intensity weighted std).
    % OUTPUT:
    %    f - 1x3 vector for the focal point 
    %

### Aperture
    % APERTURE defines a circular or rectangular opening
    %
    % Member functions:
    %
    % a = Aperture( r, D ) - object constructor
    % INPUT:
    % r - 1x3 position vector
    % D - 2x1 vector (inner diameter, outer diameter) or 4x1 vector (inner
    % w, innher h, outer w, outer h)
    % OUTPUT:
    % a - aperture object
    %
    % a.display() - displays the aperture a's information
    %
    % draw() - draws the aperture a in the current axes
    % 
    % a.rotate( rot_axis, rot_angle ) - rotate the aperture
    % INPUT:
    %   rot_axis - 1x3 vector defining the rotation axis
    %   rot_angle - rotation angle (radians)

### Lens
    % LENS Implements a lens surface given by a rotation of a conic curve
    % (conic) lens surface given by
    % z = 1/R * r^2 ./ ( 1 + sqrt( 1 - ( 1 + k ) * (r/R)^2 ) ), where
    % R is the tangent sphere radius, and k is the aspheric factor:
    % 0 < k - oblate spheroid
    % k = 0 - sphere
    % -1 < k < 0 - prolate spheroid
    % k = -1 - parabola
    % k < -1 - hyperbola
    %
    % Member functions:
    %
    % l = Lens( r, D, R, k, glass ) - object constructor
    % INPUT:
    % r - 1x3 position vector
    % D - diameter, 1x1 vector (outer) or 2x1 vector (inner, outer)
    % R - tangent sphere radius, [ Ry Rz ] vector for an astigmatic surface
    % k - conic coefficient, for astigmatic surface corresponds to the y-axis 
    % glass - 1 x 2 cell array of strings, e.g., { 'air' 'acrylic' }
    % OUTPUT:
    % l - lens surface object
    %
    % l.display() - displays the surface l information
    %
    % l.draw() - draws the surface l in the current axes
    %
    % l.rotate( rot_axis, rot_angle ) - rotate the surface l
    % INPUT:
    %   rot_axis - 1x3 vector defining the rotation axis
    %   rot_angle - rotation angle (radians)
    
### Screen
    % SCREEN implements a rectangular screen surface
    %   Detailed explanation goes here
    %
    % Member functions:
    %
    % p = Screen( r, w, h, wbins, hbins ) - object constructor
    % INPUT:
    % r - 1x3 position vector
    % w - width
    % h - height
    % wbins - number of bins in the horizontal direction
    % hbins - number of bins in the vertical direction
    % OUTPUT:
    % p - screen object
    %
    % p.display() - displays the screen p information
    %
    % p.draw() - draws the screen p in the current axes
    % 
    % p.rotate( rot_axis, rot_angle ) - rotate the screen p
    % INPUT:
    %   rot_axis - 1x3 vector defining the rotation axis
    %   rot_angle - rotation angle (radians)

### CylinderLens
    % CYLINDERLENS Implements a cylindrical lens surface.
    %
    % Member functions:
    %
    % l = CylinderLens( r, D, h, glass ) - object constructor
    % INPUT:
    % r - 1x3 position vector
    % D - cylinder diameter, [ Dy Dz ] vector for an elliptical cylinder
    % h - cylinder height
    % glass - 1 x 2 cell array of strings, e.g., { 'air' 'acrylic' }
    % OUTPUT:
    % l - lens surface object
    %
    % l.display() - displays the surface l information
    %
    % l.draw() - draws the surface l in the current axes
    %
    % l.rotate( rot_axis, rot_angle ) - rotate the surface l
    % INPUT:
    %   rot_axis - 1x3 vector defining the rotation axis
    %   rot_angle - rotation angle (radians)

### GeneralLens
    % GENERALLENS Implements a lens surface of an arbitrary shape. This
    % class requires iterative search of intersections with a ray,
    % therefore it works slower than Lens. 
    %
    % Member functions:
    %
    % l = GeneralLens( r, D, func, glass, varargin ) - object constructor
    % INPUT:
    % r - 1x3 position vector
    % D - diameter
    % func - function name string
    % glass - 1 x 2 cell array of strings, e.g., { 'air' 'acrylic' }
    % varargin - an arbitrary number of parameters required by func.
    % OUTPUT:
    % l - lens surface object
    %
    % display() - displays the object's information
    %
    % draw() - draws the object in the current axes
    %
    % rotate( rot_axis, rot_angle ) - rotate the surface by rot_angle
    % (radians) about the 1x3 rotation axis.

### Plane
    % PLANE implements a planar refracting or reflecting surface, e.g. one
    % face of a prism or a mirror
    %
    % Member functions:
    %
    % p = Plane( r, D, glass ) - circular planar surface constructor
    % INPUT:
    % r - 1x3 position vector
    % D - surface diameter
    % glass - 1 x 3 cell array of two strings, e.g., { 'air' 'acrylic' }
    % OUTPUT:
    % p - plane object
    %
    % p = Plane( r, w, h, glass ) - rectangular planar surface constructor
    % INPUT:
    % r - 1x3 position vector
    % w - width
    % h - height
    % glass - 1 x 3 cell array of two strings, e.g., { 'air' 'acrylic' }
    % OUTPUT:
    % p - plane object
    %
    % p.display() - displays the plane p information
    %
    % p.draw() - draws the plane p in the current axes
    % 
    % p.rotate( rot_axis, rot_angle ) - rotate the plane p
    % INPUT:
    %   rot_axis - 1x3 vector defining the rotation axis
    %   rot_angle - rotation angle (radians)

## General Notes on Use of Library

Things to be aware of, problems run into, and notes on specific examples.

### Example 1
Models an aperture, 2 lenses, and a screen with focal points shown. 
* The white dot on the screen is the convergence focal point
*  The yellow dot on the screen is the standard deviation focal point

### Example 2
Models a human eye using the Eye class. Not super useful to our tasks, very specific to a human eye. See the Eye class for more information on how the class was created if interested.

### Example 3
Also uses the Eye class. “Demonstrates accommodation of the human eye by minimizing the retinal image”.

### Example 4
Models a rectangular aperture, a ‘coslens’ from the GeneralLens class, a typical lens, 2 planes, each rotated about a different axis, and a screen. Outputs an image model and display of the image received by the screen. 
* ‘coslens’ is an option for the func parameter of GeneralLens
* Cannot find a list of accepted strings to func
* Coslens.m describes m but defines 4 input to the function – are these set to a default somewhere??

### Example 5
Introduces planar mirrors. 
* If Plane has 3 inputs, it generates a circular mirror, the second of which is its diameter
* If Plane has 4 inputs it generates a rectangular mirror, the second and third being its width and height respectively
* The last input in either case is a set of two strings, each in single quotes, with no comma in between, enclosed in curly brackets, referred to as ‘glass’ in comments
o  ie. { ‘air’ ‘acrylic’ }
o ORDER MATTERS! Defines the orientation of the mirror, ie which surface is reflective
* Strings found so far to be acceptable as func:
o Air
o Acrylic
o Mirror 

### Example 6
A refactor telescope! Uses planar and parabolic mirrors.
* Change “arrows” to “lines” in the input to bench.draw ( … ) to get a better idea of what’s happening.

### Example 7
“Test a Fresnel Lens with quadric rings”. Don’t think we’ll need this one. 

### Example 8
“Test a lens with polynomial aspheric terms”.

### Example 9
“Test cone mirrors”.

### Example 10
“Test cylinder and cone surfaces with double refraction.”

### Example 11
“Demonstrates ray tracing for rays originating inside the human eye”

### Example 12
“Draw a lens and determine its front surface, back surface, and total height. Make an animated gif of the lens and an engineering drawing of the lens.”

### Example 13
“Test refraction through the lens edge and backward rays refraction using the sub-aperture Maksutov-Cassegrain telescope design”

### Example 14
“Test astigmatic lens surfaces. The same as example1, but with an astigmatic front surface of the lens. The z (vertical dimension) curvature is changed here to produce vertical defocus.”

### Example 15
“Simulate a hexagonal array of spherical microlenses”

### Example 16
“Export STL files of various lenses”

## Installation Instructions
1. Download zip file from https://github.com/caiuspetronius/Optometrika
2. Extract the folder to a location on your computer
3. Open ‘example1.m’ from the folder
4. Matlab will prompt you that the location is not part of your file path, select the option to add the path to your directory

## Tip & Tricks
Things that aren’t crucial to using the library, but may be useful regardless.
* After running the simulation, type ‘close all’ into the command window to close all open matlab figures
* The position vectors for placing elements describe the position of the center of the elements, ie. The center point of a spherical lens, regardless of the curvature
