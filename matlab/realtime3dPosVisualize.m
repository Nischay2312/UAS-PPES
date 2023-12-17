% Close all figures and clear workspace
close all;
clear all;

% Serial port setup
COMPort = 'COM3'; % Replace 'COMX' with your actual COM port
BaudRate = 921600;
sp = serialport(COMPort, BaudRate);

% Prepare the 3D plot
fig = figure;
h = plot3(0, 0, 0, 'Marker', '.', 'LineStyle', '-'); % Changed to dots
title('Real-Time 3D Trajectory');
grid on;
xlabel("X (m)");
ylabel("Y (m)");
zlabel("Z (m)");
hold on;
% limit1 = 0.2; %meters
% xlim([-1*limit1 limit1]);
% ylim([-1*limit1 limit1]);
% zlim([-1*limit1 limit1]);

% Create a stop button
stopButton = uicontrol('Style', 'pushbutton', 'String', 'Stop',...
                       'Position', [20 20 60 20],...
                       'Callback', 'stopLoop = true;');

% Create a clear plot button
clearButton = uicontrol('Style', 'pushbutton', 'String', 'Clear Plot',...
                        'Position', [100 20 100 20],...
                        'Callback', 'clearPlot = true;');

% Variable to control the loop
stopLoop = false;
clearPlot = false;

% Initialize variables for storing data
xData = [];
yData = [];
zData = [];

% Number of points to display
numPointsToDisplay = 50; % Change this value to your preference

% Data acquisition and plotting loop
try
    while ~stopLoop
        % Read data from serial port
        data = readline(sp);

        % Attempt to convert the data to numeric form
        dataVals = str2num(data); % Convert string to numeric array

        % Check if the data conversion was successful and has the correct length
        if ~isempty(dataVals) && length(dataVals) == 6
            Px = dataVals(1);
            Py = dataVals(2);
            Pz = dataVals(3);
            % Vx, Vy, Vz are ignored in this case but can be used as needed
            
            % Update data arrays
            xData = [xData, Px];
            yData = [yData, Py];
            zData = [zData, Pz];

            % Keep only the last X points
            % if length(xData) > numPointsToDisplay
            %     xData = xData(end-numPointsToDisplay+1:end);
            %     yData = yData(end-numPointsToDisplay+1:end);
            %     zData = zData(end-numPointsToDisplay+1:end);
            % end

            % Adaptive limit calculation
            % limit = max([abs([xData, yData, zData]), 1.0]); % Ensuring a minimum limit of 1.0
            % if(limit > limit1)
            %     xlim([-limit limit]);
            %     ylim([-limit limit]);
            %     zlim([-limit limit]);
            % end
            if clearPlot
                xData = [];
                yData = [];
                zData = [];
                clearPlot = false;
            end
            % Update the plot
            set(h, 'XData', xData, 'YData', yData, 'ZData', zData);
            drawnow;
        end

        % Check for button press
        drawnow; % Necessary to capture the button callback
    end
catch e
    disp('Stopped visualization.');
    disp(e.message);
end

% Clean-up code
clear sp;
disp('Serial port closed.');
