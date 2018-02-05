
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
get_ipython().magic('matplotlib inline')
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix

df = pd.read_csv('Main.csv')

df['establishment_category'] = df['establishment_category'].astype('category')
df['inspection_category'] = df['inspection_category'].astype('category')
df['risk_category_factor']=df['risk_category_factor'].astype('category')
df['season_inspection'] = df['season_inspection'].astype('category')
df['year'] = df['year'].astype('category')


df1 = df[['risk_category_factor', 'year', 'season_inspection', 'inspection_category', 'establishment_category', 
        'month_inspection', 'noncritical_left', 'ifnoncritical', 'critical_left', 'ifcritical', 
         'core_left', 'priority_foundation_left', 'priority_left', 'ifcore', 'ifpriorityfoundation', 'ifpriority', 
         'total_violations', 'priority_violations', 'priority_violations_corrected_on_site', 
          'priority_violations_repeated', 'priority_foundation_violations', 
          'priority_foundation_violations_corrected_on_site', 'priority_foundation_violations_repeated',
          'core_violations', 'core_violations_corrected_on_site', 'core_violations_repeated', 'critical_violations', 
          'critical_violations_corrected_on_site', 'critical_violations_repeated', 'noncritical_violations', 
          'noncritical_violations_corrected_on_site', 'noncritical_violations_repeated']]


df_key_predictors = df1[['establishment_category','year', 'inspection_category', 
                                                 'risk_category_factor', 'season_inspection']]
df_key_dummies = pd.get_dummies(df_key_predictors, columns = ['establishment_category','year', 'inspection_category', 
                                                 'risk_category_factor', 'season_inspection'])

df_with_dummies = pd.get_dummies( df1, columns = ['establishment_category','year', 'inspection_category', 
                                                 'risk_category_factor', 'season_inspection'])

df2 = df_with_dummies.drop(['ifcore', 'ifcritical', 'ifnoncritical', 'ifpriority', 'ifpriorityfoundation'], axis=1)

df3 = df_with_dummies[['ifcore', 'ifcritical', 'ifnoncritical', 'ifpriority', 'ifpriorityfoundation']]

df2.fillna(0, axis = 1, inplace = True)

df3.fillna(-1.0, inplace = True)



# # Critical Violations

#Random Forest
X = df_key_dummies
y = df3['ifcritical']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=101)
rfc = RandomForestClassifier(n_estimators=200)
rfc.fit(X_train, y_train)
rfc_pred = rfc.predict(X_test)

print(classification_report(rfc_pred, y_test))
print('\n')
print(confusion_matrix(rfc_pred, y_test))


# SVC
X = df_key_dummies
y = df3['ifcritical']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=101)

from sklearn.svm import SVC
svc = SVC()
svc.fit(X_train, y_train)
predictions = svc.predict(X_test)

print('Classification Report')
print(classification_report(predictions, y_test))
print('\n')
print('Confusion Matrix')
print(confusion_matrix(predictions, y_test))

