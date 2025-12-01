#include <Rcpp.h>
#include <cmath>
#include <unordered_map>
#include <unordered_set>
using namespace Rcpp;

//' Calculate Kappa Index (C++ implementation)
 //'
 //' @param x Numeric vector representing raster values
 //' @return Numeric kappa index value
 //' @keywords internal
 // [[Rcpp::export]]
 double kappa_index_cpp(NumericVector x) {
   int n = x.size();

   // Handle empty input
   if (n == 0) {
     return NA_REAL;
   }

   // Calculate window size (assuming square window)
   double window_size_d = std::sqrt(static_cast<double>(n));
   int window_size = static_cast<int>(std::round(window_size_d));

   // Check if it's actually a square window
   if (window_size * window_size != n) {
     return NA_REAL;
   }

   // Count valid (non-NA) values
   int n_valid = 0;
   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i])) {
       n_valid++;
     }
   }

   // Need at least 2 valid pixels
   if (n_valid < 2) {
     return NA_REAL;
   }

   // Reconstruct matrix from vector
   NumericMatrix mat(window_size, window_size);
   for (int i = 0; i < window_size; i++) {
     for (int j = 0; j < window_size; j++) {
       mat(i, j) = x[i * window_size + j];
     }
   }

   // Get unique classes and build valid values vector
   std::unordered_set<double> class_set;
   std::unordered_map<double, int> class_counts;

   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i])) {
       class_set.insert(x[i]);
       class_counts[x[i]]++;
     }
   }

   std::vector<double> classes(class_set.begin(), class_set.end());
   std::sort(classes.begin(), classes.end());
   int n_classes = classes.size();

   // If only one class, kappa is 0 (no diversity)
   if (n_classes == 1) {
     return 0.0;
   }

   // Calculate class proportions
   std::unordered_map<double, double> class_props;
   for (const auto& pair : class_counts) {
     class_props[pair.first] = static_cast<double>(pair.second) / n_valid;
   }

   // Create class to index mapping
   std::unordered_map<double, int> class_to_idx;
   for (int i = 0; i < n_classes; i++) {
     class_to_idx[classes[i]] = i;
   }

   // Initialize adjacency matrix
   std::vector<std::vector<int>> adj_matrix(n_classes, std::vector<int>(n_classes, 0));
   int n_adjacencies = 0;

   // Count horizontal adjacencies
   for (int i = 0; i < window_size; i++) {
     for (int j = 0; j < window_size - 1; j++) {
       if (!NumericMatrix::is_na(mat(i, j)) && !NumericMatrix::is_na(mat(i, j + 1))) {
         double class1 = mat(i, j);
         double class2 = mat(i, j + 1);
         int idx1 = class_to_idx[class1];
         int idx2 = class_to_idx[class2];
         adj_matrix[idx1][idx2]++;
         n_adjacencies++;
       }
     }
   }

   // Count vertical adjacencies
   for (int i = 0; i < window_size - 1; i++) {
     for (int j = 0; j < window_size; j++) {
       if (!NumericMatrix::is_na(mat(i, j)) && !NumericMatrix::is_na(mat(i + 1, j))) {
         double class1 = mat(i, j);
         double class2 = mat(i + 1, j);
         int idx1 = class_to_idx[class1];
         int idx2 = class_to_idx[class2];
         adj_matrix[idx1][idx2]++;
         n_adjacencies++;
       }
     }
   }

   // If no adjacencies found, return NA
   if (n_adjacencies == 0) {
     return NA_REAL;
   }

   // Calculate proportion of adjacencies (g_ik)
   std::vector<std::vector<double>> g_ik(n_classes, std::vector<double>(n_classes, 0.0));
   for (int i = 0; i < n_classes; i++) {
     for (int j = 0; j < n_classes; j++) {
       g_ik[i][j] = static_cast<double>(adj_matrix[i][j]) / n_adjacencies;
     }
   }

   // Calculate observed proportion of like adjacencies (Po)
   double Po = 0.0;
   for (int i = 0; i < n_classes; i++) {
     Po += g_ik[i][i];
   }

   // Calculate expected proportion of like adjacencies (Pe)
   double Pe = 0.0;
   for (int i = 0; i < n_classes; i++) {
     double p_i = class_props[classes[i]];

     // Sum of g_ik across all columns for this row
     double sum_g_ik = 0.0;
     for (int k = 0; k < n_classes; k++) {
       sum_g_ik += g_ik[i][k];
     }

     Pe += p_i * sum_g_ik;
   }

   // Calculate Kappa index
   // Kappa = (Po - Pe) / (1 - Pe)
   if (Pe >= 1.0) {
     // Avoid division by zero
     return 0.0;
   }

   double kappa = (Po - Pe) / (1.0 - Pe);

   return kappa;
 }
