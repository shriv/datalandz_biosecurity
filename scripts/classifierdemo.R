require(dplyr)
require(shiny)
require(keras)
require(rjson)
install_keras(tensorflow = "gpu")
setwd("~/datalandz_biosecurity")


# instantiate the model
model <- application_resnet50(weights = 'imagenet')

# load the image
img_path <- "./data/)"
img <- image_load(img_path, target_size = c(224,224))
x <- image_to_array(img)

# ensure we have a 4d tensor with single element in the batch dimension,
# the preprocess the input for prediction using resnet50
x <- array_reshape(x, c(1, dim(x)))
x <- imagenet_preprocess_input(x)

# make predictions then decode and print them
preds <- model %>% predict(x)
imagenet_decode_predictions(preds, top = 3)[[1]]
# }



labels <- labelImage("./data/anastrepha_striata.jpg")
print(labels)

json_data <- fromJSON(file="./UOR.json")

json_data <- lapply(json_data, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

dataset<- as.data.frame(do.call("rbind", json_data))

dataset %>% filter(sp_type_name == "Amphibian") %>% head() %>% select(name_sci)
