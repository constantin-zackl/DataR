library(plot3D)

# random Gene Expression Data
x = rnorm (100, sd = 1)
y = rnorm (100, mean = 1, sd = 0.4)
z = rnorm (100, sd = 0.5)

# PCA
data = cbind (x, y,z)
pca = prcomp (data)

#Scoreplot
plot (pca$x[,1], pca$x[,2], xlab = "PC1", ylab = "PC2", main = "Score Plot") 

# loading Plot
plot (pca$rotation[,1], pca$rotation[,2], xlab = "PC1", ylab= "PC2", type = "n", main = "Loading Plot")
arrows(x0 = 0, y0= 0, x1=pca$rotation[,1], y1 = pca$rotation[,2], col = "blue", length = "0.1")
text (pca$rotation[,1], pca$rotation[,2], label = colnames(data), col = "red")

# 3d scatter Plot of the whole data
scatter3D(x,y,z, pch=20, col = "blue", bty="b2", phi=0, main = "Gene Expression Data in 3D Space")

# screePlot
plot (pca, main = "Screeplot")

# rotated scater Plot to see the "pca view"
scatter3D(x, y,z, pch=20, col = "blue", bty="b2", phi=0, theta =0, main ="Rotated Expression Data")

# the rotation used for the "PCA View" may be different when rerunning the programm because the Expression Data is generated randomly
# the data behind the documentation Plots is available in the Github Folder. file: PCA_test_data.txt

# biplot
biplot(pca, choices = 1:2, main = "Biplot")