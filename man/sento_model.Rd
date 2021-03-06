% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sentomodel.R
\name{sento_model}
\alias{sento_model}
\title{Optimized and automated sparse regression}
\usage{
sento_model(sentomeasures, y, x = NULL, ctr)
}
\arguments{
\item{sentomeasures}{a \code{sentomeasures} object created using \code{\link{sento_measures}}. There should be at least
two explanatory variables including the ones provided through the \code{x} argument.}

\item{y}{a one-column \code{data.frame} or a \code{numeric} vector capturing the dependent (response) variable. In case of
a logistic regression, the response variable is either a \code{factor} or a \code{matrix} with the factors represented by
the columns as binary indicators, with the second factor level or column as the reference class in case of a binomial
regression. No \code{NA} values are allowed.}

\item{x}{a named \code{data.frame} with other explanatory variables as \code{numeric}, by default set to \code{NULL}.}

\item{ctr}{output from a \code{\link{ctr_model}} call.}
}
\value{
If \code{ctr$do.iter = FALSE}, a \code{sentomodel} object which is a \code{list} containing:
\item{reg}{optimized regression, i.e. a model-specific \code{glmnet} object.}
\item{model}{the input argument \code{ctr$model}, to indicate the type of model estimated.}
\item{x}{a \code{matrix} of the values used in the regression for all explanatory variables.}
\item{alpha}{calibrated alpha.}
\item{lambda}{calibrated lambda.}
\item{trained}{output from \code{\link[caret]{train}} call (if \code{ctr$type =} "\code{cv}").}
\item{ic}{a \code{list} composed of two elements: the information criterion used in the calibration under
\code{"criterion"}, and a vector of all minimum information criterion values for each value in \code{alphas}
under \code{"opts"} (if \code{ctr$type !=} "\code{cv}").}
\item{dates}{sample reference dates as a two-element \code{character} vector, being the earliest and most recent date from
the \code{sentomeasures} object accounted for in the estimation window.}
\item{nVar}{the sum of the number of sentiment measures and other explanatory variables inputted.}
\item{discarded}{a named \code{logical} vector of length equal to the number of sentiment measures, in which \code{TRUE}
indicates that the particular sentiment measure has not been considered in the regression process. A sentiment measure is
not considered when it is a duplicate of another, or when at least 25\% of the observations are equal to zero.}

If \code{ctr$do.iter = TRUE}, a \code{sentomodeliter} object which is a \code{list} containing:
\item{models}{all sparse regressions, i.e. separate \code{sentomodel} objects as above, as a \code{list} with as names the
dates from the perspective of the sentiment measures at which predictions for performance measurement are carried out (i.e.
one date step beyond the date \code{sentomodel$dates[2]}).}
\item{alphas}{calibrated alphas.}
\item{lambdas}{calibrated lambdas.}
\item{performance}{a \code{data.frame} with performance-related measures, being "\code{RMSFE}" (root mean squared
forecasting error), "\code{MAD}" (mean absolute deviation), "\code{MDA}" (mean directional accuracy, in which's calculation
zero is considered as a positive; in percentage points), "\code{accuracy}" (proportion of correctly predicted classes in case
of a logistic regression; in percentage points), and each's respective individual values in the sample. Directional accuracy
is measured by comparing the change in the realized response with the change in the prediction between two consecutive time
points (omitting the very first prediction, resulting in \code{NA}). Only the relevant performance statistics are given
depending on the type of regression. Dates are as in the \code{"models"} output element, i.e. from the perspective of the
sentiment measures.}
}
\description{
Linear or nonlinear penalized regression of any dependent variable on the wide number of sentiment measures and
potentially other explanatory variables. Either performs a regression given the provided variables at once, or computes
regressions sequentially for a given sample size over a longer time horizon, with associated one-step ahead prediction
performance metrics.
}
\details{
Models are computed using the elastic net regularization as implemented in the \pkg{glmnet} package, to account for
the multidimensionality of the sentiment measures. Additional explanatory variables are not subject to shrinkage. Independent
variables are normalized in the regression process, but coefficients are returned in their original space. For a helpful
introduction to \pkg{glmnet}, we refer to the \href{https://web.stanford.edu/~hastie/glmnet/glmnet_alpha.html#lin}{vignette}.
The optimal elastic net parameters \code{lambda} and \code{alpha} are calibrated either through a to specify information
criterion or through cross-validation (based on the "rolling forecasting origin" principle, using the
\code{\link[caret]{train}} function). In the latter case, the training metric is automatically set to \code{"RMSE"} for
a linear model and to \code{"Accuracy"} for a logistic model. We suppress many of the details that can be supplied to the
\code{\link[glmnet]{glmnet}} and \code{\link[caret]{train}} functions we rely on, for the sake of user-friendliness.
}
\examples{
data("usnews")
data("lexicons")
data("valence")
data("epu")

# construct a sentomeasures object to start with
corpusAll <- sento_corpus(corpusdf = usnews)
corpus <- quanteda::corpus_subset(corpusAll, date >= "2004-01-01" & date < "2014-10-01")
l <- setup_lexicons(lexicons[c("LM_eng", "HENRY_eng")], valence[["valence_eng"]])
ctr <- ctr_agg(howWithin = "tf-idf", howDocs = "proportional",
               howTime = c("equal_weight", "almon"),
               by = "month", lag = 3, ordersAlm = 1:2,
               do.inverseAlm = TRUE, do.normalizeAlm = TRUE)
sentomeasures <- sento_measures(corpus, l, ctr)

# prepare y and other x variables
y <- epu[epu$date >= sentomeasures$measures$date[1], ]$index
length(y) == nrow(sentomeasures$measures) # TRUE
x <- data.frame(runif(length(y)), rnorm(length(y))) # two other (random) x variables
colnames(x) <- c("x1", "x2")

# a linear model based on the Akaike information criterion
ctrIC <- ctr_model(model = "gaussian", type = "AIC", do.iter = FALSE, h = 0)
out1 <- sento_model(sentomeasures, y, x = x, ctr = ctrIC)

# some post-analysis (attribution)
attributions1 <- retrieve_attributions(out1, sentomeasures,
                                       refDates = sentomeasures$measures$date[20:40])

\dontrun{
# a cross-validation based model
cl <- makeCluster(detectCores() - 2)
registerDoParallel(cl)
ctrCV <- ctr_model(model = "gaussian", type = "cv", do.iter = FALSE,
                   h = 0, alphas = c(0.10, 0.50, 0.90), trainWindow = 70,
                   testWindow = 10, oos = 0, do.progress = TRUE)
out2 <- sento_model(sentomeasures, y, x = x, ctr = ctrCV)
stopCluster(cl)
summary(out2)}

\dontrun{
# a cross-validation based model but for a binomial target
yb <- epu[epu$date >= sentomeasures$measures$date[1], ]$above
ctrCVb <- ctr_model(model = "binomial", type = "cv", do.iter = FALSE,
                    h = 0, alphas = c(0.10, 0.50, 0.90), trainWindow = 70,
                    testWindow = 10, oos = 0, do.progress = TRUE)
out3 <- sento_model(sentomeasures, yb, x = x, ctr = ctrCVb)
summary(out3)}

# an example of an iterative analysis
ctrIter <- ctr_model(model = "gaussian", type = "BIC", do.iter = TRUE,
                     alphas = c(0.25, 0.75), h = 0, nSample = 100, start = 21)
out4 <- sento_model(sentomeasures, y, x = x, ctr = ctrIter)
summary(out4)

\dontrun{
# a similar iterative analysis, parallelized
cl <- makeCluster(detectCores() - 2)
registerDoParallel(cl)
ctrIter <- ctr_model(model = "gaussian", type = "Cp", do.iter = TRUE,
                     h = 0, nSample = 100, do.parallel = TRUE)
out5 <- sento_model(sentomeasures, y, x = x, ctr = ctrIter)
stopCluster(cl)
summary(out5)}

# some more post-analysis (attribution and prediction)
attributions2 <- retrieve_attributions(out4, sentomeasures)
plot_attributions(attributions2, "features")

nx <- ncol(sentomeasures$measures) - 1 + ncol(x) # don't count date column
newx <- runif(nx) * cbind(sentomeasures$measures[, -1], x)[30:50, ]
preds <- predict(out1, newx = as.matrix(newx), type = "link")

}
\seealso{
\code{\link{ctr_model}}, \code{\link[glmnet]{glmnet}}, \code{\link[caret]{train}},
\code{\link{retrieve_attributions}}
}
\author{
Samuel Borms, Keven Bluteau
}
