from random import seed
from random import randint

import numpy as np
from sklearn.cluster import KMeans
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
from scipy import stats


def PredictInACluster(numberForPrediction):
    # seed random number generator
    seed(1)
    # generate some integers
    listN = []
    for i in range(100):
        numE = []
        if i == 0:
            numE.insert(0, numberForPrediction)
        else:
            numE.insert(0,randint(-100, 500))
        listN.insert(0,numE)
    print(listN)

    X = np.array(listN)
    # print('Numbers X=',X)

    kmeans = KMeans(n_clusters=2)
    kmeans.fit(X)
    print("kmeans cluster centers =")
    print(kmeans.cluster_centers_)
    print("kmeans labels=")
    print(kmeans.labels_)
    y = kmeans.labels_
    #print("y clusters=")
    #print(y)

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)
    #print('X train')
    #print(X_train)

    linear_reg = LinearRegression()
    # Train the model using the training sets
    #X_test[0] = y_test[0] = numberForPrediction
    linear_reg.fit(X_train, y_train)

    # Make predictions using the testing set
    diabetes_y_pred = linear_reg.predict(X_test)

    # The coefficients
    print("Coefficients: \n", linear_reg.coef_)
    # The mean squared error
    print("Mean squared error: %.2f" % mean_squared_error(y_test, diabetes_y_pred))
    # The coefficient of determination: 1 is perfect prediction
    print("Coefficient of determination: %.2f" % r2_score(y_test, diabetes_y_pred))
    final_pred = linear_reg.predict([[numberForPrediction]])
    print("Prediction for", numberForPrediction,  "is", final_pred[0] * 500)

    return final_pred[0]
    
    
print('The predicted value is ',PredictInACluster(200))


