##Creation of a data frame with all subjects and acquisition time points
##that have been investigated by the use of DTI

DTI_extractor <- function(tablefile) {
        ## finds all subjects with DTI MRI acquisition from XNAT-csv-file (tablefile)
        ## and converts them into an R framework and saves as xls and R files
        
        rohtabelle <- read.csv(file=tablefile)
        ## reads the first 10 rows of the original table into a data frame (rohtabelle)

        seqcolumn <- rohtabelle[, "Scans"]
        ## creates a data frame of the "Scans" column (seqcolumn)

        DTIrows <- grep("DTI", seqcolumn)
        ## creates a vector of all row numbers where DTI is part of the Sequence names
        
        allDTI <- rohtabelle[DTIrows, ]
        print(allDTI)
        ## calculates a dataframe out of the raw table which only consists of acquisitions
        ## which consist of DTI (allDTI) and displays dataframe of all 
        ## acquisitions containing DTI acquisitions

        numofacq <- table(allDTI$Subject)
        ## displays all subjects with corresponding number of acquisitions
        
        acq1 <- numofacq > 0
        ## finds out which subjects have more than or equal to one DTI acquisition - DTI 
        ## patients

        acquisitionsubj <- numofacq[acq1]
        print(acquisitionsubj)
        ## displays all subjects with at least 1 DTI acquisition (all DTI patients
        ## with number of acquisitions are displayed) 


        ## Function to save as xls open data frames (tables) in excel
        ## source: modified from stackoverflow.com: Viewing tables of data in R
        
        write.table(allDTI, file = "All_DTI_patients.xls", col.names=NA)
        ## writes a table (saved as .xls file) which is supposed to be opened by 
        ## Microsoft Excel - includes the allDTI dataframe
        ## col.names=NA sorgt daf?r, dass die erste Spalten?berschrift frei bleibt
        ## (besser f?r die Ansicht der Excel-Tabelle, weil sonst die Headers eine 
        ## Zeile zu weit nach links verrutscht erscheinen)
        
        write.table(acquisitionsubj, file = "Subjects_with_DTI.xls")
        ## writes all subjects with respective acquisition numbers in an xls-file
        
        system(paste('open -a \"/Applications//Microsoft Office 2011/Microsoft Excel.app\"', "All_DTI_patients.xls"))
        ## automatically opens the allDTI patients table 
        ## Cave: Many warning messages (could be optimized further in the future)
        
        system(paste('open -a \"/Applications//Microsoft Office 2011/Microsoft Excel.app\"', "Subjects_with_DTI.xls"))
        
        
        ## Saving data frames as .R - files by using dput (analogous to JHU R Programming
        ## lectures on coursera) and all frames in dump (analogous to coursera)
        
        dput(allDTI, file = "All_DTI_patients.R")
        ## Saving All DTI patient framework in an R file which can be easily redisplayed
        ## by using: dget("All_DTI_patients.R")
        
        dump(c("allDTI", "acquisitionsubj"), file = "All_DTI_patients_saved.R")
        ## Using dump to save both frameworks (as a vector?) within a file called
        ## "all_talbes.R" which can easily be loaded by the source command
        ## source("all_tables.R")        
}
