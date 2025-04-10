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

