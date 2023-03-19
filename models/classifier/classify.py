from keras.applications import vgg16
from tensorflow.keras.utils import load_img, img_to_array
from keras.models import Model
from keras.applications.imagenet_utils import preprocess_input
import base64
from io import BytesIO
from PIL import Image
import os
import matplotlib.pyplot as plt
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
import random
from config import *

class Classifier():
    def __init__(self) -> None:
        model = vgg16.VGG16(weights='imagenet')
        self.model = Model(inputs=model.input,
              outputs=model.get_layer("fc2").output)
        self.df_path = DF_DIR
        self.img_dir = IMG_DIR
        self.img_size = IMG_SIZE
        self.limit_images = IMG_SIZE
        self.num_outputs = NUM_OUTPUTS
    
    def get_feature_vectors(self, category):
        df = pd.read_csv(self.df_path, on_bad_lines='skip')
        df['img'] = df['id'].apply(lambda x: os.path.join(self.img_dir, str(x) + ".jpg"))

        df_cat = (df.loc[df['articleType'] == category])
        # remove_n = df_cat.shape[0] // 2
        # drop_indices = np.random.choice(df.index, remove_n, replace=False)
        # df_cat = df_cat.drop(drop_indices)
        files = df_cat.img

        importedImages = []

        for f in files:
            filename = f
            original = load_img(filename, target_size=(224, 224))
            numpy_image = img_to_array(original)
            image_batch = np.expand_dims(numpy_image, axis=0)

            importedImages.append(image_batch)

        images = np.vstack(importedImages)

        processed_imgs = preprocess_input(images.copy())
        print(len(processed_imgs))
        features = self.model.predict(processed_imgs)
        return features, df_cat


    def predict_similar(self, image, category):
        original = np.asarray(image)
        numpy_image = img_to_array(original)
        image_batch = np.expand_dims(numpy_image, axis=0)
        processed_image = preprocess_input(image_batch.copy())
        new_img_feature = self.model.predict(processed_image)
        features, df_cat = self.get_feature_vectors(category)
        similarities = cosine_similarity(new_img_feature, features).squeeze()

        max_indices = np.argsort(similarities)[::-1][:self.num_outputs]
        similar_items = []

        for idx in max_indices:
            item = df_cat.iloc[idx].img
            img = Image.open(item)
            with BytesIO() as output:
                img.save(output, format='JPEG')
                bytes = output.getvalue()
                similar_items.append(base64.b64encode(bytes).decode('utf-8'))
        return similar_items
