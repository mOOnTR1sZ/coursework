clear all;
clc;

nano_multiplier = 10^9; %to transform plot x axis into acceptable form

a = 10; % aperture radius
c = 3e+8; % speed of light, m/sec
one_t_h = 9*pi/180;
    
lambda = a/10;
N_FFT = 8192*2;
T = 100/c*lambda;
d_t = T/(N_FFT - 1);

t_h = (0:0.2:10)*pi/180; % Theta angle
t = -T/2:d_t:T/2;
t_demonstrate = -5.5*(10^-9):0.01*(10^-9):5.5*(10^-9); % For reasonable plot display

%calculation
% f_norm = calc_f_norm(one_t_h, a, c, t_demonstrate);
t_actual = t_demonstrate;
ro = one_t_h;
f_norm = zeros(1, length(t_actual));
i = find(abs(c*t_actual) < a * sin(ro));
f_norm(i) = (1/(pi*sin(ro)^2))*sqrt((a*sin(ro))^2-(c*t_actual(i)).^2);

% f_fal = calc_f_fal(one_t_h, 1, a, c, t_demonstrate);
t_actual = t_demonstrate;
ro = one_t_h;
n = 1;
f_fal = zeros(1, length(t_actual));
i = find(abs(c*t_actual) < a * sin(ro));
f_fal(i) = (1/(pi*sin(ro)^2))*sqrt((a*sin(ro))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro))^2))).^n;

% f_fal_2 = calc_f_fal(one_t_h, 2, a, c, t_demonstrate);
t_actual = t_demonstrate;
ro = one_t_h;
n = 2;
f_fal_2 = zeros(1, length(t_actual));
i = find(abs(c*t_actual) < a * sin(ro));
f_fal_2(i) = (1/(pi*sin(ro)^2))*sqrt((a*sin(ro))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro))^2))).^n;

% 1st plot (norm, falling n=1, falling n=2)
% Transient far fields of circular flat aperture for different field amplitude distributions over the amplitude
figure
plot(t_demonstrate*nano_multiplier, f_norm, 'k')
hold on
plot(t_demonstrate*nano_multiplier, f_fal, '--k')
plot(t_demonstrate*nano_multiplier, f_fal_2, '-.k')
grid on
hold off
title('Transient far fields of circular flat aperture. a = 10 m. \theta = 9^o')
xlabel('Time, ns')
ylabel('Amplitude')
legend('Uniform distribution', 'Falling distribution. n=1', 'Falling distribution. n=2')

% 2nd plot (norm, falling n=1, falling n=2)
% Derivatives of transient far fields or three electric field distributions
figure
n = size(t_demonstrate,2);

% norm
f_der = diff(f_norm) ./ diff(t_demonstrate);
f_der = f_der ./ norm(f_der, n);
plot(t_demonstrate(1: end - 1)*nano_multiplier, f_der, 'k')

hold on

% falling 1
f_der = diff(f_fal) ./ diff(t_demonstrate);
f_der = f_der ./ norm(f_der, n);
plot(t_demonstrate(1: end - 1)*nano_multiplier,  f_der, '--k')

%falling 2
f_der = diff(f_fal_2) ./ diff(t_demonstrate);
f_der = f_der ./ norm(f_der, n);
plot(t_demonstrate(1: end - 1)*nano_multiplier,  f_der, '-.k')

grid on
hold off    
title('Derivatives of transient far fields. a = 10 m. \theta = 9^o')
xlabel('Time, ns')
ylabel('Normilized Amplitude')
legend('Uniform distribution', 'Falling distribution. n=1', 'Falling distribution. n=2')


% 3rd plot (norm, falling n=1, falling n=2)
% Far field antenna patterns for monochromatic signal
for j = 1 : size(t_h, 2)
    i_t_h = t_h(j);
    t_actual = t/2;
    ro = i_t_h;  
    
    % norm
    % E_f_norm(j, :) = calc_f_norm(i_t_h, a, c, t);
    E_f_norm(j, :) = zeros(1, length(t_actual));
    i = find(abs(c*t_actual) < a * sin(ro+0.01));
    %
    %
    %
    E_f_norm(j, i) = (1/(pi*sin(ro+0.01)^2))*sqrt((a*sin(ro+0.01))^2-(c*t_actual(i)).^2);
    %
    %
    %
    E_f_norm(j, :) = fft(E_f_norm(j, :), N_FFT);
    
    % falling 1
    % E_f_fal_1(j, :) = calc_f_fal(i_t_h, 1, a, c, t);
    n = 1;
    E_f_fal_1(j, :) = zeros(1, length(t_actual));
    i = find(abs(c*t_actual) < a * sin(ro+0.02));
    E_f_fal_1(j, i) = (1/(pi*sin(ro+0.02)^2))*sqrt((a*sin(ro+0.02))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro+0.02))^2))).^n;
    E_f_fal_1(j, :) = fft(E_f_fal_1(j, :), N_FFT);
    
    % falling 2
    % E_f_fal_2(j, :) = calc_f_fal(i_t_h, 2, a, c, t);
    n = 2;
    E_f_fal_2(j, :) = zeros(1, length(t_actual));
    i = find(abs(c*t_actual) < a * sin(ro+0.03));
    E_f_fal_2(j, i) = (1/(pi*sin(ro+0.03)^2))*sqrt((a*sin(ro+0.03))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro+0.03))^2))).^n;
    E_f_fal_2(j, :) = fft(E_f_fal_2(j, :), N_FFT);
end

d_f = 1/N_FFT/d_t;
k = 1:1:N_FFT/2;
[F, p] = min(abs(d_f*k - 3e+8/lambda));
figure
plot(4*a/lambda*sin(t_h), 20*log10(abs(E_f_norm(:, p))/max(abs(E_f_norm(:, p)))), 'k')
hold on
plot(4*a/lambda*sin(t_h), 20*log10(abs(E_f_fal_1(:, p))/max(abs(E_f_fal_1(:, p)))), '--k')
plot(4*a/lambda*sin(t_h), 20*log10(abs(E_f_fal_2(:, p))/max(abs(E_f_fal_2(:, p)))), '-.k')
grid on
hold off
title('Far field antenna patterns for monochromatic signal. a/\lambda = 10')
xlabel('2*a/\lambda*sin(\Theta)')
ylabel('Amplitude, dB')
legend('Uniform distribution', 'Falling distribution. n=1', 'Falling distribution. n=2')


    
%calculation
t_actual = t_demonstrate;
ro = one_t_h;

% f_fal_3 = calc_f_fal(one_t_h, 3, a, c, t_demonstrate);
n = 3;
f_fal_3 = zeros(1, length(t_actual));
i = find(abs(c*t_actual) < a * sin(ro));
f_fal_3(i) = (cos(ro)/(pi*sin(ro)^2))*sqrt((a*sin(ro))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro))^2))).^n;

% f_fal_4 = calc_f_fal(one_t_h, 4, a, c, t_demonstrate);
n = 4;
f_fal_4 = zeros(1, length(t_actual));
i = find(abs(c*t_actual) < a * sin(ro));
f_fal_4(i) = (cos(ro)/(pi*sin(ro)^2))*sqrt((a*sin(ro))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro))^2))).^n;

% f_fal_5 = calc_f_fal(one_t_h, 5, a, c, t_demonstrate);
n = 5;
f_fal_5 = zeros(1, length(t_actual));
i = find(abs(c*t_actual) < a * sin(ro));
f_fal_5(i) = (cos(ro)/(pi*sin(ro)^2))*sqrt((a*sin(ro))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro))^2))).^n;

% 1st plot (falling n=3, falling n=4, falling n=5)
% Transient far fields of circular flat aperture for different field amplitude distributions over the amplitude
figure
plot(t_demonstrate*nano_multiplier, f_fal_3, 'k')
hold on
plot(t_demonstrate*nano_multiplier, f_fal_4, '--k')
plot(t_demonstrate*nano_multiplier, f_fal_5, '-.k')
grid on
hold off
title('Transient far fields of circular flat aperture. a = 10 m. \theta = 9^o')
xlabel('Time, ns')
ylabel('Amplitude')
legend('Falling distribution. n=3', 'Falling distribution. n=4', 'Falling distribution. n=5')

% 2nd plot (falling n=3, falling n=4, falling n=5)
% Derivatives of transient far fields or three electric field distributions
figure
n = size(t_demonstrate, 2);

% falling n = 3
f_der = diff(f_fal_3) ./ diff(t_demonstrate);
f_der = f_der ./ norm(f_der, n);
plot(t_demonstrate(1: end - 1)*nano_multiplier,  f_der, 'k')

hold on

% falling n = 4
f_der = diff(f_fal_4) ./ diff(t_demonstrate);
f_der = f_der ./ norm(f_der, n);
plot(t_demonstrate(1: end - 1)*nano_multiplier,  f_der, '--k')

% falling n = 5
f_der = diff(f_fal_5) ./ diff(t_demonstrate);
f_der = f_der ./ norm(f_der, n);
plot(t_demonstrate(1: end - 1)*nano_multiplier,  f_der, '-.k')

grid on
hold off    
title('Derivatives of transient far fields. a = 10 m. \theta = 9^o')
xlabel('Time, ns')
ylabel('Normilized Amplitude')
legend('Falling distribution. n=3', 'Falling distribution. n=4', 'Falling distribution. n=5')

% 3rd plot (falling n=3, falling n=4, falling n=5)
% Far field antenna patterns for monochromatic signal
for j = 1 : size(t_h, 2)
    i_t_h = t_h(j);
    t_actual = t/2;
    ro = i_t_h;
    
    % falling n=3
    % E_f_fal_3(j, :) = calc_f_fal(i_t_h, 3, a, c, t);
    n = 3;
    E_f_fal_3(j, :) = zeros(1, length(t_actual));
    i = find(abs(c*t_actual) < a * sin(ro+0.04));
    E_f_fal_3(j, i) = (cos(ro+0.04)/(pi*sin(ro+0.04)^2))*sqrt((a*sin(ro+0.04))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro+0.04))^2))).^n;
    E_f_fal_3(j, :) = fft(E_f_fal_3(j, :), N_FFT);
    
    % falling n=4
    % E_f_fal_4(j, :) = calc_f_fal(i_t_h, 4, a, c, t);
    n = 4;
    E_f_fal_4(j, :) = zeros(1, length(t_actual));
    i = find(abs(c*t_actual) < a * sin(ro+0.05));
    E_f_fal_4(j, i) = (cos(ro+0.05)/(pi*sin(ro+0.05)^2))*sqrt((a*sin(ro+0.05))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro+0.05))^2))).^n;
    E_f_fal_4(j, :) = fft(E_f_fal_4(j, :), N_FFT);
    
    % falling n=5
    % E_f_fal_5(j, :) = calc_f_fal(i_t_h, 5, a, c, t);
    n = 5;
    E_f_fal_5(j, :) = zeros(1, length(t_actual));
    i = find(abs(c*t_actual) < a * sin(ro+0.06));
    E_f_fal_5(j, i) = (cos(ro+0.06)/(pi*sin(ro+0.06)^2))*sqrt((a*sin(ro+0.06))^2-(c*t_actual(i)).^2) .* (1-(((c*t_actual(i)).^2)/((a*sin(ro+0.06))^2))).^n;
    E_f_fal_5(j, :) = fft(E_f_fal_5(j, :), N_FFT);
end

d_f = 1/N_FFT/d_t;
k = 1:1:N_FFT/2;
[F, p] = min(abs(d_f*k - 3e+8/lambda));
figure
plot(4*a/lambda*sin(t_h), 20*log10(abs(E_f_fal_3(:, p))/max(abs(E_f_fal_3(:, p)))), 'k')
hold on
plot(4*a/lambda*sin(t_h), 20*log10(abs(E_f_fal_4(:, p))/max(abs(E_f_fal_4(:, p)))), '--k')
plot(4*a/lambda*sin(t_h), 20*log10(abs(E_f_fal_5(:, p))/max(abs(E_f_fal_5(:, p)))), '-.k')
grid on
hold off
title('Far field antenna patterns for monochromatic signal. a/\lambda = 10')
xlabel('2*a/\lambda*sin(\Theta)')
ylabel('Amplitude, dB')
legend('Falling distribution. n=3', 'Falling distribution. n=4', 'Falling distribution. n=5')