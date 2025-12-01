#include <Rcpp.h>
#include <cmath>
#include <algorithm>
using namespace Rcpp;

//' Euclidean Distance (C++ implementation)
 //'
 //' @param x Numeric vector
 //' @param y Numeric vector
 //' @return Euclidean distance
 //' @keywords internal
 // [[Rcpp::export]]
 double dist_euclidean_cpp(NumericVector x, NumericVector y) {
   int n = x.size();
   if (n != y.size()) {
     stop("x and y must have the same length");
   }

   double sum_sq = 0.0;
   int n_valid = 0;

   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i]) && !NumericVector::is_na(y[i])) {
       double diff = x[i] - y[i];
       sum_sq += diff * diff;
       n_valid++;
     }
   }

   if (n_valid == 0) {
     return NA_REAL;
   }

   return std::sqrt(sum_sq) / n_valid;
 }

 //' Manhattan Distance (C++ implementation)
 //'
 //' @param x Numeric vector
 //' @param y Numeric vector
 //' @return Manhattan distance (L1 norm)
 //' @keywords internal
 // [[Rcpp::export]]
 double dist_manhattan_cpp(NumericVector x, NumericVector y) {
   int n = x.size();
   if (n != y.size()) {
     stop("x and y must have the same length");
   }

   double sum_abs = 0.0;
   int n_valid = 0;

   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i]) && !NumericVector::is_na(y[i])) {
       sum_abs += std::abs(x[i] - y[i]);
       n_valid++;
     }
   }

   if (n_valid == 0) {
     return NA_REAL;
   }

   return sum_abs / n_valid;
 }

 //' Chebyshev Distance (C++ implementation)
 //'
 //' @param x Numeric vector
 //' @param y Numeric vector
 //' @return Chebyshev distance (maximum absolute difference)
 //' @keywords internal
 // [[Rcpp::export]]
 double dist_chebyshev_cpp(NumericVector x, NumericVector y) {
   int n = x.size();
   if (n != y.size()) {
     stop("x and y must have the same length");
   }

   double max_diff = 0.0;
   bool found_valid = false;

   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i]) && !NumericVector::is_na(y[i])) {
       double diff = std::abs(x[i] - y[i]);
       if (!found_valid || diff > max_diff) {
         max_diff = diff;
         found_valid = true;
       }
     }
   }

   if (!found_valid) {
     return NA_REAL;
   }

   return max_diff;
 }

 //' Root Mean Square Error (C++ implementation)
 //'
 //' @param x Numeric vector
 //' @param y Numeric vector
 //' @return RMSE
 //' @keywords internal
 // [[Rcpp::export]]
 double diff_rmse_cpp(NumericVector x, NumericVector y) {
   int n = x.size();
   if (n != y.size()) {
     stop("x and y must have the same length");
   }

   double sum_sq = 0.0;
   int n_valid = 0;

   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i]) && !NumericVector::is_na(y[i])) {
       double diff = x[i] - y[i];
       sum_sq += diff * diff;
       n_valid++;
     }
   }

   if (n_valid == 0) {
     return NA_REAL;
   }

   return std::sqrt(sum_sq / n_valid);
 }

 //' Simpson's Diversity Index (C++ implementation)
 //'
 //' @param x Numeric vector of class values
 //' @return Simpson's diversity index
 //' @keywords internal
 // [[Rcpp::export]]
 double simpson_cpp(NumericVector x) {
   int n = x.size();

   if (n == 0) {
     return NA_REAL;
   }

   // Count frequencies
   std::unordered_map<double, int> counts;
   int n_valid = 0;

   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i])) {
       counts[x[i]]++;
       n_valid++;
     }
   }

   if (n_valid == 0) {
     return NA_REAL;
   }

   // Calculate Simpson's index: 1 - sum(p^2)
   double sum_p_sq = 0.0;
   double n_valid_d = static_cast<double>(n_valid);

   for (const auto& pair : counts) {
     double p = static_cast<double>(pair.second) / n_valid_d;
     sum_p_sq += p * p;
   }

   return 1.0 - sum_p_sq;
 }

 //' Shannon's Diversity Index (C++ implementation)
 //'
 //' @param x Numeric vector of class values
 //' @return Shannon's diversity index
 //' @keywords internal
 // [[Rcpp::export]]
 double shannon_cpp(NumericVector x) {
   int n = x.size();

   if (n == 0) {
     return NA_REAL;
   }

   // Count frequencies
   std::unordered_map<double, int> counts;
   int n_valid = 0;

   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i])) {
       counts[x[i]]++;
       n_valid++;
     }
   }

   if (n_valid == 0) {
     return NA_REAL;
   }

   // Calculate Shannon's index: -sum(p * log(p))
   double H = 0.0;
   double n_valid_d = static_cast<double>(n_valid);

   for (const auto& pair : counts) {
     double p = static_cast<double>(pair.second) / n_valid_d;
     H -= p * std::log(p);
   }

   return H;
 }
