-- Query 1: Basic Activity Overview
SELECT 
  ROUND(AVG(TotalSteps), 2) AS avg_steps,
  ROUND(AVG(Calories), 2) AS avg_calories,
  ROUND(AVG(VeryActiveMinutes), 2) AS avg_very_active_mins,
  ROUND(AVG(FairlyActiveMinutes), 2) AS avg_fairly_active_mins,
  ROUND(AVG(LightlyActiveMinutes), 2) AS avg_lightly_active_mins,
  ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary_mins
FROM `bellabeat-analysis-498711.bellabeat_data.daily_activity`;

-- Query 2: Non-Wear Analysis
SELECT
  Id,
  COUNT(*) AS total_days_logged,
  COUNTIF(TotalSteps = 0) AS zero_step_days,
  COUNTIF(VeryActiveMinutes + FairlyActiveMinutes + 
          LightlyActiveMinutes + SedentaryMinutes < 500) AS low_wear_days,
  ROUND(COUNTIF(TotalSteps = 0) * 100.0 / COUNT(*), 2) AS zero_step_percentage
FROM `bellabeat-analysis-498711.bellabeat_data.daily_activity`
GROUP BY Id
ORDER BY zero_step_percentage DESC;

-- Query 3: Sleep Analysis
SELECT
  ROUND(AVG(TotalMinutesAsleep / 60), 2) AS avg_hours_asleep,
  ROUND(AVG(TotalTimeInBed / 60), 2) AS avg_hours_in_bed,
  ROUND(AVG((TotalTimeInBed - TotalMinutesAsleep) / 60), 2) AS avg_hours_awake_in_bed,
  ROUND(MIN(TotalMinutesAsleep / 60), 2) AS min_hours_asleep,
  ROUND(MAX(TotalMinutesAsleep / 60), 2) AS max_hours_asleep,
  COUNT(DISTINCT Id) AS users_tracked_sleep
FROM `bellabeat-analysis-498711.bellabeat_data.sleep_day`;

-- Query 4: Peak Activity Hours
SELECT
  EXTRACT(HOUR FROM ActivityHour) AS hour_of_day,
  ROUND(AVG(StepTotal), 2) AS avg_steps,
  ROUND(MAX(StepTotal), 2) AS max_steps,
  COUNT(*) AS total_records
FROM `bellabeat-analysis-498711.bellabeat_data.hourly_steps`
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;

-- Query 5: Activity Intensity By Hour
SELECT
  EXTRACT(HOUR FROM ActivityHour) AS hour_of_day,
  ROUND(AVG(TotalIntensity), 2) AS avg_total_intensity,
  ROUND(AVG(AverageIntensity), 2) AS avg_intensity
FROM `bellabeat-analysis-498711.bellabeat_data.hourly_intensities`
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;

-- Query 6: Calories By Hour
SELECT
  EXTRACT(HOUR FROM ActivityHour) AS hour_of_day,
  ROUND(AVG(Calories), 2) AS avg_calories,
  ROUND(MAX(Calories), 2) AS max_calories,
  ROUND(MIN(Calories), 2) AS min_calories
FROM `bellabeat-analysis-498711.bellabeat_data.hourly_calories`
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;

-- Query 7: Activity And Sleep Relationship
SELECT
  a.Id,
  ROUND(AVG(a.TotalSteps), 2) AS avg_daily_steps,
  ROUND(AVG(a.Calories), 2) AS avg_calories,
  ROUND(AVG(a.VeryActiveMinutes), 2) AS avg_very_active_mins,
  ROUND(AVG(s.TotalMinutesAsleep / 60), 2) AS avg_hours_asleep,
  ROUND(AVG((s.TotalTimeInBed - s.TotalMinutesAsleep)), 2) AS avg_mins_awake_in_bed
FROM `bellabeat-analysis-498711.bellabeat_data.daily_activity` a
INNER JOIN `bellabeat-analysis-498711.bellabeat_data.sleep_day` s
ON a.Id = s.Id 
AND a.ActivityDate = s.SleepDay
GROUP BY a.Id
ORDER BY avg_daily_steps DESC;

-- Query 8: Weight Tracking Analysis
SELECT
  Id,
  COUNT(*) AS total_logs,
  ROUND(AVG(WeightKg), 2) AS avg_weight_kg,
  ROUND(AVG(BMI), 2) AS avg_bmi,
  ROUND(MIN(WeightKg), 2) AS min_weight,
  ROUND(MAX(WeightKg), 2) AS max_weight,
  ROUND(MAX(WeightKg) - MIN(WeightKg), 2) AS weight_change_kg,
  COUNTIF(IsManualReport = TRUE) AS manual_entries,
  COUNTIF(IsManualReport = FALSE) AS automatic_entries
FROM `bellabeat-analysis-498711.bellabeat_data.weight_log`
GROUP BY Id
ORDER BY total_logs DESC;

-- Query 9: User Activity Segmentation
SELECT
  Id,
  ROUND(AVG(TotalSteps), 2) AS avg_steps,
  ROUND(AVG(VeryActiveMinutes + FairlyActiveMinutes), 2) AS avg_active_mins,
  CASE
    WHEN AVG(TotalSteps) >= 10000 THEN 'Very Active'
    WHEN AVG(TotalSteps) >= 7500 THEN 'Moderately Active'
    WHEN AVG(TotalSteps) >= 5000 THEN 'Lightly Active'
    ELSE 'Sedentary'
  END AS activity_segment
FROM `bellabeat-analysis-498711.bellabeat_data.daily_activity`
GROUP BY Id
ORDER BY avg_steps DESC;

-- Query 10: Day Of Week Activity Patterns
SELECT
  FORMAT_DATE('%A', ActivityDate) AS day_of_week,
  ROUND(AVG(TotalSteps), 2) AS avg_steps,
  ROUND(AVG(Calories), 2) AS avg_calories,
  ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary_mins,
  COUNT(*) AS total_records
FROM `bellabeat-analysis-498711.bellabeat_data.daily_activity`
GROUP BY day_of_week
ORDER BY avg_steps DESC;
