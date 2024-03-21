#define NUM_SAMPLES 64
#define SAMPLE_RATE 12000

#define BPF_1200_NUM_COEFFS 36
#define BPF_2400_NUM_COEFFS 36

#define LPF_1000_NUM_COEFFS 24

// afsk_signal_sampled[0] is signal at sample n
// afsk_signal_sampled[1] is signal at sample n-1
// ...
// Similar for all other intermediate signals

// This is the 12-bit sampled afsk signal (from demodulated FM signal)
float afsk_signal_sampled[NUM_SAMPLES];

// This is the afsk signal after 1200Hz/2400Hz BPF
float afsk_signal_1200[NUM_SAMPLES];
float afsk_signal_2400[NUM_SAMPLES];

// This is the afsk signal after squaring
float afsk_signal_1200_sq[NUM_SAMPLES];
float afsk_signal_2400_sq[NUM_SAMPLES];

// Decision signals
float afsk_signal_1200_decision[NUM_SAMPLES];
float afsk_signal_2400_decision[NUM_SAMPLES];

// Bitstream signal
float ax_25_bitstream[NUM_SAMPLES];

// FIR BPF coefficients, coeff order is [0] = b0, [1] = b1, ..., [35] = b35
// *Coefficients generated used MATLAB fir1
const float bpf_1200_coeffs [36] = 
{
    0.003448741717791,
    0.002623229649989,
    0.001217116733237,
    -0.001726858604060, 
    -0.007102141927435,
    -0.015281054146312
    -0.025727532711928,  
    -0.036830974418939,
    -0.046060124177076,  
    -0.050446018838251,  
    -0.047300630734074,  
    -0.034994100063707,
    -0.013575554194034,   
    0.014954698158660,   
    0.046833116368556,   
    0.077174245500208,
    0.100935128999819,   
    0.113979055940613,   
    0.113979055940613,   
    0.100935128999819,
    0.077174245500208,   
    0.046833116368556,   
    0.014954698158660,  
    -0.013575554194034,
    -0.034994100063707,  
    -0.047300630734074,  
    -0.050446018838251,  
    -0.046060124177076,
    -0.036830974418939,  
    -0.025727532711928,  
    -0.015281054146312,  
    -0.007102141927435,
    -0.001726858604060,   
    0.001217116733237,   
    0.002623229649989,   
    0.003448741717791
};

const float bpf_2400_coeffs [36] = 
{
    -0.000000000000000,  
    -0.003392094763377,  
    -0.007390364538001,  
    -0.010485530468097,
    -0.009183770258510,   
    0.000000000000000,   
    0.016951014049470,   
    0.035420880350297,
    0.044296687044943,   
    0.033237200925628,  
    -0.000000000000000,  
    -0.045250824141792,
    -0.082431119020501,  
    -0.090805317132018,  
    -0.060559840343015,   
    0.000000000000000,
    0.066502793288365,   
    0.109615305231683,   
    0.109615305231683,   
    0.066502793288365,
    0.000000000000000,  
    -0.060559840343015,  
    -0.090805317132018,  
    -0.082431119020501,
    -0.045250824141792,  
    -0.000000000000000,   
    0.033237200925628,   
    0.044296687044943,
    0.035420880350297,   
    0.016951014049470,   
    0.000000000000000,  
    -0.009183770258510,
    -0.010485530468097,  
    -0.007390364538001,  
    -0.003392094763377,  
    -0.000000000000000
};

// FIR LPF coefficients
const float lpf_1000_coeffs [24] = 
{
    0.000350515291980,   
    0.001365523151696,   
    0.003635471333180,   
    0.008143712362446,
    0.015614742227482,   
    0.026284910718651,   
    0.039760955673100,   
    0.055005659942096,
    0.070462634134052,   
    0.084301061279787,   
    0.094733426442426,   
    0.100341387443104,
    0.100341387443104,   
    0.094733426442426,   
    0.084301061279787,   
    0.070462634134052,
    0.055005659942096,  
    0.039760955673100,   
    0.026284910718651,   
    0.015614742227482,
    0.008143712362446,   
    0.003635471333180,   
    0.001365523151696,   
    0.000350515291980
};

// Center freq 1200Hz, BW of 400Hz
float bpf_1200 (float* signal)
{
    float sum = 0;
    for (int i = 0 ; i < BPF_1200_NUM_COEFFS ; i++)
    {
        sum += signal[i]*bpf_1200_coeffs[i];
    }
    return sum; 
}

// Center freq 2400Hz, BW of 400Hz
float bpf_2400 (float* signal)
{
    float sum = 0;
    for (int i = 0 ; i < BPF_2400_NUM_COEFFS ; i++)
    {
        sum += signal[i]*bpf_2400_coeffs[i];
    }
    return sum; 
}

// Cutoff freq 1000Hz, BUT should be a little less than AX25 signal bit rate
// MAY NEED TO TUNE
float lpf_1000 (float* signal)
{
    float sum = 0;
    for (int i = 0 ; i < LPF_1000_NUM_COEFFS ; i++)
    {
        sum += signal[i]*lpf_1000_coeffs[i];
    }
    return sum; 
}

// this is the main function
void afsk_demod (void)
{
    // This is a single cycle for 1 output sample
    while(1)
    {
        // 1200 Hz BPF
        afsk_signal_1200[0] = bpf_1200(afsk_signal_sampled);
        // 2400 Hz BPF
        afsk_signal_2400[0] = bpf_2400(afsk_signal_sampled);

        // 1200 Hz Envelope detect (square + LPF)
        afsk_signal_1200_sq[0] = afsk_signal_1200_sq[0] * afsk_signal_1200_sq[0];
        afsk_signal_1200_decision[0] = lpf_1000(afsk_signal_1200_sq);

        // 2400 Hz Envelope detect (square + LPF)
        afsk_signal_2400_sq[0] = afsk_signal_2400_sq[0] * afsk_signal_2400_sq[0];
        afsk_signal_2400_decision[0] = lpf_1000(afsk_signal_2400_sq);

        // Decision = mark(1) - space(0)
        ax_25_bitstream[0] = afsk_signal_2400_decision[0] - afsk_signal_1200_decision[0];

        // SHIFT DATA AND LOOP BACK HERE
    }
    // **Will need separate algorithm to recover bit clock
    // ax_25_bitstream is the ax_packet data stream
}

// AFSK Noncoherent Demodulation diagram (envelope detection method)

//                            ______________       ________       _____________
//                           |              |     |        |     |             |
//                     |---->|  BPF 1200 Hz |---->| Square |---->| LPF 1000 Hz |---| 
//                     |     |______________|     |________|     |_____________|   | 
//                     |                                                           |     __________
//                     |                                                           |--->|          |     ax25 bits
// --->   IN   ------->|                                                                | Decision | -> OUT 010101
//                     |                                                           |--->|__________|
//                     |      ______________       ________       _____________    |                               
//                     |     |              |     |        |     |             |   | 
//                     |---->|  BPF 2400 Hz |---->| Square |---->| LPF 1000 Hz |---|
//                           |______________|     |________|     |_____________| 

