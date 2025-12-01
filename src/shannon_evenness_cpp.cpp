#include <Rcpp.h>
#include <cmath>
#include <unordered_map>
using namespace Rcpp;

//' Calculate Shannon Evenness Index (C++ implementation)
 //'
 //' @param x Numeric vector of class values
 //' @return Shannon evenness index (0-1)
 //' @keywords internal
 // [[Rcpp::export]]
 double shannon_evenness_cpp(NumericVector x) {
   int n = x.size();

   if (n == 0) {
     return NA_REAL;
   }

   // Count frequencies using hash map for O(n) performance
   std::unordered_map<double, int> counts;
   int n_valid = 0;

   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i])) {
       counts[x[i]]++;
       n_valid++;
     }
   }

   // Need at least 2 valid values
   if (n_valid < 2) {
     return NA_REAL;
   }

   int S = counts.size();

   // No evenness if only one class
   if (S <= 1) {
     return NA_REAL;
   }

   // Calculate Shannon entropy H
   double H = 0.0;
   double n_valid_d = static_cast<double>(n_valid);

   for (const auto& pair : counts) {
     double p = static_cast<double>(pair.second) / n_valid_d;
     H -= p * std::log(p);
   }

   // Calculate evenness E = H / log(S)
   double E = H / std::log(static_cast<double>(S));

   return E;
 }
