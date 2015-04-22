key <- ""
secret <- ""

mixpanel_funnel <- function(from_date, to_date, length, funnel_id, unit, key, secret){
  
  library(RCurl)
  library(rjson)
  library(digest)
  library(httr)  
  
  ## Set the arguments
  expire <- as.integer(as.numeric(as.POSIXlt(Sys.time()))) + 900 ## Set the expiry time for the API link as 15 minutes
  
  args_sig <- paste("expire=",expire,"format=json","from_date=",from_date,'funnel_id=',funnel_id,"length=",length,"to_date=",to_date,"unit=",unit,sep="",collapse=NULL)
  args_url <- paste('funnel_id=',funnel_id,"&expire=",expire,"&from_date=",from_date,"&format=json","&to_date=",to_date,"&length=",length,"&unit=",unit,sep="",collapse=NULL)
  
  sig <- paste("api_key=",key,args_sig,secret,sep="",collapse=NULL)
  hashed_sig <- digest(sig, algo="md5", serialize = FALSE)
  
  url <- paste("http://mixpanel.com/api/2.0/funnels/?","api_key=",key,"&",args_url,"&sig=",hashed_sig,sep="",collapse=NULL)
  
  dataset <- fromJSON(content(GET(url), as = 'text'))
  return(dataset)
}