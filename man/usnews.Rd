% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sentometrics.R
\docType{data}
\name{usnews}
\alias{usnews}
\title{Texts (not) relevant to the U.S. economy}
\format{A \code{data.frame}, formatted as required to be an input for \code{\link{sento_corpus}}.}
\source{
\href{https://www.crowdflower.com/data-for-everyone/}{Economic News Article Tone and Relevance}
}
\usage{
data("usnews")
}
\description{
A collection of texts annotated by humans in terms of relevance to the U.S. economy or not. The texts come from two major
journals in the U.S. (The Wall Street Journal and The Washington Post) and cover 4145 documents between 1995 and 2014. It
contains following information:

\itemize{
  \item id. A \code{character} ID identifier.
  \item date. Date as \code{"yyyy-mm-dd"}.
  \item text. Texts in \code{character} format.
  \item wsj. Equals 1 if the article comes from The Wall Street Journal.
  \item wapo. Equals 1 if the article comes from The Washington Post.
  \item economy. Equals 1 if the article is relevant to the U.S. economy.
  \item noneconomy. Equals 1 if the article is not relevant to the U.S. economy.
}
}
\examples{
data("usnews")
usnews[3192, "text"]
usnews[1:5, c("id", "date", "text")]

}
\keyword{datasets}
