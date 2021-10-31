`%notin%` <- Negate(`%in%`)

summarise <- partial(summarise, .groups = 'drop')

percent <- function(num){
   scales::percent(num, decimal.mark = ".", accuracy = 0.1)
}

tab <- function(df, ...){
   count(df, ..., sort = T) %>%
      mutate(percent = percent(n / sum(n)))
}


fix_name <- function(s, truncate = 0){
   s <- stringr::str_replace_all(
         s,
         pattern = c(
            "'" = "",
            "\"" = "",
            "%" = "_percent_",
            "#" = "_number_",
            "Å" = "å",
            "Æ" = "æ",
            "Ø" = "ø",
            "\\A[\\h\\s\\p{Punctuation}\\p{Symbol}\\p{Separator}\\p{Other}]*(.*)$" = "\\1",
            "[\\h\\s\\p{Punctuation}\\p{Symbol}\\p{Separator}\\p{Other}]+" = ".")
         ) %>%
      snakecase::to_snake_case(numerals = "left")

   s <- if_else(
      str_sub(s, 1, 1) %in% as.character(0:9), paste0("n", s), s
      )

   s <- if_else(
      truncate > 0, str_sub(s, 1, truncate), s
      )

   s
   }


fix_names <- function(df, truncate = 0){
   names <- map_chr(names(df), ~fix_name(., truncate))

   while (any(duplicated(names))) {
      dupe_count <-
         vapply(
         seq_along(names), function(i) {
            sum(names[i] == names[1:i])
         },
         1L
         )

      names[dupe_count > 1] <-
         paste(
            names[dupe_count > 1],
            dupe_count[dupe_count > 1],
            sep = "_"
         )
      }

   names(df) <- names

   df
   }


d <- function(df){
   df %>% gt() %>%
      tab_options(
         data_row.padding = px(0),
         table.align = "left",
         table.margin.left = px(0),
         table.border.top.style = "hidden",
         table.border.bottom.style = "hidden",
         table.font.size = 12
         ) %>%
      cols_align(align = "left")
}


left_join0 <- function(dt1, dt2, ..., fill = 0){
   merged <- left_join(dt1, dt2, ...)
   index_new_col <- (ncol(dt1) + 1):ncol(merged)
   merged[, index_new_col][is.na(merged[, index_new_col])] <- fill
   merged
}

filter_dupes <- function(df, col){
   df %>% group_by(!!sym(col)) %>%
      mutate(n = n()) %>%
      filter(n > 1) %>%
      arrange(!!sym(col))
}

rows <- function(t){
   a <- 1:nrow(t)
   map(a, ~slice(t, .:.))
}

ci <- function(v, conf = 0.95){
   mean = mean(v)
   sd <- sd(v)
   n <- length(v)
   se <- sd / sqrt(n)
   error <- qt(conf + (1 - conf) / 2, df = n-1) * se
   return(c(mean - error, mean, mean + error))
}

summarise_cis <- function(df, v, conf = 0.95){
   df %>%
      drop_na(!!sym(v)) %>%
      summarise(
         ci.lower = ci(!!sym(v), conf)[1],
         mean = ci(!!sym(v), conf)[2],
         ci.upper = ci(!!sym(v), conf)[3]
      )
}

