#include <Rcpp.h>
#include <cmath>
#include <unordered_map>
#include <unordered_set>
using namespace Rcpp;

//' Calculate Kappa Index Between Two Maps (C++ implementation)
 //'
 //' @param x Numeric vector representing raster values from map 1
 //' @param y Numeric vector representing raster values from map 2
 //' @return Numeric kappa index value (Cohen's Kappa for agreement between maps)
 //' @keywords internal
 // [[Rcpp::export]]
 double kappa_index_cpp(NumericVector x, NumericVector y) {
   int n = x.size();

   // Check inputs
   if (n == 0) {
     return NA_REAL;
   }

   if (x.size() != y.size()) {
     stop("Vectors x and y must have the same length");
   }

   // Verify square window (optional check)
   double window_size_d = std::sqrt(static_cast<double>(n));
   int window_size = static_cast<int>(std::round(window_size_d));

   if (window_size * window_size != n) {
     // Not strictly required, but good to know
   }

   // Count valid pairs (both non-NA)
   int n_valid = 0;
   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i]) && !NumericVector::is_na(y[i])) {
       n_valid++;
     }
   }

   // Need at least 2 valid pairs
   if (n_valid < 2) {
     return NA_REAL;
   }

   // Get all unique classes across both maps
   std::unordered_set<double> class_set;
   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i]) && !NumericVector::is_na(y[i])) {
       class_set.insert(x[i]);
       class_set.insert(y[i]);
     }
   }

   std::vector<double> classes(class_set.begin(), class_set.end());
   std::sort(classes.begin(), classes.end());
   int n_classes = classes.size();

   // If only one class, kappa is 0 (no variability)
   if (n_classes == 1) {
     return 0.0;
   }

   // Create class to index mapping
   std::unordered_map<double, int> class_to_idx;
   for (int i = 0; i < n_classes; i++) {
     class_to_idx[classes[i]] = i;
   }

   // Initialize confusion matrix (rows = x, cols = y)
   std::vector<std::vector<int>> confusion_matrix(n_classes, std::vector<int>(n_classes, 0));

   // Fill confusion matrix with valid pairs
   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i]) && !NumericVector::is_na(y[i])) {
       double val_x = x[i];
       double val_y = y[i];
       int idx_x = class_to_idx[val_x];
       int idx_y = class_to_idx[val_y];
       confusion_matrix[idx_x][idx_y]++;
     }
   }

   // Calculate observed agreement (Po)
   // Proportion of diagonal elements
   int n_diagonal = 0;
   for (int i = 0; i < n_classes; i++) {
     n_diagonal += confusion_matrix[i][i];
   }
   double Po = static_cast<double>(n_diagonal) / n_valid;

   // Calculate expected agreement by chance (Pe)
   // Pe = sum of (marginal_x / n) * (marginal_y / n)
   double Pe = 0.0;
   for (int i = 0; i < n_classes; i++) {
     // Marginal sum for row i (map x)
     int marginal_x = 0;
     for (int j = 0; j < n_classes; j++) {
       marginal_x += confusion_matrix[i][j];
     }

     // Marginal sum for column i (map y)
     int marginal_y = 0;
     for (int j = 0; j < n_classes; j++) {
       marginal_y += confusion_matrix[j][i];
     }

     double p_x = static_cast<double>(marginal_x) / n_valid;
     double p_y = static_cast<double>(marginal_y) / n_valid;
     Pe += p_x * p_y;
   }

   // Calculate Cohen's Kappa
   // Kappa = (Po - Pe) / (1 - Pe)
   if (Pe >= 1.0) {
     // Avoid division by zero
     return 0.0;
   }

   double kappa = (Po - Pe) / (1.0 - Pe);

   return kappa;
 }
