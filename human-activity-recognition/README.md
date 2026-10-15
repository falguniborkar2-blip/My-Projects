# Human Activity Recognition (UCI HAR)

Course project for Machine Learning and Data Mining at Masaryk University.

The task is to recognise 6 activities (walking, walking upstairs, walking downstairs, sitting,
standing, laying) from smartphone accelerometer and gyroscope features.

- Data: UCI HAR dataset, 561 features, 7,352 training and 2,947 test samples
- Notebook: [`har_classification.ipynb`](har_classification.ipynb)

## What I did

1. **Explored the data**: class balance, PCA and t-SNE plots, activity transitions, and outliers
   (17% of training rows have at least one feature with |z| > 5).
2. **Screened 5 models** with 5-fold stratified cross-validation: Naive Bayes, LDA, Logistic
   Regression, Linear SVM and Random Forest.
3. **Tuned hyperparameters** (C for the linear models, number of trees for Random Forest) and
   plotted learning curves.
4. **Compared the final models** with confusion matrices and McNemar significance tests.

## Results (macro F1 on the test set)

| Model | Test F1 |
|---|---|
| **Linear SVM (C=0.1)** | **0.963** |
| LDA | 0.963 |
| Logistic Regression (C=1) | 0.955 |
| Random Forest (200 trees) | 0.927 |
| Naive Bayes | much lower (about 0.73 in cross-validation) |

- Linear models beat Random Forest on these engineered features. Random Forest overfits (train F1 1.0).
- Most errors are between *sitting* and *standing*, and between *walking upstairs* and *downstairs*.
  *Laying* is classified almost perfectly.
- **McNemar tests on the test set:** Linear SVM is significantly better than Logistic Regression
  (p = 0.019), Random Forest and Naive Bayes (p < 0.001), but **not** different from LDA (p = 1.0),
  so I treat Linear SVM and LDA as equally good.
- A Wilcoxon test over the 5 cross-validation folds cannot show significance at all: with only
  5 folds the smallest possible p-value is 0.0625. More folds would be needed.

## Run it

Open the notebook in Jupyter or Google Colab and run all cells. It needs numpy, pandas,
scikit-learn, scipy and matplotlib, plus the UCI HAR CSV files.
