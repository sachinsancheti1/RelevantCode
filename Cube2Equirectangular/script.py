import cv2
import numpy as np

# Step 1: Load the Vertical Strip Image
cubemap_img = cv2.imread("image.jpg")  # Use the provided original vertical strip
height, width, _ = cubemap_img.shape
face_height = height // 6  # Each face is 1/6th of the total height

# Step 2: Split the Vertical Strip into Individual Faces
right = cubemap_img[0:face_height, :, :]
left = cubemap_img[face_height:2*face_height, :, :]
top = cubemap_img[2*face_height:3*face_height, :, :]
bottom = cubemap_img[3*face_height:4*face_height, :, :]
back = cubemap_img[4*face_height:5*face_height, :, :]
front = cubemap_img[5*face_height:6*face_height, :, :]

# Step 3: Create the Correct Dice Layout
# The expected layout for py360convert is:
#      +-------+
#      |  top  |
# +----+----+----+----+
# |left|front|right|back|
# +----+----+----+----+
#      | bottom |
#      +-------+

# Dimensions for the dice layout
face_width = front.shape[1]
dice_width = face_width * 4
dice_height = face_height * 3

# Create a blank canvas for the dice layout
dice_layout = np.zeros((dice_height, dice_width, 3), dtype=front.dtype)

# Place the faces in their correct positions
dice_layout[0:face_height, face_width:2*face_width, :] = top      # Top
dice_layout[face_height:2*face_height, 0:face_width, :] = left    # Left
dice_layout[face_height:2*face_height, face_width:2*face_width, :] = front  # Front
dice_layout[face_height:2*face_height, 2*face_width:3*face_width, :] = right  # Right
dice_layout[face_height:2*face_height, 3*face_width:4*face_width, :] = back  # Back
dice_layout[2*face_height:3*face_height, face_width:2*face_width, :] = bottom  # Bottom

# Step 4: Save the Dice Layout for Verification
cv2.imwrite("corrected_dice_layout.jpg", dice_layout)

# Step 5: Convert Dice Layout to Equirectangular
import py360convert

# Convert the dice layout to an equirectangular projection
equirect_img = py360convert.c2e(dice_layout, h=1024, w=2048)

# Step 6: Save the Equirectangular Output
cv2.imwrite("corrected_equirectangular_output.jpg", equirect_img)

# Print Completion Message
print("Conversion complete!")
print("Dice Layout saved as: corrected_dice_layout.jpg")
print("Equirectangular Output saved as: corrected_equirectangular_output.jpg")
