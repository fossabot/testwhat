
get_language <- function() {
  lang <- getOption("lang")
  if(is.null(lang)) {
    "en"
  } else {
    lang 
  }
}

no_msg <- "No message for the specified language."

# TEST_FUNCTION
build_arg_text <- function(n_args, args) {
  if (n_args == 0) {
    arg_text <- ""
  }
  else {
    arg_text <- switch(get_language(),
                       en = sprintf(" with %s %s", if (n_args == 1) "argument" else "arguments", collapse_args(args)),
                       fr = sprintf(" avec %s %s", if (n_args == 1) "l'argument" else "les arguments", collapse_args(args, " et ")),
                       es = sprintf(" con %s %s", if(n_args == 1) "el argumento" else "los argumentos", collapse_args(args, " y ")),
                       stop(no_msg))
  }
  return(arg_text)
}

build_additional_text <- function(index) {
  template <- switch(get_language(),
                     en = " in command %i of your solution",
                     fr = " dans l'instruction %i",
                     es = " en el comando %i de tu respuesta",
                     stop(no_msg))
  sprintf(template, index)
}

build_not_called_msg <- function(n_solution_calls, name, arg_text, additionaltext) {
  lang <- get_language()
  if(lang == "en") {
    if (n_solution_calls <= 1) n_text <- ""
    else if (n_solution_calls == 2) n_text <- " twice"
    else n_text <- sprintf(" %d times", n_solution_calls)
    not_called_msg <- sprintf("Did you call function <code>%s()</code>%s%s%s?",
                              name, n_text, arg_text, additionaltext)  
  } else if(lang == "fr") {
    not_called_msg <- sprintf("Avez-vous exécuté %d fois la fonction <code>%s()</code>%s%s?", 
                              n_solution_calls, name, arg_text, additionaltext)
  } else if(lang == "es") {
    if(n_solution_calls <= 1) n_text <- " una vez"
    else n_text <- sprintf(" %d veces", n_solution_calls)
    not_called_msg <- sprintf("¿Usaste la función <code>%s()</code>%s%s%s?",
                              name, n_text, arg_text, additionaltext)
  } else {
    stop(no_msg)
  }
  return(not_called_msg)
}

build_incorrect_msg <- function(n_solution_calls, n_args, arg_text, name, additionaltext) {
  lang <- get_language()
  if(lang == "en") {
    insert <- if (n_solution_calls == 1) "" else " always"
    val_text <- if (n_args == 1) "value" else "values"
    arg_text <- gsub(" with", "for", arg_text)  # whitespace is important
    incorrect_msg <- sprintf("It looks like you didn't%s set the correct %s %s in function <code>%s()</code>%s.",
                             insert, val_text, arg_text, name, additionaltext)  
  } else if(lang == "fr") {
    insert <- if(n_solution_calls == 1) "" else " toujours"
    val_text <- if (n_args == 1) "la bonne valeur" else "les bonnes valeurs"
    arg_text <- gsub(" avec l'", "à l'", arg_text)
    arg_text <- gsub(" avec les", "aux", arg_text)
    incorrect_msg <- sprintf("Il semblerait que vous n'ayez pas%s affecté %s %s dans la fonction <code>%s()</code>%s.",
                             insert, val_text, arg_text, name, additionaltext)
  } else if(lang == "es") {
    insert <- if(n_solution_calls == 1) "" else " siempre"
    val_text <- if (n_args == 1) "el valor correcto" else "los valores correctos"
    arg_text <- gsub(" con los", "de los", arg_text)
    arg_text <- gsub(" con el", "del", arg_text)
    incorrect_msg <- sprintf("Parece que no usaste%s %s %s en la función <code>%s()</code>%s.",
                             insert, val_text, arg_text, name, additionaltext)  
  } else {
    stop(no_msg)
  }
  
  
}

# TEST_OBJECT
build_undefined_object_msg <- function(name) {
  template <- switch(get_language(),
                     en = "Did you define <code>%s</code>?",
                     fr = "Avez-vous défini <code>%s</code> ?",
                     es = "¿Definiste el valor <code>%s</code>?",
                     stop(no_msg))
  sprintf(template, name)
}

build_incorrect_object_msg <- function(name) {
  template <- switch(get_language(),
                     en = "It looks like you didn't assign the correct value to <code>%s</code>.",
                     fr = "Il semblerait que vous n'ayez pas affecté la bonne valeur à <code>%s</code>.",
                     es = "Parece que no asignaste el valor correcto a <code>%s</code>.",
                     stop(no_msg))
  sprintf(template, name)
}

# TEST_OUTPUT_CONTAINS
build_incorrect_output_msg <- function(expr) {
  template <- switch(get_language(),
                     en = "Make sure to print <code>%s</code> to the console",
                     fr = "Assurez-vous d'afficher <code>%s</code> dans la console",
                     es = "Asegúrate de imprimir <code>%s</code> a la consola.")
  sprintf(template, expr)
}

