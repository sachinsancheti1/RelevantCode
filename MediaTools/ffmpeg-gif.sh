ffmpeg \
  -i dupleix-house.mp4 \
  -r 15 \
  -vf scale=512:-1 \
  -ss 00:07:52 -to 00:08:20 \
  dupleix-house-preview.gif