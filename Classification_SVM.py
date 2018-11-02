import pandas as pd
import matplotlib.pyplot as plt, matplotlib.image as mpimg
from sklearn.model_selection import train_test_split
from sklearn import svm

#Load the data
labeled_images = pd.read_csv('../input/train.csv')

#Seperate images and labels for learning
images = labeled_images.iloc[0:5000,1:]
labels = labeled_images.iloc[0:5000,:1]

#Split our data into test and train sets, 0.8 data for train and 0.2 for test
train_images, test_images,train_labels, test_labels = train_test_split(images, labels, train_size=0.8, random_state=0)

#Load image into a numpy array and the reshape it, so that it is 2 dimensional (28*28 pixels)
i=1
img=train_images.iloc[i].as_matrix()
img=img.reshape((28,28))

plt.imshow(img,cmap='gray')
plt.title(train_labels.iloc[i,0])

#A histogram of this image's pixel values shows the range
plt.hist(train_images.iloc[i])


#First, we use the sklearn.svm module to create a vector classifier.
#Next, we pass our training images and labels to the classifier's fit method, which trains our model.
#Finally, the test images and labels are passed to the score method to see how well we trained our model. Fit will return a float between 0-1 indicating our accuracy on the test data set

clf = svm.SVC()
clf.fit(train_images, train_labels.values.ravel())
clf.score(test_images,test_labels)