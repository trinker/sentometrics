% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sentomeasures.R
\name{ctr_agg}
\alias{ctr_agg}
\title{Set up control for aggregation into sentiment measures}
\usage{
ctr_agg(howWithin = "proportional", howDocs = "equal_weight",
  howTime = "equal_weight", do.ignoreZeros = TRUE, by = "day", lag = 1L,
  fill = "zero", alphasExp = seq(0.1, 0.5, by = 0.1), ordersAlm = 1:3,
  do.inverseAlm = TRUE, do.normalizeAlm = TRUE, weights = NULL,
  dfm = NULL)
}
\arguments{
\item{howWithin}{a single \code{character} vector defining how aggregation within documents will be performed. Should
\code{length(howWithin) > 1}, the first element is used. For currently available options on how aggregation can occur, see
\code{\link{get_hows}()$words}.}

\item{howDocs}{a single \code{character} vector defining how aggregation across documents per date will be performed.
Should \code{length(howDocs) > 1}, the first element is used. For currently available options on how aggregation can occur,
see \code{\link{get_hows}()$docs}.}

\item{howTime}{a \code{character} vector defining how aggregation across dates will be performed. More than one choice
is possible. For currently available options on how aggregation can occur, see \code{\link{get_hows}()$time}.}

\item{do.ignoreZeros}{a \code{logical} indicating whether zero sentiment values have to be ignored in the determination of
the document weights while aggregating across documents. By default \code{do.ignoreZeros = TRUE}, such that documents with
an exact score of zero are considered irrelevant.}

\item{by}{a single \code{character} vector, either \code{"day", "week", "month"} or \code{"year"}, to indicate at what
level the dates should be aggregated. Dates are displayed as the first day of the period, if applicable (e.g.,
\code{"2017-03-01"} for March 2017).}

\item{lag}{a single \code{integer} vector, being the time lag to be specified for aggregation across time. By default
equal to \code{1L}, meaning no aggregation across time.}

\item{fill}{a single \code{character} vector, one of \code{c("zero", "latest", "none")}, to control how missing
sentiment values across the continuum of dates considered are added. This impacts the aggregation across time,
applying the \code{\link{fill_measures}} function before aggregating, except if \code{fill = "none"}. By default equal to
\code{"zero"}, which sets the scores (and thus also the weights) of the added dates to zero in the time aggregation.}

\item{alphasExp}{a \code{numeric} vector of all exponential smoothing factors to calculate weights for, used if
\code{"exponential" \%in\% howTime}. Values should be between 0 and 1 (both excluded).}

\item{ordersAlm}{a \code{numeric} vector of all Almon polynomial orders to calculate weights for, used if
\code{"almon" \%in\% howTime}.}

\item{do.inverseAlm}{a \code{logical} indicating if for every Almon polynomial its inverse has to be added, used
if \code{"almon" \%in\% howTime}.}

\item{do.normalizeAlm}{a \code{logical} indicating if every Almon polynomial weights column should sum to one, used if
\code{"almon" \%in\% howTime}.}

\item{weights}{an optional own weighting scheme, always used if provided as a \code{data.frame} with the number of rows
equal to the desired \code{lag}. The automatic Almon polynomials are created sequentially; if the user wants only specific
of such time weighting series it can use \code{\link{almons}}, select the columns it requires, combine it into a
\code{data.frame} and supply it under this argument (see examples).}

\item{dfm}{optional; see \code{\link{compute_sentiment}}.}
}
\value{
A \code{list} encapsulating the control parameters.
}
\description{
Sets up control object for aggregation of document-level textual sentiment into textual
sentiment measures (indices).
}
\details{
For currently available options on how aggregation can occur (via the \code{howWithin},
\code{howDocs} and \code{howTime} arguments), call \code{\link{get_hows}}.
}
\examples{
# simple control function
ctr1 <- ctr_agg(howTime = "linear", by = "year", lag = 3)

# more elaborate control function (particular attention to time weighting schemes)
ctr2 <- ctr_agg(howWithin = "tf-idf",
                howDocs = "proportional",
                howTime = c("equal_weight", "linear", "almon", "exponential", "own"),
                do.ignoreZeros = TRUE,
                by = "day",
                lag = 20,
                ordersAlm = 1:3,
                do.inverseAlm = TRUE,
                do.normalizeAlm = TRUE,
                alphasExp = c(0.20, 0.50, 0.70, 0.95),
                weights = data.frame(myWeights = runif(20)))

# set up control function with one linear and two chosen Almon weighting schemes
a <- almons(n = 70, orders = 1:3, do.inverse = TRUE, do.normalize = TRUE)
ctr3 <- ctr_agg(howTime = c("linear", "own"), by = "year", lag = 70,
                weights = data.frame(a1 = a[, 1], a2 = a[, 3]))

}
\seealso{
\code{\link{fill_measures}}, \code{\link{almons}}, \code{\link{compute_sentiment}}
}
\author{
Samuel Borms, Keven Bluteau
}
