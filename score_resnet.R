library(keras)

setwd("~/DataLand")


# instantiate the model
model <- application_resnet50(weights = 'imagenet')

save_model_hdf5(model, "resnet50.h5")

# load the image
img_path <- "cat.100.jpg"
img_path <- "possom.jpg"
img_path <- "canetoad.jpg"

img <- image_load(img_path, target_size = c(224,224))
x <- image_to_array(img)

# ensure we have a 4d tensor with single element in the batch dimension,
# the preprocess the input for prediction using resnet50
x <- array_reshape(x, c(1, dim(x)))
x <- imagenet_preprocess_input(x)

# make predictions then decode and print them
preds <- model %>% predict(x)
imagenet_decode_predictions(preds, top = 10)[[1]]


# retrain

