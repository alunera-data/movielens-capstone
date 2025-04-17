# 🎬 MovieLens Capstone Project

This project was developed as part of the final Capstone for the [HarvardX Data Science Professional Certificate](https://online-learning.harvard.edu/series/data-science).

---

## 🎯 Goal

The objective is to build a predictive model for movie ratings using the **MovieLens 10M dataset**.  
Model performance is evaluated using **Root Mean Square Error (RMSE)**.  
The final model is tested only once on the `final_holdout_test` dataset, in accordance with the edX instructions.

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

| File                                | Description                                                  |
|-------------------------------------|--------------------------------------------------------------|
| `01_prepare_data.R`                | Loads and prepares `edx` and `final_holdout_test` datasets  |
| `02_exploratory_analysis.R`        | Visualizes distributions, users, genres, ratings            |
| `03_model_movie_effect.R`          | Movie effect model + RMSE                                   |
| `04_model_user_effect.R`           | Adds user effect + RMSE                                     |
| `05_model_regularized.R`           | Lambda tuning and RMSE curve                                |
| `06_final_model.R`                 | Final regularized model + RMSE                              |
| `movielens_code.R`                 | Complete combined script with all steps                     |
| `MovieLens-Capstone-Report.Rmd`    | Full project report (R Markdown)                            |
| `MovieLens-Capstone-Report.pdf`    | Knit PDF version for edX submission                         |
| `MovieLens-Capstone-Report.html`   | HTML version of the report (optional)                       |

---

## 🔎 Final Result

**Final RMSE:** 0.864817  
Using regularized Movie + User effect model with optimized `lambda = 5.25`.

---

## 💻 Requirements

- R 4.x or newer  
- RStudio  
- Packages: `tidyverse`, `caret`, `lubridate`

---

## 👩‍💻 Author and License

This project was created by **Yvonne Kirschler**  
and is licensed under the [MIT License](LICENSE).

If you reuse code from this repository, please provide proper attribution.

GitHub profile: [@alunera-data](https://github.com/alunera-data)  
LinkedIn: [Yvonne Kirschler](https://www.linkedin.com/in/yvonne-kirschler-719224188/)