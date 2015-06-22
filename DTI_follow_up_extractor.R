##Creation of a data frame with all subjects and acquisition time points
##that have been investigated by the use of DTI

DTI_follow_up_extractor <- function(tablefile) {
        ## In this function
        ## every subject with more than 1 DTI acquisition (Follow-Up-DTIs) is going to be
        ## calculated and displayed
        
        
        rohtabelle <- read.csv(file=tablefile)
        ## reads the first 10 rows of the original table into a data frame (rohtabelle)
        
        seqcolumn <- rohtabelle[, "Scans"]
        ## creates a data frame of the "Scans" column (seqcolumn)
        
        DTIrows <- grep("DTI", seqcolumn)
        ## creates a vector of all row numbers where DTI is part of the Sequence names
        
        allDTI <- rohtabelle[DTIrows, ]
        ## calculates a dataframe out of the raw table which only consists of acquisitions
        ## which consist of DTI (allDTI) and displays dataframe of all 
        ## acquisitions containing DTI acquisitions
        
        numofacq <- table(allDTI$Subject)
        ## displays all subjects with corresponding number of acquisitions
        
        fup1 <- numofacq > 1
        ## finds out which subjects have more than 1 DTI acquisition - follow-up patients
        
        followups <- numofacq[fup1]
        ## displays all subjects with more than 1 DTI acquisition (all follow - up 
        ## patients with number of acquisitions are displayed)
        
        fupnames <- dimnames(followups)
        ## drags out the names of all follow-up patients from followups
        
        subjcolumn <- rohtabelle[, "Subject"]
        ## creates a list of all Subjects from raw data table
        
        subjcolumchar <- as.character(subjcolumn)
        ## converts data frame of subjcolumn into character variable (for furhter 
        ## string processing)
        
        fupindex <- lapply(subjcolumchar, grep, fupnames)
        ## gives out 0 if no intersection between raw list of subjects and follow-up
        ## list of subjects is detected and gives out 1 if an element of raw data list
        ## of subjects is an element of follow-up list of subjects
        
        fupindexnaf <- fupindex > 0
        ## gives out NA if fupindex value is 0 and gives out TRUE if fupindex is > 0 
        ## (in this case 1). If patient is follow up than row number is TRUE, if not, 
        ## row- number is NA
        
        fupindextf <- is.na(fupindexnaf)
        ## gives out TRUE if fupindexnaf value is NA and gives out FALSE if fupindexnaf
        ## value was TRUE. If patient is follow up than row number is FALSE, if not,
        ## row-number is TRUE
        
        followuptable <- rohtabelle[!fupindextf, ]
        ## creates the follow up patients data frame from the original table by "deleting" all 
        ## non-follow-up patients
        
        
                ### Now all acquisitions of DTI-follow up patients which do NOT contain a DTI
                ### (the 3rd or 4th visit without DTI etc.) need to be excluded from the list!
                ### This will be done by just deleting all non-DTI acquisitions similar to the
                ### procedure of DTI_extractor
        
                ### You could also run the DTI_extractor seperately here but it would not be
                ### elegant to go the detour on a second csv-file but to stay within the R
                ### workspace!
        
                seqcolumnfup <- followuptable[, "Scans"]
                ## creates a data frame of the "Scans" column (seqcolumn)
                
                DTIrowsfup <- grep("DTI", seqcolumnfup)
                ## creates a vector of all row numbers where DTI is part of the Sequence names
                
                allDTIfup <- followuptable[DTIrowsfup, ]
                print(allDTIfup)
                ## calculates a dataframe out of the raw table which only consists of acquisitions
                ## which consist of DTI (allDTI) and displays dataframe of all 
                ## acquisitions containing DTI acquisitions
                
                numofacqfup <- table(allDTIfup$Subject)
                ## displays all subjects with corresponding number of acquisitions
                
                acq1fup <- numofacqfup > 1
                ## finds out which subjects have more than or equal to one DTI acquisition - DTI 
                ## patients
                
                acquisitionsubjfup <- numofacqfup[acq1fup]
                print(acquisitionsubjfup)
                ## displays all subjects with at least 1 DTI acquisition (all DTI patients
                ## with number of acquisitions are displayed) 
        
        
        ## Function to save as xls open data frames (tables) in excel
        ## source: modified from stackoverflow.com: Viewing tables of data in R
        

        write.table(allDTIfup, file = "DTI_Follow_up_patients.xls", col.names=NA)
        ## writes a table (saved as .xls file) which is supposed to be opened by 
        ## Microsoft Excel - includes all DTI-Follow-up- Patients
        
        write.table(acquisitionsubjfup, file = "Followups_DTI.xls")
        ## writes all subjects with respective acquisition numbers in an xls-file
        
        system(paste('open -a \"/Applications//Microsoft Office 2011/Microsoft Excel.app\"', "DTI_Follow_up_patients.xls"))
        ## automatically opens the DTI follow up patients table 
        ## Cave: Many warning messages (could be optimized further in the future)

        system(paste('open -a \"/Applications//Microsoft Office 2011/Microsoft Excel.app\"', "Followups_DTI.xls"))
        ## automatically opens the Follow up patients with number of acquisitions
        
       
        ## Saving data frames as .R - files by using dput (analogous to JHU R Programming
        ## lectures on coursera) and all frames in dump (analogous to coursera)


        dput(allDTIfup, file = "DTI_Follow_up_patients.R")
        ## Saving DTI follow up framework in an R file which can be easily redisplayed
        ## by using: dget("DTI_Follow_up_patients.R")


        ## Saving all data frames in one .R - file by using dump (analogous to JHU
        ## R Programming lectures on coursera)

        dump(c("allDTIfup", "acquistionsubjfup"), file = "Followups_DTI_save.R")
        ## Using dump to save both frameworks (as a vector?) within a file called
        ## "all_talbes.R" which can easily be loaded by the source command
        ## source("all_tables.R")
        
}