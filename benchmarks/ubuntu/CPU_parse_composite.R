# Install and load required packages
install.packages("XML")
install.packages("dplyr")
install.packages("ggplot2")
library(XML)
library(dplyr)
library(ggplot2)

# Load the XML file
xml_file <- "benchmarks/ubuntu/CPU 12_7_2024/composite.xml"
xml_data <- xmlParse(xml_file)

# Extract system information
system_info <- xmlToList(xml_data[["PhoronixTestSuite"]][["System"]])

# Print system information
cat("System Information\n")
cat("Title:", system_info$Identifier, "\n")
cat("Hardware:", system_info$Hardware, "\n")
cat("Software:", system_info$Software, "\n")
cat("User:", system_info$User, "\n")
cat("Timestamp:", system_info$TimeStamp, "\n")

# Extract test results
result <- xmlToList(xml_data[["PhoronixTestSuite"]][["Result"]])

# Print test results
cat("\nTest Results: C-Ray Benchmark\n")
cat("Test Identifier:", result$Identifier, "\n")
cat("Title:", result$Title, "\n")
cat("App Version:", result$AppVersion, "\n")
cat("Arguments:", result$Arguments, "\n")
cat("Description:", result$Description, "\n")
cat("Scale:", result$Scale, "\n")
cat("Display Format:", result$DisplayFormat, "\n")

# Extract data entries
data_entries <- result$Data$Entry
cat("\nData Entries\n")
cat("Identifier:", data_entries$Identifier, "\n")
cat("Value (Seconds):", data_entries$Value, "\n")
cat("Raw String (Milliseconds):", data_entries$RawString, "\n")

# Convert raw string to data frame
raw_times <- strsplit(data_entries$RawString, ":")[[1]]
run_times <- as.numeric(raw_times)
run_df <- data.frame(Run = 1:length(run_times), Time = run_times)

# Print detailed run times
cat("\nDetailed Run Times\n")
print(run_df)

# Plot the run times
ggplot(run_df, aes(x = Run, y = Time)) +
  geom_bar(stat = "identity") +
  labs(title = "C-Ray Benchmark Run Times", x = "Run", y = "Time (ms)") +
  theme_minimal()