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

