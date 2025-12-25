# Daily Productivity Analysis with R

A comprehensive R-based productivity tracker that analyzes daily habits (sleep, work, exercise, screen time) and calculates productivity scores to help identify optimal daily routines and improve overall performance.

## 📊 Features

- **Productivity Score Calculation**: Calculates daily productivity scores (0-100 scale) based on multiple factors
- **Most Productive Day Identification**: Automatically identifies and analyzes your most productive day
- **Comparative Analysis**: Compares top 5 vs bottom 5 productive days to reveal key patterns
- **Data Visualization**: Generates three insightful plots:
  - Productivity score trends over time
  - Most productive day highlighted
  - Key factors comparison (top vs bottom days)
- **Actionable Insights**: Provides data-driven recommendations for improving productivity
- **CSV Export**: Saves results with calculated productivity scores

## 🎯 Productivity Score Components

The productivity score (0-100) is calculated based on:

| Factor | Points | Description |
|--------|--------|-------------|
| Sleep Hours | 0-20 | Optimal range: 7-8 hours |
| Sleep Quality | 0-25 | Based on 1-5 scale rating |
| Deep Work Hours | 0-25 | More focused work = higher score |
| Focus Score | 0-15 | Based on 1-10 scale rating |
| Mood Score | 0-10 | Based on 1-10 scale rating |
| Exercise | 0-5 | 30+ minutes gets full points |
| Screen Time | 0 to -10 | Less screen time = better (penalty system) |
| Work Efficiency | 0-10 | Ratio of deep work to total work time |

## 📋 Requirements

- **R** (version 4.0 or higher)
- **Required R packages**:
  ```r
  install.packages(c("dplyr", "ggplot2", "scales"))
  ```

## 🚀 Installation

1. **Clone this repository**:
   ```bash
   git clone https://github.com/efilsaylam19/daily-productivity-analysis-r.git
   cd daily-productivity-analysis-r
   ```

2. **Install required R packages**:
   ```r
   install.packages(c("dplyr", "ggplot2", "scales"))
   ```

## 📝 Usage

### Step 1: Prepare Your Data

Create a CSV file named `daily_log.csv` with the following columns:

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `date` | Date | Date in YYYY-MM-DD format | 2025-12-25 |
| `sleep_hours` | Numeric | Hours of sleep | 7.5 |
| `sleep_quality` | Integer | Sleep quality (1-5 scale) | 4 |
| `coffee_cups` | Integer | Number of coffee cups | 2 |
| `work_hours` | Numeric | Total work hours | 6 |
| `deep_work_hours` | Numeric | Hours of focused deep work | 3 |
| `focus_score` | Integer | Focus level (1-10 scale) | 7 |
| `mood_score` | Integer | Mood level (1-10 scale) | 8 |
| `exercise_minutes` | Integer | Minutes of exercise | 30 |
| `screen_time_hours` | Numeric | Hours spent on screens | 5 |

### Step 2: Run the Analysis

```r
source("daily_productivity_app.R")
```

### Step 3: View Results

The script will:
- Display analysis results in the console
- Generate three visualization plots
- Create `daily_log_with_productivity.csv` with calculated scores

## 📁 Project Structure

```
daily-productivity-analysis-r/
├── README.md                          # This file
├── daily_productivity_app.R          # Main analysis script
├── daily_log.csv                     # Input data file (your daily logs)
└── daily_log_with_productivity.csv   # Output file with productivity scores
```

## 📊 Example Output

### Console Output

```
========================================
MOST PRODUCTIVE DAY
========================================
Date: 2025-11-25
Score: 93.38 /100

Why it was productive:
  • Sleep: 8h (avg: 6.9h), Quality: 5/5
  • Deep Work: 5h (avg: 3h) - 62% efficiency
  • Focus: 9/10, Mood: 8/10
  • Exercise: 50min (avg: 21min)
  • Screen Time: 3h (avg: 5.5h)

========================================
KEY INSIGHTS
========================================
Top 5 vs Bottom 5 Days:
  Sleep: 8.2h vs 5.4h
  Deep Work: 5h vs 1.2h
  Focus: 9/10 vs 4/10
  Exercise: 49min vs 0min
  Screen Time: 3.6h vs 8.2h
```

### Visualizations

The script generates three plots:
1. **Productivity Score Over Time**: Line chart showing daily productivity trends
2. **Most Productive Day Highlighted**: Bar chart with the most productive day highlighted
3. **Key Factors Comparison**: Comparison of top 5 vs bottom 5 days across key metrics

## 💡 Recommendations

Based on the analysis, the script provides actionable recommendations:

- **Sleep**: Target 7-8 hours with quality 4+/5
- **Deep Work**: Schedule 5+ hours daily (morning blocks recommended)
- **Exercise**: Commit to 30+ minutes daily
- **Screen Time**: Keep below 4 hours
- **Focus**: Eliminate distractions, use time-blocking
- **Coffee**: Limit to 1-2 cups, avoid after 2 PM

## 🔧 Customization

You can customize the productivity calculation algorithm by modifying the `calculate_productivity()` function in `daily_productivity_app.R`. Adjust the point allocations and thresholds to match your personal productivity goals.

## 📈 Data Privacy

**Note**: If your `daily_log.csv` contains personal data, consider adding it to `.gitignore` before pushing to GitHub:

```
# Personal data files
daily_log.csv
daily_log_with_productivity.csv
```

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## 📄 License

This project is open source and available for personal and educational use.

## 👤 Author

**efilsaylam19**

## 🙏 Acknowledgments

Built with R and the following packages:
- `dplyr` - Data manipulation
- `ggplot2` - Data visualization
- `scales` - Scale functions for visualization

---

**Happy Tracking! 📊✨**
