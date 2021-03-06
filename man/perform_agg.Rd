% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sentomeasures.R
\name{perform_agg}
\alias{perform_agg}
\title{Aggregate textual sentiment across documents and time}
\usage{
perform_agg(toAgg, ctr)
}
\arguments{
\item{toAgg}{output from a \code{\link{compute_sentiment}} call.}

\item{ctr}{output from a \code{\link{ctr_agg}} call. The \code{"howWithin"} argument plays no more role.}
}
\value{
A \code{sentomeasures} object.
}
\description{
Condense document-level textual sentiment scores into a panel of textual sentiment
measures by aggregating across documents and time. This function is called within \code{\link{sento_measures}},
applied on the output of \code{\link{compute_sentiment}}.
}
\examples{
data("usnews")
data("lexicons")
data("valence")

# computation of sentiment and aggregation into sentiment measures
corpus <- sento_corpus(corpusdf = usnews)
corpusSample <- quanteda::corpus_sample(corpus, size = 1000)
l <- setup_lexicons(lexicons[c("LM_eng", "HENRY_eng")], valence[["valence_eng"]])
sent <- compute_sentiment(corpusSample, l, how = "counts")
ctr <- ctr_agg(howTime = c("linear"), by = "year", lag = 3)
sentomeasures <- perform_agg(sent, ctr)

}
\seealso{
\code{\link{compute_sentiment}}, \code{\link{ctr_agg}}, \code{\link{sento_measures}}
}
\author{
Samuel Borms, Keven Bluteau
}
