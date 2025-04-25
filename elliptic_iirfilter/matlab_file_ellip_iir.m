fs = 50000; %frecuencia de muestreo 

wp = [200 20000] / (fs/2); %passband,
ws = [100 24000] / (fs/2); %stopband,

rp = 1; %ripple permitido en banda de paso dB
rs = 60; %atenuacion minima en banda de rechazo

[n, wn] = ellipord(wp, ws, rp, rs); %calculo de orden minimo del filtro
%n-orden min filtro, wn-frec de corte ajustadas
[b, a] = ellip(n, rp, rs, wn, 'bandpass');
%calculo de coef
%usando el orden n, ripple rp, atenuacion rs
%y las frecuencias wn

%b-coef del numerador
%a-coef del denominador

[sos, g] = tf2sos(b,a);
fvtool(sos, g);

