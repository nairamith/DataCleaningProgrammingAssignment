

The getConsolidatedDf function consolidates all the columns available in the folder and merges it into one dataframe. 
The readings are taken from the x_train and x_test files available in the folder. The column names for the readings are taken from the features.txt file.
Once the consolidated train and test dataframes are obtained, both of them are merged using rbind.
To label the column names correctly, the reading columns are split on the basis of ‘-’ and arranged correctly to form a meaningful column name.
To assign descriptive activity names to the column Activity, the column is casted into a factor variable. The levels are obtained from the first column of activity_labels and the descriptive labels are obtained from the second column of activity_labels.
The aggregated dataframe is then obtained by grouping the columns subjectid and activity and then summarized. The dplyr package is used for this process. 
