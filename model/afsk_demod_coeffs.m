%sample rate
fs = 12000

format long

% bpf 1200
% bw is 400, so passband is [800, 1600]
% f_normalized = f / sample rate
%b = fir1(35,[800/fs 1600/fs]);
%[H1, W1] = freqz(b,1,512)

% bpf 2400
% bw is 400, so passband is [2000, 2800]
% f_normalized = f / sample rate
%c = fir1(35,[2000/fs 2800/fs])
%[H2, W2] = freqz(c,1,512)

%subplot(1,1,1)
%plot(W1, 20*log10(abs(H1)))
%hold on
%plot(W2, 20*log10(abs(H2)))

% lpf cutoff 1000Hz
% f_normalized = f / sample rate
%d = fir1(23,[1000/fs], 'low');
%freqz(d,1,512)
