from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from PIL import Image
from io import BytesIO
# from .models import Search
# from .serializers import SearchSerializer, ImageSerializer
# import sys
# sys.path.insert(0, 'backend')
import os, sys
sys.path.insert(1, os.path.join(sys.path[0], '..'))
# import os
# print(os.getcwd())
import json
from controller import *
from config import *

@csrf_exempt
def recommend_view(request):
    if request.method == 'POST':
        image_data = request.FILES['picture'].read()
        image = Image.open(BytesIO(image_data)).resize((224, 224))
        items = find_similar(image);
        # Do something with the image
        # print(len(image))
        return JsonResponse({"items": json.dumps(items, ensure_ascii=False, encoding='base64')})
    else:
        return HttpResponse('Invalid request method.')
