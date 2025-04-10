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
