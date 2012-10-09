eqtlMcmc <-
function(snp,expr,n.iter,burn.in,n.sweep,nproc, constC = TRUE, write.output = TRUE, RIS=TRUE)
{
	

if(!is(snp,"SnpSet")){
	 stop("The snp need to be in a SnpSet")
	}
if(!is(expr,"ExpressionSet")){
	 stop("The gene expression data need to be ExpressionSet")
	}
	
	mat.snp <- t(exprs(snp))
	mat.expr <-t(exprs(expr))
	
	n.pheno <- length(as.data.frame(mat.expr))
	n.snp <- length(as.data.frame(mat.snp))
	
	
if(!is.null(mat.expr)){
  n.indiv <- length(as.data.frame(mat.expr)[[1]])
  names.indiv <- rownames(mat.expr)
  names.gene <- colnames(mat.expr)
}

if(!is.null(mat.snp)){
  n.indiv1 <- length(as.data.frame(mat.snp)[[1]])
  names.indiv1 <- rownames(mat.snp)
  names.snp<- colnames(mat.snp)
  mat.snp <- unlist(mat.snp)
}

if(!is.null(mat.expr) &! is.null(mat.snp)){
  if(n.indiv != n.indiv1){
    cat("indivs number in expr is",n.indiv,"\n")
    cat("indivs number in snp is",n.indiv1,"\n")
    stop("there is a problem with indiv numbers")
  }
  if(any(names.indiv != names.indiv1)){
    cat("indivs name in expr are",names.indiv,"\n")
    cat("indivs name in snp are",names.indiv1,"\n")
    stop("there is a problem with indivs names")
  }
}



if(RIS == TRUE){
  if(!all((mat.snp == 1)| (mat.snp == 0))){
    stop("The SNPs value need to be 0 and 1")
  }
	
  mat.snp[mat.snp==0] <- -0.5
  mat.snp[mat.snp==1] <- 0.5
}
	
else{
  if(!all((mat.snp == 1)| (mat.snp == 2) | (mat.snp == 3))){
    stop("The SNPs value need to be 1,2,3")}

}
	
	
	
pheno <- unlist(mat.expr)
	

start.time <- Sys.time()
outProb <- double(length = n.snp*n.pheno)


c.function="c_qtl_main_parallel_sparse"
eps <- 10*(.Machine$double.eps)
nmax <- 500
res <- .C(c.function,as.double(pheno),as.integer(n.indiv),
		as.integer(n.pheno),as.double(mat.snp),as.integer(n.snp),
		as.integer(n.iter),as.integer(burn.in),as.integer(n.sweep),
		as.double(outProb), as.integer(nproc), as.integer(nmax), as.double(eps),
		as.integer(write.output), as.integer(!constC))
end.time <- Sys.time()
cat("running MCMC takes ")
cat(as.character(round(difftime(end.time,start.time,units="min"),digits=2)))
cat(" minutes.\n")
dim(res[[9]]) <- c(n.snp, n.pheno)
out<-res[[9]]
colnames(out)<-names.gene
rownames(out)<-names.snp
return(out)
}
