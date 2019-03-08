install.packages("ISLR")
require(ISLR)

install.packages("tree")
require(tree)

data(package = "ISLR")
carseats = Carseats

hist(carseats$Sales)

High = ifelse(carseats$Sales >= 8, "No", "Yes")
carseats = data.frame(carseats, High)

tree.carseats = tree(High~.-Sales, data = carseats)
summary(tree.carseats)
plot(tree.carseats)
text(tree.carseats, pretty = 0)
tree.carseats

#Prune the tree down
set.seed(101)
train=sample(1:nrow(carseats), 250)

tree.carseats = tree(High~.-Sales, carseats, subset=train)
plot(tree.carseats)
text(tree.carseats, pretty=0)

tree.pred = predict(tree.carseats, carseats[-train,], type="class")
with(carseats[-train,], table(tree.pred, High))

accuracy = (43 + 72) / 150

cv.carseats = cv.tree(tree.carseats, FUN = prune.misclass)
cv.carseats

plot(cv.carseats)

prune.carseats = prune.misclass(tree.carseats, best = 12)
plot(prune.carseats)
text(prune.carseats, pretty=0)

tree.pred = predict(prune.carseats, carseats[-train,], type="class")
with(carseats[-train,], table(tree.pred, High))

prunedTreeAccuracy = (39 + 74) / 150
