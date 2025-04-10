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
