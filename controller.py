import sys
sys.path.insert(0, 'models')
from config import *
from models.detector.detector import *

def find_similar(image, category):
    model = Classifier()
    items = model.predict_similar(image, category, 5)
    # print(items)
    return items