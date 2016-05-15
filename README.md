#Arthor: Yen-Kwan Wu
#
# Verify_Netflix_Per-Title_Encode_Optimization
Use ffmpeg and x265( HEVC) to verify the Per-Title_Encode_Optimization by Netflix
I just test the file in 4K at http://media.xiph.org/video/derf/ (I try the Netflix_Narrator)

#Refernce
Netflix tech blog: http://techblog.netflix.com/2015/12/per-title-encode-optimization.html

#Verify Flow
1. Reduce Frame
2. Down Sampling
3. HEVC encoding with diff QP
4. Decode HEVC
5. Up sampling
6. Calculate PSNR
7. Generate picture PSNR vs Bitrate by gnuplot

#Usage
  sudo bash script.sh [Vedio File Path] [Resolution 1] [Resolution 2] ...

#Example:
  sudo bash script.sh Netflix.y4m 3072x1620 2048x1080 1536x810 1024x540

#Defalut Configuration
1. reduce frame to 128
2. At begining, you should determine the interval of QP ( start with QP=0, which means the best quality and QP no more than 51)
3. I jsut test the .y4m file with 4096x2160 and not try for others

#Contact with me
If you have any questions, please don't mind reporting to me
  c14006078@gmail.com 
