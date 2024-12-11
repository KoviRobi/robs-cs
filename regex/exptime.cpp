#include <math.h>
#include <stddef.h>
#include <time.h>

#include <iomanip>
#include <iostream>
#include <numeric>
#include <regex>
#include <stdexcept>
#include <string>


double measure(size_t i, size_t repeats)
{
    std::string teststr(2 * i, 'a');
    std::regex testre{"(a?a){" + std::to_string(i)+ "}"};
    double avg = 0.0;
    for (size_t rep = 0; rep < repeats; ++rep)
    {
        struct timespec start, end;
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
        std::regex_search(teststr.substr(i), testre);
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
        avg += (end.tv_sec + end.tv_nsec*1e-9) - (start.tv_sec + start.tv_nsec*1e-9);
    }
    return avg / static_cast<double>(repeats);
}

/// Covariance * sample size
double ncov(std::vector<double> xs, double xmean, std::vector<double> ys, double ymean)
{
    if (xs.size() != ys.size())
    {
        throw std::invalid_argument("cov args not equal sizes");
    }
    double cov = 0;
    for (size_t i = 0; i < xs.size(); ++i)
    {
        cov += (xs[i] - xmean) * (ys[i] - ymean);
    }
    return cov;
}

int main()
{
    size_t offset = 20;
    size_t count = 10;
    size_t repeats = 10;
    std::vector<double> xs;
    std::vector<double> ys;

    for (size_t i = offset; i < offset + count; ++i)
    {
        double time = measure(i, repeats);
        double ltime = log(time);
        std::cout << i << "\t" << time << "\t" << ltime
            << std::endl;
        xs.push_back(i);
        ys.push_back(ltime);
    }

    auto xmean = std::accumulate(xs.begin(), xs.end(), 0.0) / xs.size();
    auto ymean = std::accumulate(ys.begin(), ys.end(), 0.0) / ys.size();
    auto sxy = ncov(xs, xmean, ys, ymean);
    auto sxx = ncov(xs, xmean, xs, xmean);
    auto syy = ncov(ys, ymean, ys, ymean);
    auto beta = sxy / sxx;
    auto alpha = ymean - beta * xmean;
    auto ebeta = exp(beta);
    auto ealpha = exp(alpha);
    auto rsquared = sxy * sxy / (sxx * syy);

    std::cout
        << "Time is "
        << std::setprecision(3) << ebeta
        << "^x * "
        << std::setprecision(3) << ealpha
        << " (r^2 = "
        << std::setprecision(3) << rsquared
        << ")"
        << std::endl;

    std::cout << "One year would be "
        << std::setprecision(3) << (log(365.25 * 24 * 60 * 60) - alpha) / beta
        << std::endl;
}
