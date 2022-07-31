library(showtext)

font_add_google('Dokdo', 'Dokdo')
showtext_auto()

library(ggplot2)
library(hexSticker)

p <- ggplot(NULL, aes(x = 1, y = 1)) + xlim(-1,1) + ylim(0.8, 1.2) +
  annotate(
    geom = 'text',
    x = -0.3,
    y = 0.96,
    size = 50,
    family = 'Dokdo',
    label = '띄',
    colour = "#293462"
  ) +
  annotate(
    geom = 'text',
    x = 0,
    y = 1.07,
    size = 50,
    family = 'Dokdo',
    label = 'V',
    colour = "#D61C4E"
  ) +
  annotate(
    geom = 'text',
    x = 0.3,
    y = 0.96,
    size = 50,
    family = 'Dokdo',
    label = '어',
    colour = "#293462"
  ) +
  theme_void()
p
# for windows
sticker(
  p,
  s_x = 1,
  s_y = 1.2,
  s_width = 1.9,
  s_height = 1,
  package = "theeuh",
  p_size = 25,
  p_y = 0.65,
  filename = "man/figures/logo.png",
  h_fill = "#deeeef",
  p_color = "#212a4e",
  h_color = "#0099a4",
  url = "mrchypark.github.io/theeuh",
  u_size = 5,
  u_color = "#464646"
)
