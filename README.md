# 🎬 MovieLens Capstone Project

This project was developed as part of the final Capstone for the [HarvardX Data Science Professional Certificate](https://online-learning.harvard.edu/series/data-science).

---

## 🎯 Goal

The objective is to build a predictive model for movie ratings using the **MovieLens 10M dataset**.  
Model performance is evaluated using **Root Mean Square Error (RMSE)**.  
The final model is only tested once on the `final_holdout_test` dataset, in accordance with the edX instructions.

---

## 📚 Data Source

The data used in this project is from the [MovieLens 10M dataset](https://grouplens.org/datasets/movielens/10m/)  
provided by [GroupLens Research](https://grouplens.org/).  
The dataset is licensed for research and educational use.

⚠️ **Note:** The dataset is not included in this repository.  
Download it manually from:  
👉 https://files.grouplens.org/datasets/movielens/ml-10m.zip

---

## 🗂️ Project Structure

| File                             | Description                                                  |
|----------------------------------|--------------------------------------------------------------|
| `01_prepare_data.R`             | Loads and prepares `edx` and `final_holdout_test` datasets  |
| `02_exploratory_analysis.R`     | Explores distribution, user/movie counts, genres            |
| `03_model_movie_effect.R`       | Movie effect model + RMSE                                   |
| `04_model_user_effect.R`        | Adds user effect to model + RMSE                            |
| `05_model_regularized.R`        | Regularized model using lambda tuning                       |
| `06_final_model.R`              | Final model using best lambda and final RMSE evaluation     |
| `MovieLens-Capstone-Report.Rmd` | Report for edX                                               |
| `MovieLens-Capstone-Report.pdf` | Knit report in PDF format                                   |

---

## 🔎 Final Result

**Final RMSE:** 0.864817  
Using regularized Movie + User effect model with optimized lambda = 5.25

---

## 💻 Requirements

- R 4.x or newer
- RStudio (recommended)
- Libraries: `tidyverse`, `caret`, `lubridate`

---

## 👩‍💻 Author and License

This project was created by **Yvonne Kirschler**  
and is licensed under the [MIT License](LICENSE).

If you reuse code from this repository, please provide proper attribution.