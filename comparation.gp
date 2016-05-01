reset

set xlabel 'Bitrate (kbps)'
set ylabel 'Scaled PSNR (dB)'

set term png

set output 'comparation.png'

plot using[20:50][0:30000] ''
