# ===== 01_prepare_data.R =====
# 📦 Step 1: Load required packages
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")

library(tidyverse)
library(caret)

# 📥 Step 2: Download MovieLens 10M dataset (if not already downloaded)
dl <- "ml-10M100K.zip"

if(!file.exists(dl)) {
  download.file("https://files.grouplens.org/datasets/movielens/ml-10m.zip", dl)
}

# 📂 Step 3: Unzip the downloaded file
if(!file.exists("ml-10M100K/ratings.dat")) {
  unzip(dl)
}

# 🧾 Step 4: Read and process ratings.dat
ratings <- as.data.frame(str_split(read_lines("ml-10M100K/ratings.dat"), fixed("::"), simplify = TRUE),
                         stringsAsFactors = FALSE)

colnames(ratings) <- c("userId", "movieId", "rating", "timestamp")

ratings <- ratings %>%
  mutate(userId = as.integer(userId),
         movieId = as.integer(movieId),
         rating = as.numeric(rating),
         timestamp = as.integer(timestamp))

# 🎬 Step 5: Read and process movies.dat
movies <- as.data.frame(str_split(read_lines("ml-10M100K/movies.dat"), fixed("::"), simplify = TRUE),
                        stringsAsFactors = FALSE)

colnames(movies) <- c("movieId", "title", "genres")

movies <- movies %>%
  mutate(movieId = as.integer(movieId))

# 🔗 Step 6: Join ratings and movie details into a single dataset
movielens <- left_join(ratings, movies, by = "movieId")

# 🎲 Step 7: Partition data into edx and final_holdout_test sets
set.seed(1, sample.kind = "Rounding")  # Ensures reproducibility

test_index <- createDataPartition(y = movielens$rating, times = 1, p = 0.1, list = FALSE)

edx <- movielens[-test_index,]
temp <- movielens[test_index,]

# 🧪 Step 8: Keep only users and movies that appear in the edx set
final_holdout_test <- temp %>%
  semi_join(edx, by = "movieId") %>%
  semi_join(edx, by = "userId")

# 🔁 Step 9: Add removed rows back into edx
removed <- anti_join(temp, final_holdout_test)
edx <- rbind(edx, removed)

# 🧹 Step 10: Clean up workspace
rm(dl, ratings, movies, test_index, temp, movielens, removed)



# ===== 02_exploratory_analysis.R =====
# 📊 Step 1: General structure of the edx dataset
glimpse(edx)

# 📏 Step 2: Number of rows and columns
dim(edx)

# 👥 Step 3: Number of unique users and movies
n_users <- n_distinct(edx$userId)
n_movies <- n_distinct(edx$movieId)

print(n_users)
print(n_movies)

# ⭐ Step 4: Distribution of ratings
plot_rating_dist <- edx %>%
  count(rating) %>%
  arrange(desc(n)) %>%
  ggplot(aes(x = rating, y = n)) +
  geom_col(fill = "steelblue") +
  labs(title = "Rating distribution", x = "Rating", y = "Count") +
  theme_minimal()

print(plot_rating_dist)

# 🎬 Step 5: Top 10 most rated movies
top_movies <- edx %>%
  group_by(title) %>%
  summarize(count = n()) %>%
  arrange(desc(count)) %>%
  slice(1:10)

print(top_movies)

# 🎭 Step 6: Top 10 genres (counted by occurrences)
top_genres <- edx %>%
  separate_rows(genres, sep = "\\|") %>%
  count(genres, sort = TRUE) %>%
  slice(1:10)

print(top_genres)

# 📅 (Optional) Step 7: Ratings over time
plot_time <- edx %>%
  mutate(date = as_datetime(timestamp)) %>%
  ggplot(aes(x = date)) +
  geom_histogram(binwidth = 30*24*60*60, fill = "darkgreen", color = "white") +
  labs(title = "Ratings over time", x = "Date", y = "Count")

print(plot_time)

# 👤 (Optional) Step 8: Number of ratings per user
plot_user_activity <- edx %>%
  count(userId) %>%
  ggplot(aes(x = n)) +
  geom_histogram(bins = 30, fill = "purple") +
  labs(title = "Number of ratings per user", x = "Ratings", y = "Users")

print(plot_user_activity)



# ===== 03_model_movie_effect.R =====
# 🎯 Step 1: Compute the global average rating
mu <- mean(edx$rating)

# 🎬 Step 2: Compute average deviation for each movie (movie effect)
movie_avgs <- edx %>%
  group_by(movieId) %>%
  summarize(b_i = mean(rating - mu))

# 🧪 Step 3: Predict ratings using the movie effect
predicted_ratings <- final_holdout_test %>%
  left_join(movie_avgs, by = "movieId") %>%
  mutate(pred = mu + b_i)

# 📉 Step 4: Compute RMSE for the movie effect model
rmse_movie_effect <- sqrt(mean((predicted_ratings$rating - predicted_ratings$pred)^2))

# 📢 Step 5: Output the RMSE
print(rmse_movie_effect)



# ===== 04_model_user_effect.R =====
# 🎯 Step 1: Compute the global average rating
mu <- mean(edx$rating)

# 🎬 Step 2: Compute movie effects (b_i)
movie_avgs <- edx %>%
  group_by(movieId) %>%
  summarize(b_i = mean(rating - mu))

# 👤 Step 3: Compute user effects (b_u)
user_avgs <- edx %>%
  left_join(movie_avgs, by = "movieId") %>%
  group_by(userId) %>%
  summarize(b_u = mean(rating - mu - b_i))

# 🧪 Step 4: Predict ratings using movie and user effects
predicted_ratings <- final_holdout_test %>%
  left_join(movie_avgs, by = "movieId") %>%
  left_join(user_avgs, by = "userId") %>%
  mutate(pred = mu + b_i + b_u)

# 📉 Step 5: Compute RMSE
rmse_user_effect <- sqrt(mean((predicted_ratings$rating - predicted_ratings$pred)^2))

# 📢 Step 6: Output the RMSE
print(rmse_user_effect)


# ===== 05_model_regularized.R =====
# 🎯 Step 1: Global average rating
mu <- mean(edx$rating)

# 🔁 Step 2: Try multiple lambda values
lambdas <- seq(0, 10, 0.25)

# 📉 Step 3: Define RMSE function
RMSE <- function(true_ratings, predicted_ratings) {
  sqrt(mean((true_ratings - predicted_ratings)^2))
}

# 🧪 Step 4: Loop over lambdas and compute RMSE
rmse_results <- sapply(lambdas, function(lambda) {
  
  # Regularized movie effects
  b_i <- edx %>%
    group_by(movieId) %>%
    summarize(b_i = sum(rating - mu) / (n() + lambda), .groups = "drop")
  
  # Regularized user effects
  b_u <- edx %>%
    left_join(b_i, by = "movieId") %>%
    group_by(userId) %>%
    summarize(b_u = sum(rating - mu - b_i) / (n() + lambda), .groups = "drop")
  
  # Predict ratings
  predicted_ratings <- final_holdout_test %>%
    left_join(b_i, by = "movieId") %>%
    left_join(b_u, by = "userId") %>%
    mutate(
      b_i = coalesce(b_i, 0),
      b_u = coalesce(b_u, 0),
      pred = mu + b_i + b_u
    ) %>%
    pull(pred)
  
  # Calculate RMSE
  RMSE(final_holdout_test$rating, predicted_ratings)
}, simplify = TRUE)

# 📈 Step 5: Show RMSE results
rmse_results_df <- data.frame(lambda = lambdas, rmse = rmse_results)

# Print the full table
print(rmse_results_df)

# Show the lambda with the lowest RMSE
best_result <- rmse_results_df %>% arrange(rmse) %>% slice(1)

print(best_result)



# ===== 06_final_model.R =====
# 📦 Step 1: Set the optimized lambda from previous tuning
lambda <- 5.25

# 🎯 Step 2: Compute global average rating
mu <- mean(edx$rating)

# 🎬 Step 3: Regularized movie effect (b_i)
b_i <- edx %>%
  group_by(movieId) %>%
  summarize(b_i = sum(rating - mu) / (n() + lambda), .groups = "drop")

# 👤 Step 4: Regularized user effect (b_u)
b_u <- edx %>%
  left_join(b_i, by = "movieId") %>%
  group_by(userId) %>%
  summarize(b_u = sum(rating - mu - b_i) / (n() + lambda), .groups = "drop")

# 🔍 Step 5: Predict ratings on final_holdout_test
final_predictions <- final_holdout_test %>%
  left_join(b_i, by = "movieId") %>%
  left_join(b_u, by = "userId") %>%
  mutate(
    b_i = coalesce(b_i, 0),
    b_u = coalesce(b_u, 0),
    pred = mu + b_i + b_u
  )

# 📉 Step 6: Compute final RMSE
final_rmse <- sqrt(mean((final_predictions$rating - final_predictions$pred)^2))

# 📢 Step 7: Print final RMSE
print(final_rmse)


