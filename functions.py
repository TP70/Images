"""python"""
import numpy
import pickle
import sklearn
from skimage.transform import resize
from PIL import Image
#scikit-image


def rbgToPixelIntensities(image: numpy.array) -> numpy.array:  # : -> numpy.array:

    """ Convert images in RGB format (w x h x 3) to pixel intensities (w x h)

    Arguments:
        image (numpy.array): an input image in RGB format

    Returns:
        numpy.array: the input image expressed as grayscale pixel intensities
    """

    scaled = (255 - image) / 255

    return numpy.sqrt(scaled[:, :, 0] ** 2 + scaled[:, :, 1] ** 2 + scaled[:, :, 2] ** 2)


def photoToRGBFormat(image):
    """
    :param image: image in JPEG format
    :return: array of image in RGB format
    """
    # functions takes JPEG image from the user and returns it as a numpy array
    image = Image.open(image)
    return numpy.array(image)


if __name__ == '__main__':
    # Examples of inputting images into photo_to_array for testing
    photo = photoToRGBFormat("")

    # array images then scaled from RGB format to being expressed in grayscale pixel intensities
    photo = rbgToPixelIntensities(photo)

    # photo is then resized in order to create an 8x8 matrix, before being reshaped to a 1x64 vector
    photo = resize(photo, (8, 8))
    photo = photo.reshape(1, 64)
    print(photo)

    with open("classifier.pickle", "rb") as handle:
        classifier = pickle.load(handle)
        y_new = classifier.predict(photo)
        print(y_new)
