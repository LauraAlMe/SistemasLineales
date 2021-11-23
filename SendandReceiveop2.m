clear
clc
%User Defined Properties

%CONSOLA SERIAL
s = serial('COM4', 'BaudRate', 9600);
fopen(s);                               %Abrir consola
pause(3);                               %delay
fprintf("Connection established\n")

%TABLA PROPIEDADES
plotTitle = 'Arduino Data Log';
xLabel = 'Time(s)';
yLabel = 'Theta';
legend1 = 'Sensor 1'
yMax  = 5
yMin  = 0
plotGrid = 'on';
min = 0;
max = 5;
delay = .01;
%Define Function Variables
time = 0;
data = 0;
count = 0;

theta=0:0.1:2*pi;
k=1;


%Set up Plot
plotGraph = plot(time,data,'-r' );
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
legend(legend1)
axis([yMin yMax min max]);
grid(plotGrid);
tic

while ishandle(plotGraph)
  fprintf(s, theta(k));
  k=k+1;
  out = fscanf(s, '%f\n');
  fprintf("%f\n",out)
  
  dat = out; 
  
  count = count + 1;
  if k==length(theta)
      k=1;
  end
  time(count) = toc;   
  data(count) = dat;        
  set(plotGraph,'XData',time,'YData',data);
  axis([0 time(count) min max]);
  pause(delay);
end
  
fclose(s);                  %Cerrar consola
delete(s)
clear s
disp('Plot Closed and arduino object has been deleted');
