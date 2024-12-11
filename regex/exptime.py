import re
import timeit
from math import exp, log

repeats = 10
xs = range(20, 30)
ys = [
    timeit.timeit(
        f"regex.match(string)",
        globals={
            "regex": re.compile("(a?a){%d}" % x),
            "string": "a" * x,
        },
        number=repeats,
    )
    / repeats
    for x in xs
]


def mean(xs):
    return sum(xs) / len(xs)


def cov(xs, xmean, ys, ymean):
    return sum([(x - xmean) * (y - ymean) for x, y in zip(xs, ys)])


def linreg(xs, ys):
    xmean = mean(xs)
    ymean = mean(ys)
    sxy = cov(xs, xmean, ys, ymean)
    sxx = cov(xs, xmean, xs, xmean)
    syy = cov(ys, ymean, ys, ymean)
    beta = sxy / sxx
    alpha = ymean - beta * xmean
    rsquared = sxy * sxy / (sxx * syy)
    return alpha, beta, rsquared


alpha, beta, r2 = linreg(xs, [log(y) for y in ys])
ealpha = exp(alpha)
ebeta = exp(beta)

for x, y in zip(xs, ys):
    print(x, y)

print(f"Time is {ebeta:.3}^x * {ealpha:.3} (r^2 = {r2:.3})")

print("One year would be ", (log(365.25 * 24 * 60 * 60) - alpha) / beta)
