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

