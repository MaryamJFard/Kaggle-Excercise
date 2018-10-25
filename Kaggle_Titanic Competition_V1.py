import pandas as pd
import numpy as np
from sklearn.metrics import mean_absolute_error
from sklearn.ensemble import RandomForestRegressor

#Path of the file to read
titanic_training_file_path = 'train.csv'
titanic_test_file_path = 'test.csv'

#Data frame
passenger_data_training = pd.read_csv(titanic_training_file_path) 
passenger_data_test = pd.read_csv(titanic_test_file_path)

#Treat the data
gender = {'male': 1,'female': 2}
passenger_data_training.Sex = [gender[item] for item in passenger_data_training.Sex]
passenger_data_test.Sex = [gender[item] for item in passenger_data_test.Sex]

#Target object
survived_training = passenger_data_training.Survived

#Appropriate features
features = ['Sex', 'Pclass', 'Age']

#Decisive data frame
decisiveDF_training = passenger_data_training[features]
decisiveDF_test = passenger_data_test[features]

#Treat the data
decisiveDF_training = decisiveDF_training.fillna(decisiveDF_training.mean())
decisiveDF_test = decisiveDF_test.fillna(decisiveDF_test.mean())


#Specify Model
titanic_model = RandomForestRegressor(random_state=1)

#Fit Model
titanic_model.fit(decisiveDF_training, survived_training)

val_predictions = titanic_model.predict(decisiveDF_test)

#Round prediction
rounded = [round(x) for x in val_predictions]

#Preparing the output
first_col = ['PassengerId']
val_predictions_formatted = passenger_data_test[first_col]
output = val_predictions_formatted.assign(Survived = rounded)

#Write the output dataframe into a .csv file
output.to_csv('Predictions.csv', index=False)
