# sentometrics
#### An Integrated Framework for Textual Sentiment Based Multivariate Time Series Modeling and Forecasting

## Introduction

The `sentometrics` package is designed to do time series analysis based on textual sentiment. It accounts for the intrinsic challenge that for a given text sentiment can be computed in hundreds of different ways, as well as the large number of possibilities to pool sentiment across text and time. This additional layer of manipulation does not exist in standard time series analysis packages. As a final outcome, this package provides an automated means to econometrically model the impact of sentiment in texts on a given variable, by optimizing the sentiment extraction and aggregation for the forecasting task. Aggregation can be optimized across several dimensions, for example word term weighting schemes or time lag structures. The package created therefore integrates the qualification of sentiment from text, the aggregation into different sentiment measures and the optimized forecasting based on these measures.

## Installation

The latest development version of `sentometrics` is available at [https://github.com/ArdiaD/Sentometrics](https://github.com/ArdiaD/Sentometrics).
  
To install the latest development version (which may contain bugs!), execute these lines:

      R > install.packages("devtools")
      R > require("devtools")
      R > devtools::install_github("ArdiaD/Sentometrics")

The most up-to-date manual can be found under the *docs/* folder.

## References

Please cite `sentometrics` in publications.

## Acknowledgements

This software package originates from a
[Google Summer of Code 2017](https://github.com/rstats-gsoc/gsoc2017/wiki/Sentometrics:-An-integrated-framework-for-text-based-multivariate-time-series-modeling-and-forecasting) project.

