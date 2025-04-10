# 🎬 MovieLens Capstone Project

This project is part of the final capstone for the **HarvardX Data Science Professional Certificate** on edX.

---

## 🎯 Goal

The objective of this project is to develop a predictive model for movie ratings using the **MovieLens 10M dataset**.  
The model performance is evaluated using the **Root Mean Square Error (RMSE)** metric, in accordance with the project instructions.

All models are trained using the `edx` dataset.  
The `final_holdout_test` dataset is used **only once** to evaluate the final model.

---

## 📚 Data Source

The dataset used in this project is the [MovieLens 10M dataset](https://grouplens.org/datasets/movielens/10m/),  
provided by [GroupLens Research](https://grouplens.org/). It is licensed for research and educational use.

📌 **Note:** The dataset is **not included in this repository**.  
You can download it manually at:  
👉 https://files.grouplens.org/datasets/movielens/ml-10m.zip

---

## 📁 Repository Contents

| File                           | Description                                                 |
|--------------------------------|-------------------------------------------------------------|
| `01_prepare_data.R`           | Loads and processes the MovieLens data (`edx` and `final_holdout_test`) |
| `02_exploratory_analysis.R`   | Performs exploratory data analysis (EDA)                   |
| `03_model_movie_effect.R`     | Implements the Movie Effect model with RMSE calculation    |
| `movielens_report.Rmd`        | R Markdown report (to be submitted to edX)                 |
| `movielens_report.pdf`        | PDF knit version of the report                             |
| `movielens_code.R`            | Final complete code for submission                         |

---

## 🧠 Modeling Approach

The predictive modeling follows an incremental development approach:

1. **Baseline Model (Global Mean):**  
   Predicts the same average rating for all movies (RMSE ~1.06).

2. **Movie Effect Model:**  
   Adjusts predictions based on each movie's average deviation (RMSE improved).

3. **User Effect Model (upcoming):**  
   Will account for how individual users tend to rate compared to the mean.

Planned extensions include:
- Regularization
- Cross-validation
- Time and genre effects

Each step includes a performance evaluation using RMSE.

---

## 👤 Author and License

This project was created by **Yvonne Kirschler**  
and is licensed under the [MIT License](LICENSE).

If you reuse or reference code from this repository, please give proper attribution.