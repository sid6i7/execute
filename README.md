
# Fashion Recommendation System

A simple fashion recommendation system that can recommend the users items similar to something that they like. A user can input a clothing image and he will get several similar looking recommendations.

The tech-stack used:

**Frontend**: Flutter and dart <br>
**Backend**: Django and python



## Directory Structure

├── backend <br>
│────├─ backend <br>
│────├─ model <br>
│────├─ manage.py <br>
│   
├── frontend <br>
│   
├── models <br>
│────├── detector <br>
│──────────└── dataset <br>
│───────────────└── images <br>
│───────────────└── styles.csv <br>
│     
├── config.py <br>
│   
├── controller.py <br>
## Steps

1. **Data-Collection**: A kaggle [dataset](https://www.kaggle.com/datasets/paramaggarwal/fashion-product-images-small) was used, it consists of about 44000 images spanning across 140 categories of clothing.

2. **Data-Preprocessing**: 

- Added a new column which consisted of image_path (pointed to the images folder) for each product_id.

- Images were converted into feature vectors using a pre-trained vgg16 model (with output layer removed)

![VGG16 Architecture](https://media.geeksforgeeks.org/wp-content/uploads/20200219152327/conv-layers-vgg16.jpg)


3. **Prediction**:

- For a new input image, first it gets pre-processed and then cosine similarities are calculated for the new image feature vector and the remaining image vectors (that belong to the new image clothing category)

- N most similar items are the output

