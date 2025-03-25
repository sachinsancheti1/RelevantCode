ffmpeg -i careers-m.mp4 -vf "select=between(mod(n\, 30)\, 0\, 0), setpts=N/24/TB" careers-m.png
ffmpeg -i home-m.mp4 -vf "select=between(mod(n\, 30)\, 0\, 0), setpts=N/24/TB" home-m.png