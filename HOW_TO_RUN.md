# How to Run the Daily Productivity Analysis

## Option 1: Using RStudio (Recommended)

1. **Open RStudio**
   - If you don't have RStudio, download it from: https://www.rstudio.com/products/rstudio/download/

2. **Install Required Packages** (if not already installed)
   - Open RStudio
   - In the Console, type:
   ```r
   install.packages(c("dplyr", "ggplot2", "scales"))
   ```
   - Press Enter and wait for installation to complete

3. **Open the Script**
   - In RStudio: File → Open File → Select `daily_productivity_app.R`
   - Or use: `File → Open Project` if you want to set the folder as a project

4. **Set Working Directory**
   - Make sure your working directory is set to the folder containing the CSV file
   - In RStudio: Session → Set Working Directory → To Source File Location
   - Or in Console, type:
   ```r
   setwd("C:/Users/LENOVO/Desktop/daily_productivity")
   ```

5. **Run the Script**
   - Click "Source" button at the top of the script editor
   - Or press: `Ctrl + Shift + S` (Windows) or `Cmd + Shift + S` (Mac)
   - Or select all code and press `Ctrl + Enter` (Windows) or `Cmd + Enter` (Mac)

## Option 2: Using R Command Line

1. **Open R** (or R terminal)

2. **Install Packages** (if needed)
   ```r
   install.packages(c("dplyr", "ggplot2", "scales"))
   ```

3. **Set Working Directory**
   ```r
   setwd("C:/Users/LENOVO/Desktop/daily_productivity")
   ```

4. **Run the Script**
   ```r
   source("daily_productivity_app.R")
   ```

## What to Expect

After running the script, you will see:
- Console output showing:
  - The most productive day
  - Top 5 most productive days
  - Comparison between top 5 and bottom 5 days
  - Correlation analysis
  - Key insights and recommendations
- Three plots will appear in the Plots panel (if using RStudio)
- A new file `daily_log_with_productivity.csv` will be created with productivity scores added

## Troubleshooting

**Error: "package not found"**
- Run: `install.packages("package_name")` for the missing package

**Error: "cannot open file"**
- Make sure you're in the correct directory
- Check that `daily_log.csv` is in the same folder as the R script

**Plots not showing**
- In RStudio, check the Plots tab in the bottom right panel
- You may need to click through the plots using the arrow buttons

