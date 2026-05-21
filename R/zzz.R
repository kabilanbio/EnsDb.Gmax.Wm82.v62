#' @name EnsDb.Gmax.Wm82.v62
#' 
#' @title Ensembl-based annotations for Glycine max (soybean) assembly Williams 
#' 82 v4
#'
#' @description
#' This object provides gene, transcript and exon annotations for the
#' soybean genome assembly Williams 82 v4 (Glycine_max_v2.1) based on
#' Ensembl Plants release 62.  Gene IDs follow the Wm82.a4.v1
#' nomenclature (`Glyma.XXGXXXXXX`).  Chromosome lengths are included.
#'
#' The object is automatically loaded when the package is attached.
#' Use \code{EnsDb.Gmax.Wm82.v62} directly after
#' \code{library(EnsDb.Gmax.Wm82.v62)}.
#'
#' @return An \code{EnsDb} object providing access to the soybean annotation
#'     database.
#'
#' @examples
#' library(EnsDb.Gmax.Wm82.v62)
#' edb <- EnsDb.Gmax.Wm82.v62
#' # Retrieve the first 3 genes
#' head(genes(edb), 3)
#'
#' @import ensembldb
#' @importFrom DBI dbDisconnect
#' @export
#' 
#' @keywords data
NULL

# zzz.R
.ZENODO_URL <- paste0(
  "https://zenodo.org/records/20320955/files/",
  "Glycine_max.Glycine_max_v2.1.62.sqlite?download=1"
)

.onLoad <- function(libname, pkgname) {
  
  ## Create cache directory
  cache_dir <- tools::R_user_dir(pkgname, which = "cache")
  
  ## Initialize BiocFileCache
  bfc <- BiocFileCache::BiocFileCache(
    cache = cache_dir,
    ask = FALSE
  )
  
  ## Check whether SQLite file already exists in cache
  qres <- BiocFileCache::bfcquery(
    bfc,
    "Glycine_max.Glycine_max_v2.1.62.sqlite",
    field = "rname"
  )
  
  rid <- qres$rid
  
  ## Download if not available
  if (length(rid) == 0) {
    
    packageStartupMessage(
      "Downloading EnsDb SQLite database from Zenodo..."
    )
    
    rid <- names(
      BiocFileCache::bfcadd(
        x = bfc,
        rname = "Glycine_max.Glycine_max_v2.1.62.sqlite",
        fpath = .ZENODO_URL
      )
    )
  }
  
  ## Get local cached file path
  dbfile <- BiocFileCache::bfcrpath(
    bfc,
    rids = rid
  )
  
  ## Validate database file
  if (!file.exists(dbfile)) {
    stop("Failed to obtain SQLite database file.")
  }
  
  if (file.info(dbfile)$size == 0) {
    stop("Downloaded SQLite database file is empty.")
  }
  
  ## Create EnsDb object
  edb <- ensembldb::EnsDb(dbfile)
  
  ## Make object available in package namespace
  assign(
    "EnsDb.Gmax.Wm82.v62",
    edb,
    envir = asNamespace(pkgname)
  )
}
