#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double contagion_cpp(NumericVector x, Rcpp::List dots = R_NilValue) {

  // dots ignored, but function signature matches R's ...

  int n = x.size();
  double window_size_d = std::sqrt((double)n);
  int window_size = (int)window_size_d;

  if (window_size * window_size != n)
    stop("Input length is not a perfect square.");

  NumericMatrix mat(window_size, window_size);

  int idx = 0;
  for (int i = 0; i < window_size; i++) {
    for (int j = 0; j < window_size; j++) {
      mat(i, j) = x[idx++];
    }
  }

  std::vector<double> x_valid;
  x_valid.reserve(n);
  for (int i = 0; i < n; i++)
    if (!NumericVector::is_na(x[i]))
      x_valid.push_back(x[i]);

    if (x_valid.size() < 2) return NA_REAL;

    std::sort(x_valid.begin(), x_valid.end());
    x_valid.erase(std::unique(x_valid.begin(), x_valid.end()), x_valid.end());
    int n_classes = x_valid.size();

    if (n_classes == 1) return 100.0;

    std::unordered_map<double,int> class_index;
    for (int i = 0; i < n_classes; i++)
      class_index[x_valid[i]] = i;

    NumericMatrix adj(n_classes, n_classes);
    int n_adj = 0;

    for (int i = 0; i < window_size; i++) {
      for (int j = 0; j < window_size - 1; j++) {
        double a = mat(i,j), b = mat(i,j+1);
        if (!NumericVector::is_na(a) && !NumericVector::is_na(b)) {
          adj(class_index[a], class_index[b]) += 1.0;
          n_adj++;
        }
      }
    }

    for (int i = 0; i < window_size - 1; i++) {
      for (int j = 0; j < window_size; j++) {
        double a = mat(i,j), b = mat(i+1,j);
        if (!NumericVector::is_na(a) && !NumericVector::is_na(b)) {
          adj(class_index[a], class_index[b]) += 1.0;
          n_adj++;
        }
      }
    }

    if (n_adj == 0) return NA_REAL;

    double sum_term = 0.0;
    for (int i = 0; i < n_classes; i++)
      for (int j = 0; j < n_classes; j++)
        if (adj(i,j) > 0) {
          double pij = adj(i,j) / n_adj;
          sum_term += pij * std::log(pij);
        }

        return (1.0 + sum_term / (2.0 * std::log((double)n_classes))) * 100.0;
}
