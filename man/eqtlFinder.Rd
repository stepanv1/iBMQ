\name{eqtlFinder}
\alias{eqtlFinder}
\title{
eqtlFinder
}
\description{
We can calculate how many eQTLs have PPA above the cutoff with the eqtlFinder function.
}
\usage{
find.eqtl(prob, threshold)
}

\arguments{
  \item{prob}{matrix or data frame that contains Posterior 
}
  \item{threshold}{Threshold to use for significant QTL. This value can be the output of the calculateThreshold function.It must be a numerical value between 0 and 1.
}
}

\value{
The output of the eqtlFinder

}
