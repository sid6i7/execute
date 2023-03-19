import numpy as np
import cv2
import torch
import albumentations as albu
from pylab import imshow

from cloths_segmentation.pre_trained_models import create_model
from iglovikov_helper_functions.utils.image_utils import load_rgb, pad, unpad
from iglovikov_helper_functions.dl.pytorch.utils import tensor_from_rgb_image

class Segmenter():
    def __init__(self) -> None:
        self.model = create_model("Unet_2020-10-30")
        self.output_dir = "models/segmentation/output"
    
    def segment(self, img_src):
        """Removes background and returns only the clothing"""
        image = cv2.imread(img_src)
        transform = albu.Compose([albu.Normalize(p=1)], p=1)
        padded_image, pads = pad(image, factor=32, border=cv2.BORDER_CONSTANT)
        x = transform(image=padded_image)["image"]
        x = torch.unsqueeze(tensor_from_rgb_image(x), 0)
        with torch.no_grad():
            prediction = self.model(x)[0][0]
        mask = (prediction > 0).cpu().numpy().astype(np.uint8)
        mask = unpad(mask, pads) * 255
        
        clothing = cv2.bitwise_and(image, image, mask=mask)

        return clothing
        # cv2.imwrite(f"{self.output_dir}/masked_img.png", masked)
        # return cropped_img