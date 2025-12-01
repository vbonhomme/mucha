#include <Rcpp.h>
#include <cmath>
#include <unordered_map>
#include <unordered_set>
using namespace Rcpp;

//' Calculate Contagion Index (C++ implementation)
 //'
 //' @param x Numeric vector representing raster values
 //' @return Numeric contagion index value
 //' @keywords internal
 // [[Rcpp::export]]
 double contagion_cpp(NumericVector x) {
   int n = x.size();

   // Calculate window size (assuming square window)
   int window_size = std::sqrt(n);

   // Reconstruct matrix from vector
   NumericMatrix mat(window_size, window_size);
   for (int i = 0; i < window_size; i++) {
     for (int j = 0; j < window_size; j++) {
       mat(i, j) = x[i * window_size + j];
     }
   }

   // Get valid (non-NA) values
   std::vector<double> x_valid;
   for (int i = 0; i < n; i++) {
     if (!NumericVector::is_na(x[i])) {
       x_valid.push_back(x[i]);
     }
   }

   // Need at least 2 valid pixels
   if (x_valid.size() < 2) {
     return NA_REAL;
   }

   // Get unique classes
   std::unordered_set<double> class_set(x_valid.begin(), x_valid.end());
   std::vector<double> classes(class_set.begin(), class_set.end());
   std::sort(classes.begin(), classes.end());
   int n_classes = classes.size();

   // If only one class, contagion is maximum
   if (n_classes == 1) {
     return 100.0;
   }

   // Calculate proportions (for reference, though not used in final calc)
   int n_total = x_valid.size();

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

   // Calculate proportion of adjacencies and contagion
   double sum_term = 0.0;
   for (int i = 0; i < n_classes; i++) {
     for (int j = 0; j < n_classes; j++) {
       if (adj_matrix[i][j] > 0) {
         double p_ij = static_cast<double>(adj_matrix[i][j]) / n_adjacencies;
         sum_term += p_ij * std::log(p_ij);
       }
     }
   }

   double contagion_val = (1.0 + sum_term / (2.0 * std::log(n_classes))) * 100.0;

   return contagion_val;
 }
