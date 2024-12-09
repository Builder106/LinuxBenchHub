# Set CRAN mirror
options(repos = c(CRAN = "https://cran.rstudio.com/"))

# Install and load required packages
install.packages("XML")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("jsonlite")
library(XML)
library(dplyr)
library(ggplot2)
library(jsonlite)

# Define the XML file path
xml_file <- "/Users/yinka/Library/CloudStorage/GoogleDrive-yvaughan@wesleyan.edu/My Drive/CS/LinuxBenchHub/benchmarks/ubuntu/CPU/CPU 12_7_2024/composite.xml"

# Load the XML file
xml_data <- xmlParse(xml_file)

# Print the structure of the XML data
cat("XML Structure:\n")
print(xml_data)

# Extract the root node
xml_root <- xmlRoot(xml_data)

# Check if PhoronixTestSuite node exists
if (!is.null(xml_root)) {
  cat("\nPhoronixTestSuite node found.\n")
  
  # Extract system information
  system_node <- xml_root[["System"]]
  if (!is.null(system_node)) {
    system_info <- xmlToList(system_node)
    cat("\nSystem Information:\n")
    cat("Title:", system_info$Identifier, "\n")
    cat("Hardware:", system_info$Hardware, "\n")
    cat("Software:", system_info$Software, "\n")
    cat("User:", system_info$User, "\n")
    cat("Timestamp:", system_info$TimeStamp, "\n")
  } else {
    cat("System node not found.\n")
  }
  
  # Extract test results
  result_node <- xml_root[["Result"]]
  if (!is.null(result_node)) {
    result <- xmlToList(result_node)
    cat("\nTest Results: C-Ray Benchmark\n")
    cat("Test Identifier:", result$Identifier, "\n")
    cat("Title:", result$Title, "\n")
    cat("App Version:", result$AppVersion, "\n")
    cat("Arguments:", result$Arguments, "\n")
    cat("Description:", result$Description, "\n")
    cat("Scale:", result$Scale, "\n")
    cat("Display Format:", result$DisplayFormat, "\n")
    
    # Check if Data node exists
    data_node <- result$Data$Entry
    if (!is.null(data_node)) {
      cat("\nData Entries:\n")
      cat("Identifier:", data_node$Identifier, "\n")
      cat("Value (Seconds):", data_node$Value, "\n")
      cat("Raw String (Milliseconds):", data_node$RawString, "\n")
      
      # Convert raw string to data frame
      raw_times <- strsplit(data_node$RawString, ":")[[1]]
      run_times <- as.numeric(raw_times)
      run_df <- data.frame(Run = 1:length(run_times), Time = run_times)
      
      # Print detailed run times
      cat("\nDetailed Run Times:\n")
      print(run_df)
      
      # Plot the run times
      ggplot(run_df, aes(x = Run, y = Time)) +
        geom_bar(stat = "identity") +
        labs(title = "C-Ray Benchmark Run Times", x = "Run", y = "Time (ms)") +
        theme_minimal()
    } else {
      cat("Data Entry not found.\n")
    }
  } else {
    cat("Result node not found.\n")
  }
} else {
  cat("PhoronixTestSuite node not found.\n")
}