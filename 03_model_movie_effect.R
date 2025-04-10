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

