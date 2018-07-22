library(dplyr)

# Setup variables, lists, factors and functions
# Setup folder for data
datafolder = "./UCI HAR Dataset"

# Setup data sources : train, test
datasources <- c("train", "test")

# Create list for Activities with descriptive names
activities <- read.table(
                paste(datafolder, "activity_labels.txt", sep = "/"), 
                sep = " ", 
                header = FALSE, 
                col.names = c("activityid", "activityname"))

# Create list for filterable Features with descriptive names
features <- read.table(
                paste(datafolder, "features.txt", sep = "/"), 
                sep = " ", 
                header = FALSE, 
                col.names = c("featureid", "featurename")) %>%
        mutate(
                selectedfeature = grepl("(mean|std)\\(\\)", featurename),
                width = 16 * (as.numeric(selectedfeature) * 2 - 1),
                cleanfeaturename = gsub("bodybody", "body", gsub("\\.", "_", 
                        tolower(
                                sub("^([tf])", "\\1.",
                                    gsub(",", "_",
                                         gsub("-", ".",
                                              gsub("[()]", "", featurename)
                                              )
                                         )
                                    )
                                )
                        ))
                )

# Function to fetch clean dataset given data source (train or test)
getcleandataset <- function(datasource) {
        folder = paste(datafolder, datasource, sep = "/")
        subjectfile = paste(folder, paste("subject_", datasource, ".txt", sep = ""), sep = "/")
        varfile = paste(folder, paste("X_", datasource, ".txt", sep = ""), sep = "/")
        activityfile = paste(folder, paste("y_", datasource, ".txt", sep = ""), sep = "/")

        activitydata <- read.table(file = activityfile, header = FALSE, sep = " ", col.names = c("activityid")) %>%
                mutate(activity <- factor(activityid, labels = activities$activityname))
        activitydata$activity <- factor(activitydata$activityid, labels = activities$activityname)

        subjectdata <- read.table(subjectfile, header = FALSE, sep = " ", col.names = c("subject"))


        vardata <- read.fwf(file = varfile, header = FALSE, 
                          widths = features$width,
                          col.names = features[features$selectedfeature,]$cleanfeaturename)
        
        cbind(
                category=c(datasource),
                activity = activitydata$activity,
                subjectdata,
                vardata
        )
}

# Merge data from data sources (namely, train and test)
mergeddata <- do.call("rbind",
         lapply(datasources, getcleandataset))

# Generate clean data
tidydata <- mergeddata %>%
        group_by(activity, subject) %>%
        summarise_at(
                .vars = features[features$selectedfeature,]$cleanfeaturename,
                .funs = c(mean)
        )
                
# Write clean data to file
write.table(tidydata, "tidydata.txt", row.names = FALSE, col.names = TRUE)

