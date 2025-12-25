# Daily Productivity Analysis
# This script calculates productivity scores and identifies the most productive day

# Set working directory to the script's location
# This ensures the CSV file can be found

# Method 1: Try RStudio API (if available and installed)
tryCatch({
  if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
    setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  }
}, error = function(e) {
  # If RStudio method fails, continue to next method
})

# Method 2: If Method 1 didn't work, use absolute path
# This is your folder path - it should work now
if (!file.exists("daily_log.csv")) {
  setwd("C:/Users/LENOVO/Desktop/daily_productivity")
}

# Verify we're in the right directory
cat("Current working directory:", getwd(), "\n")
cat("Looking for daily_log.csv...\n")
if (file.exists("daily_log.csv")) {
  cat("✓ File found!\n\n")
} else {
  cat("✗ File not found! Please check the path.\n")
  cat("Files in current directory:\n")
  print(list.files())
  stop("Cannot find daily_log.csv")
}

# Load required libraries
library(dplyr)
library(ggplot2)
library(scales)

# Read the daily log data
daily_log <- read.csv("daily_log.csv", stringsAsFactors = FALSE)
daily_log$date <- as.Date(daily_log$date)

# ============================================================================
# PRODUCTIVITY CALCULATION ALGORITHM
# ============================================================================
# The productivity score is calculated based on multiple factors:
# 1. Sleep Quality (0-25 points): Better sleep = higher productivity
# 2. Sleep Hours (0-20 points): Optimal range 7-8 hours
# 3. Deep Work Hours (0-25 points): More deep work = higher productivity
# 4. Focus Score (0-15 points): Higher focus = higher productivity
# 5. Mood Score (0-10 points): Better mood = higher productivity
# 6. Exercise (0-5 points): Exercise boosts productivity
# 7. Screen Time Penalty (0 to -10 points): Less screen time = better
# 8. Work Efficiency (0-10 points): Ratio of deep work to total work
# Total possible score: 100 points

calculate_productivity <- function(data) {
  # Normalize sleep hours (optimal: 7-8 hours, max points at 7.5)
  sleep_hours_score <- ifelse(
    data$sleep_hours >= 7 & data$sleep_hours <= 8,
    20,  # Optimal range
    ifelse(
      data$sleep_hours >= 6.5 & data$sleep_hours < 7,
      15,  # Good
      ifelse(
        data$sleep_hours > 8 & data$sleep_hours <= 8.5,
        15,  # Good
        ifelse(
          data$sleep_hours >= 6 & data$sleep_hours < 6.5,
          10,  # Acceptable
          ifelse(
            data$sleep_hours > 8.5 & data$sleep_hours <= 9,
            10,  # Acceptable
            5   # Poor
          )
        )
      )
    )
  )
  
  # Sleep quality score (1-5 scale -> 0-25 points)
  sleep_quality_score <- (data$sleep_quality / 5) * 25
  
  # Deep work hours score (0-25 points, assuming max 8 hours)
  deep_work_score <- (data$deep_work_hours / 8) * 25
  
  # Focus score (1-10 scale -> 0-15 points)
  focus_score_points <- (data$focus_score / 10) * 15
  
  # Mood score (1-10 scale -> 0-10 points)
  mood_score_points <- (data$mood_score / 10) * 10
  
  # Exercise score (0-5 points, optimal at 30+ minutes)
  exercise_score <- ifelse(
    data$exercise_minutes >= 30,
    5,
    ifelse(
      data$exercise_minutes >= 15,
      3,
      ifelse(
        data$exercise_minutes > 0,
        1,
        0
      )
    )
  )
  
  # Screen time penalty (less is better, max 10 hours)
  screen_time_penalty <- ifelse(
    data$screen_time_hours <= 4,
    0,  # No penalty
    ifelse(
      data$screen_time_hours <= 5,
      -2,  # Small penalty
      ifelse(
        data$screen_time_hours <= 6,
        -4,  # Medium penalty
        ifelse(
          data$screen_time_hours <= 7,
          -6,  # Large penalty
          -10  # Maximum penalty
        )
      )
    )
  )
  
  # Work efficiency score (deep work / total work ratio, 0-10 points)
  work_efficiency <- ifelse(
    data$work_hours > 0,
    (data$deep_work_hours / data$work_hours) * 10,
    0
  )
  work_efficiency <- pmin(work_efficiency, 10)  # Cap at 10
  
  # Calculate total productivity score
  productivity_score <- sleep_hours_score + 
                       sleep_quality_score + 
                       deep_work_score + 
                       focus_score_points + 
                       mood_score_points + 
                       exercise_score + 
                       screen_time_penalty + 
                       work_efficiency
  
  return(productivity_score)
}

# Calculate productivity scores
daily_log$productivity_score <- calculate_productivity(daily_log)

# Round to 2 decimal places
daily_log$productivity_score <- round(daily_log$productivity_score, 2)

# ============================================================================
# IDENTIFY MOST PRODUCTIVE DAY
# ============================================================================
most_productive_day <- daily_log %>%
  arrange(desc(productivity_score)) %>%
  slice(1)

# Calculate averages for comparison
avg_sleep_hours <- mean(daily_log$sleep_hours)
avg_deep_work <- mean(daily_log$deep_work_hours)
avg_focus <- mean(daily_log$focus_score)
avg_exercise <- mean(daily_log$exercise_minutes)
avg_screen_time <- mean(daily_log$screen_time_hours)
work_efficiency_ratio <- (most_productive_day$deep_work_hours / most_productive_day$work_hours) * 100

cat("\n========================================\n")
cat("MOST PRODUCTIVE DAY\n")
cat("========================================\n")
cat("Date:", format(most_productive_day$date, "%Y-%m-%d"), "\n")
cat("Score:", most_productive_day$productivity_score, "/100\n\n")

cat("Why it was productive:\n")
cat("  • Sleep: ", most_productive_day$sleep_hours, "h (avg: ", round(avg_sleep_hours, 1), "h), Quality: ", most_productive_day$sleep_quality, "/5\n", sep="")
cat("  • Deep Work: ", most_productive_day$deep_work_hours, "h (avg: ", round(avg_deep_work, 1), "h) - ", round(work_efficiency_ratio, 0), "% efficiency\n", sep="")
cat("  • Focus: ", most_productive_day$focus_score, "/10, Mood: ", most_productive_day$mood_score, "/10\n", sep="")
cat("  • Exercise: ", most_productive_day$exercise_minutes, "min (avg: ", round(avg_exercise, 0), "min)\n", sep="")
cat("  • Screen Time: ", most_productive_day$screen_time_hours, "h (avg: ", round(avg_screen_time, 1), "h)\n", sep="")

# Calculate averages for top 5 vs bottom 5
top_5_days <- daily_log %>% arrange(desc(productivity_score)) %>% slice(1:5)
bottom_5_days <- daily_log %>% arrange(productivity_score) %>% slice(1:5)

top_5_avg <- top_5_days %>% summarise(
  avg_sleep_hours = mean(sleep_hours),
  avg_sleep_quality = mean(sleep_quality),
  avg_deep_work = mean(deep_work_hours),
  avg_focus = mean(focus_score),
  avg_mood = mean(mood_score),
  avg_exercise = mean(exercise_minutes),
  avg_screen_time = mean(screen_time_hours)
)

bottom_5_avg <- bottom_5_days %>% summarise(
  avg_sleep_hours = mean(sleep_hours),
  avg_sleep_quality = mean(sleep_quality),
  avg_deep_work = mean(deep_work_hours),
  avg_focus = mean(focus_score),
  avg_mood = mean(mood_score),
  avg_exercise = mean(exercise_minutes),
  avg_screen_time = mean(screen_time_hours)
)

cat("\n========================================\n")
cat("KEY INSIGHTS\n")
cat("========================================\n")
cat("Top 5 vs Bottom 5 Days:\n")
cat("  Sleep: ", round(top_5_avg$avg_sleep_hours, 1), "h vs ", round(bottom_5_avg$avg_sleep_hours, 1), "h\n", sep="")
cat("  Deep Work: ", round(top_5_avg$avg_deep_work, 1), "h vs ", round(bottom_5_avg$avg_deep_work, 1), "h\n", sep="")
cat("  Focus: ", round(top_5_avg$avg_focus, 1), "/10 vs ", round(bottom_5_avg$avg_focus, 1), "/10\n", sep="")
cat("  Exercise: ", round(top_5_avg$avg_exercise, 0), "min vs ", round(bottom_5_avg$avg_exercise, 0), "min\n", sep="")
cat("  Screen Time: ", round(top_5_avg$avg_screen_time, 1), "h vs ", round(bottom_5_avg$avg_screen_time, 1), "h\n", sep="")

# ============================================================================
# VISUALIZATIONS
# ============================================================================

# 1. Productivity Score Over Time
p1 <- ggplot(daily_log, aes(x = date, y = productivity_score)) +
  geom_line(color = "steelblue", linewidth = 1) +
  geom_point(color = "steelblue", size = 2) +
  geom_hline(yintercept = mean(daily_log$productivity_score), 
             linetype = "dashed", color = "red", alpha = 0.7) +
  labs(title = "Daily Productivity Score Over Time",
       x = "Date",
       y = "Productivity Score",
       subtitle = paste("Average:", round(mean(daily_log$productivity_score), 2))) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5))

# 2. Most Productive Day Highlighted
p2 <- ggplot(daily_log, aes(x = date, y = productivity_score)) +
  geom_col(fill = "lightblue", alpha = 0.7) +
  geom_col(data = most_productive_day, fill = "darkgreen", alpha = 0.9) +
  labs(title = "Daily Productivity Scores",
       subtitle = paste("Most Productive Day:", format(most_productive_day$date, "%Y-%m-%d")),
       x = "Date",
       y = "Productivity Score") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 45, hjust = 1))

# 3. Key Factors Comparison
top_bottom_comparison <- data.frame(
  Category = rep(c("Top 5 Days", "Bottom 5 Days"), each = 4),
  Factor = rep(c("Sleep Quality", "Deep Work Hours", "Focus Score", "Mood Score"), 2),
  Value = c(
    top_5_avg$avg_sleep_quality, top_5_avg$avg_deep_work, 
    top_5_avg$avg_focus, top_5_avg$avg_mood,
    bottom_5_avg$avg_sleep_quality, bottom_5_avg$avg_deep_work,
    bottom_5_avg$avg_focus, bottom_5_avg$avg_mood
  )
)

p3 <- ggplot(top_bottom_comparison, aes(x = Factor, y = Value, fill = Category)) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(title = "Key Factors: Top 5 vs Bottom 5 Days",
       x = "Factor",
       y = "Average Value",
       fill = "Category") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1))

# Display plots
print(p1)
print(p2)
print(p3)

# ============================================================================
# RECOMMENDATIONS
# ============================================================================
cat("\n========================================\n")
cat("RECOMMENDATIONS\n")
cat("========================================\n")
cat("To replicate your most productive day:\n")
cat("  • Sleep: 7-8 hours, quality 4+/5\n")
cat("  • Deep Work: ", round(top_5_avg$avg_deep_work, 0), "+ hours daily (schedule morning blocks)\n", sep="")
cat("  • Exercise: 30+ minutes (morning preferred)\n")
cat("  • Screen Time: Keep below ", round(top_5_avg$avg_screen_time, 0), " hours\n", sep="")
cat("  • Focus: Eliminate distractions, use time-blocking\n")
cat("  • Coffee: Limit to 1-2 cups, avoid after 2 PM\n")

# Save results to CSV
write.csv(daily_log, "daily_log_with_productivity.csv", row.names = FALSE)
cat("\n\nResults saved to: daily_log_with_productivity.csv\n")

