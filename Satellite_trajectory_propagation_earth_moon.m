% Define constants
G = 6.67430e-11; % Gravitational constant in m^3 kg^-1 s^-2
M_earth = 5.972e24; % Mass of Earth in kg
M_moon = 7.348e22; % Mass of Moon in kg
R_earth = 6371e3; % Radius of Earth in m
R_moon = 1737e3; % Radius of Moon in m
d = 384400e3; % Distance between Earth and Moon in m
delay = 0.1; % Delay between frames in seconds
nframes = 200; % Number of frames to generate
filename = 'live_plot.gif'; % Name of the GIF file

% Initial conditions
r0_sat = [R_earth+1000e3, 0]; % Initial position of satellite (in meters from the center of the Earth)
v0_sat = [0, sqrt(G*M_earth/norm(r0_sat))+2977.5]; % Initial velocity of satellite (tangential)
r0_moon = [d, 0]; % Initial position of moon (in meters from the center of the Earth)
v0_moon = [0, sqrt(G*M_earth/norm(r0_moon))]; % Initial velocity of moon (tangential)

% Define the system of differential equations
f = @(t, y) [y(3); y(4); 
    -G*(M_earth*y(1)/norm(y(1:2))^3 + M_moon*(y(1)-y(5))/norm(y(1:2)-y(5:6))^3); 
    -G*(M_earth*y(2)/norm(y(1:2))^3 + M_moon*(y(2)-y(6))/norm(y(1:2)-y(5:6))^3); 
    y(7); 
    y(8); 
    -G*(M_earth*y(5)/norm(y(5:6))^3); 
    -G*(M_earth*y(6)/norm(y(5:6))^3)];

% Define a more detailed time vector
tspan = linspace(0, 20*86400, 7000);

% Solve the system using ode45
[t, y] = ode45(f, tspan, [r0_sat, v0_sat, r0_moon, v0_moon]);

% Plot the satellite's and moon's trajectories
figure
h_earth = plot(y(1,1), y(1,2), 'b');
hold on
h_sat = plot(y(1,3), y(1,4), 'r');
h_moon = plot(y(1,7), y(1,8), 'g');
axis equal
title('Satellite and Moon Motion Simulation')
xlabel('x (m)')
ylabel('y (m)')

% Add markers for the satellite and moon
earth = plot(y(1,1), y(1,2), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
satellite = plot(y(1,3), y(1,4), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
moon = plot(y(1,7), y(1,8), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

% Calculate the distance between the satellite and the Moon at each time step
dist = sqrt((y(:,3)-y(:,7)).^2 + (y(:,4)-y(:,8)).^2);

% Find the minimum distance
[min_dist, idx] = min(dist);

% Convert the time at closest approach from seconds to hours, minutes, and seconds
closest_approach_time = datestr(t(idx)/86400, 'HH:MM:SS');

% Display the closest approach and annotations
text(-2.8e8, 1e8, ['Closest approach: ', num2str(min_dist/1e3), ' km at t = ', closest_approach_time])
text(0,-0.3e8,'Earth')

%Create the file and write the header
imwrite(im, map, filename, 'gif', 'Loopcount', inf, 'DelayTime', delay);

% Update the plot in real time
for k = 2:length(t)
    set(h_sat, 'XData', y(1:k,1), 'YData', y(1:k,2));
    set(satellite, 'XData', y(k,1), 'YData', y(k,2));
    set(h_moon, 'XData', y(1:k,5), 'YData', y(1:k,6));
    set(moon, 'XData', y(k,5), 'YData', y(k,6));
    
    % Select only every 100th frame of simulation
    if mod(k, 100) == 0
        
        % Capture the frame
        frame = getframe(gcf);

        % Convert the frame to an indexed image
        [im, map] = rgb2ind(frame.cdata, 256, 'nodither');

        % For the subsequent frames, append to the file
        imwrite(im, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
   
    end
   
end
