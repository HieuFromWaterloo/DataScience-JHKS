# In this example we introduce the <<- operator which can be used to 
# assign a value to an object in an environment that is different 
# from the current environment.

makeVector <- function(x = numeric()) {
  m <- NULL
  # set the value of the vector
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  # get the value of the vector
  get <- function() x
  # set the value of the mean
  setmean <- function(mean) m <<- mean
  # get the value of the mean
  getmean <- function() m
  list(set = set, get = get,
       setmean = setmean,
       getmean = getmean)
}

# The following function calculates the mean of the special "vector" 
# created with the above function. However, it first checks to see if 
# the mean has already been calculated. If so, it gets the mean from 
# the cache and skips the computation. Otherwise, it calculates the 
# mean of the data and sets the value of the mean in the cache via 
# the setmean function.

cachemean <- function(x, ...) {
  m <- x$getmean()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  data <- x$get()
  m <- mean(data, ...)
  x$setmean(m)
  m
}

########## COURSE 2 - WEEK 3 - ASSIGNMENT ###########
# 1. makeCacheMatrix - creates a special "matrix" object that can cache 
# its inverse:

makeCacheMatrix <- function(m = matrix()) {
  
  ## Initialize the inverse operator
  inv <- NULL
  
  ## set values of the matrix
  set <- function(amatrix) {
    mtx <<- amatrix
    inv <<- NULL
  }
  
  ## get values of the matrix
  get <- function() mtx
  
  ## set the inverse of the matrix
  setInverse <- function(inverse) inv <<- inverse
  
  ## get the inverse of the matrix
  getInverse <- function() inv
  list(set = set, get = get,
       setInverse = setInverse,
       getInverse = getInverse)
}


# 2. cacheSolve - computes the inverse of the special "matrix" returned 
# by makeCacheMatrix above. If the inverse has already been calculated 
# (and the matrix has not changed), then the cachesolve should retrieve 
# the inverse from the cache.

# ** NOTE ** assume that the matrix supplied is always invertible.

cacheSolve <- function(mtx, ...) {
  
  ## return inversed matrix of x
  mtx_inv <- mtx$getInverse()
  
  ## return the inverse if existed
  if(!is.null(mtx_inv)) {
    message("getting cached data")
    return(mtx_inv)
  }
  
  ## Get the matrix from data
  data <- mtx$get()
  
  ## compute the inverse
  mtx_inv <- solve(data) %*% data
  
  ## Set the inverse to the object
  mtx$setInverse(mtx_inv)
  
  ## Return the matrix
  mtx_inv
}

