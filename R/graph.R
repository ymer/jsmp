library(ggplot2)

c1 <- "#00aae3"

.onAttach <- function(libname, pkgname) {
   update_geom_defaults(geom = "bar", new = list(fill = c1, color = "black"))
   update_geom_defaults(geom = "col", new = list(fill = c1, color = "black"))
   update_geom_defaults(geom = "line", new = list(color = c1))
   update_geom_defaults(geom = "point", new = list(color = c1))
   theme_update(
      axis.line.x = element_line(colour = "grey50", size=0.5, linetype='solid'),
      axis.line.y = element_line(colour = "grey50", size=0.5, linetype='solid'),
      panel.background=element_blank(),
      axis.title = element_text(size=12),
      axis.text = element_text(size=10),
      legend.text = element_text(size=12),
      title = element_text(size = 13),
      panel.grid.major.y = element_line(colour = "#DCDCDC", size = 0.1),
      axis.text.x = element_text(size = 10),
      plot.caption.position = "plot",
      plot.caption = element_text(hjust = 0, size = 7),
      plot.title = element_text(vjust = 5),
      plot.margin = margin(0.8, 0.1, 0.1, 0.1, "cm")
   )
}

gg_y_percent <- function(...) {scale_y_continuous(
   labels = scales::label_percent(accuracy = 1L),
   expand = expansion(mult = c(0, 0.04)),
   ...)}

gg_y_big <- function(...) {scale_y_continuous(
   labels = function(x) format(x, big.mark = ".", decimal.mark = ","), ...)}

gg_x_wrap <- function(...) {scale_x_discrete(labels = function(x) str_wrap(x, width = 20), ...)}

gg_x_rotate <- function(){theme(axis.text.x = element_text(angle = 45, hjust = 1))}

gg_y_zero <- function(...){
   scale_y_continuous(
      breaks = scales::pretty_breaks(),
      labels = function(x) format(x, big.mark = ".", decimal.mark = ","),
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.04)),
      ...)
}

gg_y_percent_zero <- function(...){
   scale_y_continuous(
      breaks = scales::pretty_breaks(),
      limits = c(0, NA),
      labels = scales::label_percent(accuracy = 1L),
      expand = expansion(mult = c(0, 0.04)),
      ...)
}


gg_legend_remove <- function(){theme(legend.position = "none")}

gg_legend_notitle <- function(){theme(legend.title = element_blank())}

gg_legend_bottom <- function(){theme(legend.position = "bottom")}

gg_regression_line <- function(){geom_smooth(method = "lm")}

gg_loess_line <- function(){geom_smooth(method = "loess")}

gg_y_remove <- function(){
   theme(
      axis.title.y = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.x = element_blank())
}

gg_x_remove <- function(){
   theme(
      axis.title.y = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.x = element_blank())
}

gg_hist_percent <- function(df, yvar){
   ggplot(df) +
      stat_count(mapping = aes(x={{yvar}}, y=..prop.., group=1)) +
      gg_y_percent_zero() +
      labs(y = "")
}


