library(quarto)
library(tidyverse)

model_names <- list.dirs("stan/draws", full.names = FALSE, recursive = FALSE) |> 
  str_subset("woRId")
model_names

for (m in model_names[3]) {
  tryCatch ({
    file_name <- str_glue("{m}_result.html")
    quarto::quarto_render(
      input = "exam_3l-lmm_result.qmd",
      execute_params = list(model_name = m),
      output_file = file_name)
    
    file.rename(file_name, file.path("results", file_name))

    print(str_glue("Finished: {m}\n"))
  }, error = function(e){
    print(str_glue("Failed: {m}\n Error messamge: {e}"))
  })
}
