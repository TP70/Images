# Model Hosting Challenge

Welcome to the model hosting challenge! This excercise is designed to give you an opportunity to show us your coding skills with a short programming task that reflects the real life problems we solve every day.

To take part in this challenge, clone the repository on your local machine and begin a new branch to write your code and solve the problems set out below. When you're done, simply commit your code and create a pull request so that your interviewer can review your work.

There's no time limit for the challenge but you shouldn't need to spend more than a couple of hours to solve the problem. Don't be carried away with extra stuff, quality is always preferred over quantity and being clean and concise with your solution is definitely an advantage.

You can approach the solution in whatever way you like, using the tools and architecture that you feel is most appropriate. Whatever method you choose, make sure your code is well structured, easy to read and well commented. Strong code collaboration is really important to us and we'd rather get code with errors than something that's too disorganised to work with.

Very best of luck!

----

## Introduction
This challenge requires you to host a pre-trained image classification model as a callable ReST API, using a python API framework of your choice.

This is a common task when integrating models with upstream and downstream clients. We want to see that you can design and implement an expressive API that exposes the functionality of the model to other systems. Importantly, you should not assume that systems consuming your API will be familiar with how your model works!

## The Problem

In this repository is a trained sklearn SVC model that predicts a numeric symbol based on a hand drawn image of size 8 x 8 pixels.

The task is to host this model behind an API, which allows users to submit jpeg images (examples of which can be found in data) and have the predicted class returned.

The image will have to be transformed for prediction as the model expects to take a (1, 64) vector of pixel intensities rather than RGB values. The input image will first need to be scaled and each pixel intensity calculated leaving an array of (8,8), that will then need to be unstacked into (1, 64). Values in the model input array should be integers that range from 0 to 16, white to black.

The following function will help you to convert between RGB and pixel intensities:

```python
import numpy

def rbgToPixelIntensities(image: numpy.array) - > numpy.array:
    """ Convert images in RGB format (w x h x 3) to pixel intensities (w x h)
    
    Arguments:
        image (numpy.array): an input image in RGB format
        
    Returns:
        numpy.array: the input image expressed as grayscale pixel intensities
    """
    
    scaled = (255 - image)/255
    
    return numpy.sqrt(scaled[:,:,0] ** 2 + scaled[:,:,1] ** 2 + scaled[:,:,2] ** 2)

```

The model has been pickled and can be reloaded with the following commands:

```python
import pickle

with open("model/classifier.pickle", "rb") as handle:
    classifier = pickle.load(handle)
```

Along with your API code, you should write tests that show the API works as expected. These can be written in your chosen API framework's testing suite or via unittest/pytest.


## Extras (completely optional and definitely not required!)

To take this a little further, you could

- Define a dockerfile to deploy your app as a container.

## Tips & hints

1. If your not familiar with an API framework yet, we'd suggest using *flask*, as it is powerful, lightweight and easy to pick up.
1. We recommend using *pillow* to interact with image files.
1. Don't overcomplicate your API, it only needs enough fuctionality to solve the problem.
1. Python *requests* is a powerful package for constructing HTTP requests to test your API.
